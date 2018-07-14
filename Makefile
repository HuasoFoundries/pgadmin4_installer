SHELL = /usr/bin/env bash


YELLOW=\033[0;33m
RED=\033[0;31m
WHITE=\033[0m
GREEN=\u001B[32m


PIP_URL = https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v3.1/pip/pgadmin4-3.1-py2.py3-none-any.whl

PIP_FILE := `basename $(PIP_URL)`

PIP_FILE_EXIST:= "$(wildcard $(PATH_TO_FILE))"

.PHONY: download_pgadmin clean-pyc  test_color
.PHONY: activate find_config
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

echo_link:
	@echo $(PIP_URL)


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
	@echo -e "Copied $(YELLOW)${CONFIGFILE}$(WHITE) TO $(GREEN)$(CONFIGLOCAL)$(WHITE)"
	@echo -e "$(RED)IMPORTANT:$(WHITE)"
	@echo -e "Edit $(GREEN)$(CONFIGLOCAL)$(WHITE) setting $(YELLOW)SERVER_MODE = False$(WHITE) to run in desktop mode"


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
	curl -O https://bootstrap.pypa.io/get-pip.py
	python3 get-pip.py --user
	python2.7 get-pip.py --user
	pip2 install virtualenvwrapper --user
	sudo apt-get install $$(cat AptFile | sed 's/#.*$$//')


create_config:
	$(shell find -wholename "*pgadmin4/config.py" | awk '{split($$1,a,"config.py"); cmd="cp  "$$1" "a[1]"config_local.py"; system(cmd) }')