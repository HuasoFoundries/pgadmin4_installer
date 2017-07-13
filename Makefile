.PHONY: clean-pyc
.PHONY: install, requirements, lint
.PHONY: install-deps-apt install_python2 install_python3

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


install_python2: virtualenv_python2 requirements_python2


install_python3:  virtualenv_python3 requirements_python3


## Install Python dependencies
requirements_python3:
	@source ./env/bin/activate ; \
	pip install --upgrade pip ; \
	pip install -r requirements_python3.txt

requirements_python2:
	@source ./env/bin/activate ; \
	pip install --upgrade pip ; \
	pip install -r requirements_python2.txt



# Install Apt dependencies
install-deps-apt:
	echo "PATH=\$PATH:~/.local/bin" >> ~/.bashrc
	source ~/.bashrc
	curl -O https://bootstrap.pypa.io/get-pip.py
	python3 get-pip.py
	apt-get install $$(cat AptFile | sed 's/#.*$$//')
	pip-2.7 install virtualenvwrapper


