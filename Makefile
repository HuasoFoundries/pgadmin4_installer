SHELL = /usr/bin/env bash


YELLOW=\033[0;33m
RED=\033[0;31m
WHITE=\033[0m
GREEN=\u001B[32m


WSGI := $(shell command -v uwsgi 2> /dev/null)

PIP_URL = https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v3.1/pip/pgadmin4-3.1-py2.py3-none-any.whl

PIP_FILE := `basename $(PIP_URL)`

PIP_FILE_EXIST:= "$(wildcard $(PATH_TO_FILE))"

.PHONY: download_pgadmin clean-pyc  test_color
.PHONY: activate find_config create_service echo_uwsgi
.PHONY: install-deps-apt install_python2 install_python3 echo_link requirements_python3 requirements_python2

clean-pyc: ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

virtualenv_python3:
	rm -rf ./env
	python3 -m venv ./env


virtualenv_python2:
	rm -rf ./env
	virtualenv ./env


install_python2: download_pgadmin virtualenv_python2 


install_python3:  download_pgadmin virtualenv_python3 


download_pgadmin:
	@if [ ! -f $(PIP_FILE) ]; \
	then wget $(PIP_URL); \
	fi



copy_config:
	$(eval CONFIGFILE = $(shell find . -wholename "*pgadmin4/config.py"))
	$(eval CONFIGLOCAL= $(subst config,config_local,${CONFIGFILE}))
	@cp ${CONFIGFILE} ${CONFIGLOCAL}
	@sed -i 's/SERVER_MODE = True/SERVER_MODE = False/'  ${CONFIGLOCAL}
	@sudo ln -s -f ~/.pgadmin /var/lib/pgadmin
	@sudo mkdir -p /var/log/pgadmin
	@sudo ln -s -f ~/.pgadmin/pgadmin.log /var/log/pgadmin/pgadmin4.log


## Install Python dependencies
requirements_python3:
	pip install --upgrade pip ; \
	pip install -r requirements_python3.txt; \
	pip install $(PIP_FILE); \
	${MAKE} copy_config

	#FINISHED


requirements_python2:
	pip install --upgrade pip ; \
	pip install -r requirements_python2.txt; \
	pip install $(PIP_FILE); \
	${MAKE} copy_config
	#FINISHED

	

# Install Apt dependencies
install-deps-apt:
	sudo apt install python3 python2.7
	curl -O https://bootstrap.pypa.io/get-pip.py
	python3 get-pip.py --user
	python2.7 get-pip.py --user
	pip2 install virtualenvwrapper --user
	pip3 install fabric3 --user
	sudo apt-get install $$(cat AptFile | sed 's/#.*$$//')




create_service:
	$(eval PG4 = $(shell find . -wholename "*pgadmin4"))
	$(eval PWD= $(shell pwd))
	sudo mkdir -p  /etc/uwsgi/sites
	sudo mkdir -p  /var/log/uwsgi
	sudo chmod 777 /var/log/uwsgi -R
	sudo cat ./init_files/pgadmin.ini > ./init_files/pgadmin2.ini
	cat ./init_files/uwsgi.conf > ./init_files/uwsgi2.conf
	echo exec ${WSGI} --emperor /etc/uwsgi/sites >>  ./init_files/uwsgi2.conf
	echo chdir=${PWD}/${PG4} >> ./init_files/pgadmin2.ini
	echo home=${PWD} >> ./init_files/pgadmin2.ini
	sudo mv ./init_files/uwsgi2.conf  /etc/init/uwsgi.conf
	sudo mv ./init_files/pgadmin2.ini /etc/uwsgi/sites/pgadmin.ini