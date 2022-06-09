from app import app
import os
from app.local_settings import port as userport

if __name__ == "__main__":
    osport = int(os.environ.get('PORT', userport))
    app.run(port=osport)
