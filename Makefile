install: install-dev-reqs
	pip install -e .

install-dev-reqs:
	pip install -r requirements/dev.txt

flake8:
	flake8 --ignore="F405" --exclude=migrations,samples notejam

runserver:
	notejam runserver 0.0.0.0:8000

