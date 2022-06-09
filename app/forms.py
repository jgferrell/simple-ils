# wtforms --- https://wtforms.readthedocs.io/en/3.0.x/
from wtforms import Form, SelectField, StringField, FormField, SubmitField, IntegerField
from wtforms.validators import InputRequired, Length, NumberRange
# flask_wtf -- https://flask-wtf.readthedocs.io/en/1.0.x/
from flask_wtf import FlaskForm

class NewSystem(FlaskForm):
    """FlaskForm for adding a Library System entity."""
    code = StringField(
        'System Code', [
            InputRequired(),
            Length(1, 6, 'System code cannot be more than 6 characters.')
        ]
    )
    name = StringField(
        'System Name', [
            InputRequired(),
            Length(1, 255, 'System name cannot be more than 255 '\
                   'characters.')                
        ]
    )
    submit = SubmitField('Add New System')


class NewBranch(FlaskForm):
    """FlaskForm for adding a library Branch entity."""
    parent = SelectField('Parent System')
    code = StringField(
        'Branch Code', [
            InputRequired(),
            Length(1, 6, 'Branch code cannot be more than 6 characters.')
        ]
    )
    name = StringField(
        'Branch Name', [
            InputRequired(),
            Length(1, 255, 'Branch name cannot be more than 255 '\
                   'characters.')                
        ]
    )
    addr = StringField(
        'Branch Address', [
            InputRequired(),
            Length(1, 255, 'Branch address cannot be more than '\
                   '255 characters.')
        ]
    )
    submit = SubmitField('Add New Branch')

    def load_options(self):
        """Populate SELECT field(s)."""
        from app import db
        self.parent.choices = [
            (
                row['id'], '%s — %s' % (row['code'], row['name'])
            )
            for row in db.select('library_systems')
        ]


class NewPerson(FlaskForm):
    """FlaskForm for adding a Person entity."""
    branch = SelectField('Home Branch', choices=[('NULL', '')])
    last = StringField(
        'Last Name', [
            InputRequired(),
            Length(1, 255, 'Last name cannot be more than 255 '\
                   'characters.')                
        ]
    )
    first = StringField(
        'First Name', [
            Length(0, 255, 'First name cannot be more than 255 '\
                   'characters.')                
        ]
    )
    suffix = StringField(
        'Suffix', [
            Length(0, 255, 'Suffix cannot be more than 255 '\
                   'characters.')                
        ]
    )
    submit = SubmitField('Add New Person')
    
    def load_options(self):
        """Populate SELECT field(s)."""
        from app import db
        for row in db.select('branches'):
            self.branch.choices.append((row['id'], row['full_code']))


class SearchCatalog(FlaskForm):
    """FlaskForm for searching Catalog Items."""
    query = StringField(
        'Search For', [
            InputRequired(),
            Length(1, 255, 'Query length cannot be more than '\
                   '255 characters.')
        ]
    )
    title = SubmitField('Title')
    author = SubmitField('Author')
    callno = SubmitField('Call Number')
    reset = SubmitField('Display All')


class NewCatItem(FlaskForm):
    """FlaskForm for adding a Catalog Item entity."""
    author = SelectField('Author')
    callno = StringField(
        'Item Call Number', [
            InputRequired(),
            Length(1, 255, 'Cannot be more than 255 characters.')
        ]
    )
    title = StringField(
        'Item Title', [
            InputRequired(),
            Length(1, 255, 'Branch address cannot be more than '\
                   '255 characters.')
        ]
    )
    submit = SubmitField('Add New Catalog Item')

    def load_options(self):
        """Populate SELECT field(s)."""
        from app import db
        self.author.choices = [
            (
                row['id'], row['full_name']
            )
            for row in db.select('people')
        ]


class ModifyItemCopy(FlaskForm):
    """FlaskForm for updating a Catalog Item entity."""
    home_branch = SelectField('Home Branch')
    barcode = StringField(
        'Copy Barcode', [
            InputRequired(),
            Length(1, 255, 'Barcode cannot be more than '\
                   '255 characters.')
        ]
    )
    status = IntegerField(
        'Status', [
            InputRequired(),
            NumberRange(min=-2147483648, max=2147483647)
        ]
    )
    circs = IntegerField(
        'Circs', [
            NumberRange(min=-2147483648, max=2147483647)
        ]
    )

    def load_options(self, default=None):
        """Populate SELECT field(s)."""
        from app import db
        self.home_branch.choices = [
            (
                row['id'], row['full_code']
            )
            for row in db.select('branches')
        ]
