install: install-dev-reqs
	pip install -e .

install-dev-reqs:
	pip install -r requirements/dev.txt

flake8:
	flake8 --ignore="F405" --exclude=migrations,samples notejam

runserver:
	notejam runserver 0.0.0.0:8000

tests-local:
	coverage run --source=src '/home/vagrant/bin/notejam' test --verbosity=1

tests: flake8 tests-local

coverage: tests-local
	coverage report -m

flake8:
	flake8 --ignore="F405" --exclude=migrations src
