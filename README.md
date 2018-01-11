## Yet another test task

### Requirements:
Python 3.6, venv or virtualenv

### Usage:
Just `make server` or take a look into `Makefile`

More traditional way:
- `mkvirtualenv myenv`
- `pip install -r requirements.txt`
- `python manage.py runserver localhost:8080` -- port must be exactly 8080, it is hardcoded)
- navigate to `http://localhost:8080/`


To add additional records run `python manage.py mk_test_phone <number_of_records_to_add>` (it is one record by default)
