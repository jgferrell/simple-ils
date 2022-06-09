from flask import redirect, render_template, request, jsonify
from app import app, db
from app.logging import Log
import app.forms as forms
from app.models import ItemCopy, Empty
from MySQLdb import IntegrityError

def log(func_name, *args):
    Log.print('views', func_name, *args)

@app.route('/people', methods=['GET', 'POST'])
@app.route('/people.html', methods=['GET', 'POST'])
def people():
    """Serves up the People page."""
    form = forms.NewPerson()
    form.load_options()    
    if form.validate_on_submit():
        formatter = {
            'branch' : request.form['branch'],
            'last' : request.form['last']
        }
        if form.first.data:
            formatter['first'] = "%s" % request.form['first']
        else:
            formatter['first'] = 'NULL'
        if form.suffix.data:
            formatter['suffix'] = "%s" % request.form['suffix']
        else:
            formatter['suffix'] = 'NULL'
            
        try:
            db.insert('people', formatter)
        except IntegrityError as e:
            errno, errmsg = e.args[0], e.args[1]
            if errno == 1062:  # Duplicate entry found
                log('people', errmsg)
                msg = 'This person already exists.'
                form.last.errors.append(msg)
            else:
                raise e
    
    return render_template(
        "people.j2",
        people = db.select('people'),
        form = form
    )

@app.route('/branches', methods=['GET', 'POST'])
@app.route('/branches.html', methods=['GET', 'POST'])
def branches():
    """Serves up the Branches page."""
    form = forms.NewBranch()
    form.load_options()
    if form.validate_on_submit():
        log('branches', request.form)
        formatter = {
            'parent': request.form['parent'],
            'code': request.form['code'].upper(),
            'name': request.form['name'],
            'addr': request.form['addr']
        }
        try:
            db.insert('branches', formatter)
        except IntegrityError as e:
            errno, errmsg = e.args[0], e.args[1]
            if errno == 1062:  # Duplicate entry found
                log('branches', errmsg)
                msg = 'This branch code is already in use within '\
                    'this library system.'
                form.code.errors.append(msg)
            else:
                raise e
    
    return render_template(
        "branches.j2",
        branches = db.select('branches'),
        form = form
    )

@app.route('/items', methods=["POST", "GET"])
@app.route('/items.html', methods=["POST", "GET"])
def items():
    """Serves up the Catalog_items/Item_copies page."""
    
    # "CATALOG SEARCH" FORM:
    search = forms.SearchCatalog(prefix='catsearch')
    cat_where = '', {}
    if search.title.data and search.validate():
        log('items', 'Searching by title.')
        cat_where = 'catalog_title', {
            'query': request.form[search.query.name]
        }
    elif search.author.data and search.validate():
        log('items', 'Searching by author.')
        cat_where = 'catalog_author', {
            'query': request.form[search.query.name]
        }
    elif search.callno.data and search.validate():
        log('items', 'Searching by call number.')
        cat_where = 'catalog_call_number', {
            'query': request.form[search.query.name]
        }
    elif search.reset.data and search.validate():
        log('items', 'Displaying entire catalog.')
        search.query.data = ''
    else:
        log('items', 'Displaying entire catalog.')
    cat_items = db.select('catalog_items', cat_where[0], cat_where[1])

    # "ADD NEW CATALOG ITEM" FORM:
    newcat = forms.NewCatItem(prefix='newcat')
    newcat.load_options()
    if newcat.submit.data and newcat.validate():
        formatter = {
            'author': request.form[newcat.author.name],
            'call_number': request.form[newcat.callno.name],
            'title': request.form[newcat.title.name]
        }
        try:
            db.insert('catalog_items', formatter)
        except IntegrityError as e:
            errno, errmsg = e.args[0], e.args[1]
            if errno == 1062:  # Duplicate entry found
                log('items','Integrity violation:', errno, errmsg)
                msg = 'This call number is already in use within '\
                    'the catalog.'
                newcat.callno.errors.append(msg)
            else:
                raise e
        cat_items = db.select('catalog_items')

    # LOAD PAGE:
    return render_template(
        'items.j2',
        catalog_items = cat_items,
        search = search,
        newcat = newcat
    )

def get_item_copy_form(row_class, row_data, form_defaults, prefix):
    """Provides a JSON-wrapped HTML table row with form fields to add to
    or modify the Item_copies table.
    """
    modform = forms.ModifyItemCopy(obj=form_defaults, prefix=prefix)
    modform.load_options()
    json = jsonify(
        row = render_template(
            'item_copies_mod.j2',
            row_class = row_class,
            row_data = row_data,
            form = modform
        )
    )
    log('get_item_copy_form', 'JSON return:', json.data)
    return json
            
@app.route('/item_copies/get/form/update', methods=['GET'])
def get_item_copies_update_form():
    """Provides a JSON-wrapped HTML table row with form fields to
    update an item copy.
    """   
    prefix = 'moditem-' + request.args.get('id')
    return get_item_copy_form( 'modify-item-copy', request.args,
        ItemCopy(request.args), prefix)

@app.route('/item_copies/get/form/addnew', methods=['GET'])
def get_item_copies_addnew_form():
    """Provides a JSON-wrapped HTML table row with form fields to add
    a new item copy.
    """
    defaults = ItemCopy({
        'status': 100,
        'circs': 0
    })
    return get_item_copy_form( 'addnew-item-copy', Empty(), defaults,
        'addcopy')

