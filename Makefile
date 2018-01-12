export venv ?= $(abspath ./venv)
export PY36 := `which python3.6`
export PATH := $(venv)/bin:${PATH}
NUM_PHONES ?= 1


test: migrations
	ptw

server: migrations
	python manage.py runserver localhost:8080

migrations: reqs
	python manage.py migrate

.PHONY:
$(venv):
	$(PY36) -m virtualenv -p $(PY36) $(venv)

reqs: $(venv)
	pip install -r requirements.txt

loaddata: migrations
	python manage.py loaddata fixtures.json

phones:
	python manage.py mk_test_phone ${NUM_PHONES}

clean:
	rm -rf $(venv)
