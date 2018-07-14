from fabric.api import *
from contextlib import contextmanager as _contextmanager

env.activate = '. ./env/bin/activate'


@_contextmanager
def virtualenv():
    with prefix(env.activate):
        yield

@task
def launch():
    with virtualenv():
    	executable = local('find . -wholename "*pgadmin4/pgAdmin4.py"', capture=True)
        local("python %s " %(executable))

@task
def install_python2():
	local("make install_python2")
	with virtualenv():
		local("make requirements_python2")


@task
def install_python3():
	local("make install_python3")
	with virtualenv():
		local("make requirements_python3")		