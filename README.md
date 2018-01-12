## Yet another test task

### Requirements:
Python 3, venv or virtualenv

### Usage:
Just `make server` or take a look into `Makefile`

More traditional way:
- ``mkvirtualenv -p `which python3` myenv`` or `python3 -m venv myenv`
- `pip install -r requirements.txt`
- `python manage.py migrate` -- optional
- `python manage.py runserver localhost:8080` -- port must be exactly 8080, it is hardcoded.
- navigate to `http://localhost:8080/`


To create additional records run:
- `make phones` or
- `NUM_PHONES=10 make phones` or
- `python manage.py mk_test_phone [number_of_records_to_add]`
