.PHONY: download_pgadmin clean-pyc 
.PHONY: activate 
.PHONY: install-deps-apt install_python2 install_python3 echo_link requirements_python3 requirements_python2

clean-pyc: ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

PIP_URL = https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v1.5/pip/pgadmin4-1.5-py2.py3-none-any.whl 
PIP_FILE := `basename $(PIP_URL)`

PIP_FILE_EXIST:= "$(wildcard $(PATH_TO_FILE))"

 
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

## Install Python dependencies
requirements_python3:
	pip install --upgrade pip ; \
	pip install -r requirements_python3.txt; \
	pip install $(PIP_FILE); \
	find . -wholename "*pgadmin4/config.py" | awk '{split($$1,a,"config.py"); cmd="cp  "$$1" "a[1]"config_local.py"; system(cmd) }'
	#FINISHED


requirements_python2:
	pip install --upgrade pip ; \
	pip install -r requirements_python2.txt; \
	pip install $(PIP_FILE); \
	find . -wholename "*pgadmin4/config.py" | awk '{split($$1,a,"config.py"); cmd="cp  "$$1" "a[1]"config_local.py"; system(cmd) }'
	#FINISHED

	


 

# Install Apt dependencies
install-deps-apt:
	echo "PATH=\$PATH:~/.local/bin" >> ~/.bashrc
	source ~/.bashrc
	curl -O https://bootstrap.pypa.io/get-pip.py
	python3 get-pip.py
	apt-get install $$(cat AptFile | sed 's/#.*$$//')
	pip-2.7 install virtualenvwrapper


create_config:
	$(shell find -wholename "*pgadmin4/config.py" | awk '{split($$1,a,"config.py"); cmd="cp  "$$1" "a[1]"config_local.py"; system(cmd) }')