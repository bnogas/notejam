install: install-dev-reqs
	pip install -e .

install-dev-reqs:
	pip install -r requirements/dev.txt

install-docker-reqs:
	pip install -r requirements/docker.txt

install-tests-reqs:
	pip install -r requirements/tests.txt

runserver:
	notejam runserver 0.0.0.0:8000

tests-local:
	coverage run --source=src '/home/vagrant/bin/notejam' test --verbosity=1

tests-docker: install-tests-reqs # add flake8 before
	DJANGO_SETTINGS_MODULE=settings.tests \
	coverage run --source=src '/opt/notejam/virt/bin/notejam' test --verbosity=1

tests: flake8 tests-local

coverage: tests-local
	coverage report -m

flake8:
	flake8 --ignore="F405" --exclude=migrations src