@app.route('/item_copies/select/by_catitem', methods=['GET'])
def select_item_copies_by_catitem():
    """Returns a JSON with a 'rows' attribute. 'rows' contains a list
    of HTML table rows representing each copy of the provided catalog
    item.
    """
    formatter = {
        'catalog_id': request.args.get('catalog_id')
    }
    where = 'item_copies_are_catitem'
    item_copies = db.select('item_copies', where, formatter)
    json = jsonify(
        rows = [ render_template('item_copies.j2', row = row) \
                 for row in item_copies ],
        result = 'success'
    )
    log('select_item_copies_by_catitem', 'JSON return:', json.data)
    return json

def select_item_copy(where, formatter):
    """Provides a JSON-wrapped HTML table row for a single item copy."""
    row = db.select('item_copies', where, formatter)[0]
    html = render_template('item_copies.j2', row = row)
    json = jsonify(result = 'success', row = html)
    log('select_item_copy', 'JSON return:', json.data)
    return json

@app.route('/item_copies/select/by_copyid', methods=['GET'])
def select_item_copy_by_id(copy_id = None):
    """Provides a JSON-wrapped HTML table row for a single item copy
    based on the provided ID.
    """
    if copy_id is None:
        copy_id = request.args.get('id')
    where, formatter = 'item_copies_id', {'id': copy_id}
    return select_item_copy(where, formatter)

@app.route('/item_copies/select/by_barcode', methods=['GET'])
def select_item_copy_by_barcode(barcode = None):
    """Provides a JSON-wrapped HTML table row for a single item copy
    based on the provided barcode.
    """
    if barcode is None:
        barcode = request.args.get('barcode')
    where, formatter = 'item_copies_barcode', {'barcode': barcode}
    return select_item_copy(where, formatter)

@app.route('/item_copies/update/by_copyid', methods=['POST'])
def update_item_copy_by_id():
    """Attempts to update an item copy using the provided form data. A
    successful update returns a JSON with 'result' and 'row'
    attributes. An unsuccessful update returns a JSON with a 'result'
    and 'msg' attribute.

    The 'result' attribute will be either 'success' or 'error'. The
    'row' attribute contains a HTML table row of the item copy just
    modified. The 'msg' attribute contains information as to why the
    operation was unsuccessful.
    """
    where = 'item_copies_id'
    try:
        db.update('item_copies', where, request.form)
    except IntegrityError as e:
        errno, errmsg = e.args[0], e.args[1]
        if errno == 1062:  # Duplicate barcode found
            log('update_item_copy_by_id', errmsg)
            msg = 'This barcode is already in use within '\
                'the catalog.'
            json = jsonify(result = 'error', msg = msg)
            log('update_item_copy_by_id', 'JSON return:', json.data)
            # json.result = error; json.msg = error message for user
            return json
        else:
            raise e
    # json.result = success; json.row = HTML for table row
    json = select_item_copy_by_id(request.form.get('id'))
    return json

@app.route('/item_copies/update/addnew', methods=['POST'])
def create_new_item_copy():
    """Attempts to create a new item copy using the provided form
    data. A successful update returns a JSON with 'result' and 'row'
    attributes. An unsuccessful update returns a JSON with a 'result'
    and 'msg' attribute.

    The 'result' attribute will be either 'success' or 'error'. The
    'row' attribute contains a HTML table row of the item copy just
    created. The 'msg' attribute contains information as to why the
    operation was unsuccessful.
    """
    try:
        db.insert('item_copies', request.form)
    except IntegrityError as e:
        errno, errmsg = e.args[0], e.args[1]
        if errno == 1062:  # Duplicate entry found
            log('create_new_item_copy', errmsg)
            msg = 'This barcode is already in use within '\
                'the catalog.'
            json = jsonify(result = 'error', msg = msg)
            log('create_new_item_copy', 'JSON return:', json.data)
            # json.result = error; json.msg = error message for user
            return json
        else:
            raise e
    # json.result = success; json.row = HTML for table row
    json = select_item_copy_by_barcode(request.form.get('barcode'))
    return json

@app.route('/item_copies/delete/by_copyid', methods=['POST'])
def delete_item_copy_by_id():
    """Deletes an Item Copy by the provided ID."""
    formatter = {'id': request.form.get('id')}
    json = jsonify(
        result = db.delete('item_copies', 'item_copies_id', formatter)
    )
    return json

@app.route('/library_systems', methods=["POST", "GET"])
@app.route('/library_systems.html', methods=["POST", "GET"])
def library_systems():
    """Serves up the Library Systems page."""
    # "Add Library System" form
    form = forms.NewSystem()
    if form.validate_on_submit():
        formatter = {
            'code': request.form['code'].upper(),
            'name': request.form['name']
        }
        try:
            db.insert('library_systems', formatter)
        except IntegrityError as e:
            errno, errmsg = e.args[0], e.args[1]
            if errno == 1062:  # Duplicate entry found
                log('library_systems', errmsg)
                msg = 'This system code is already in use.'
                form.code.errors.append(msg)
            else:
                raise e
    
    # LOAD PAGE:
    return render_template(
        "library_systems.j2",
        libsystems = db.select('library_systems'),
        form = form
    )

@app.route('/')
@app.route('/index.html')
def root():
    """Serves up the homepage."""
    return render_template("index.j2")

@app.route('/reset', methods=["POST"])
def reset():
    """Resets the database to example values."""
    db.reset()
    return jsonify(result = 'success')
