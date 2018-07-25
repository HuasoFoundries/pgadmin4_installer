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
        local("python3 %s " %(executable))
@task
def runwsgihttp():
	with virtualenv():
		pg4 = local('find . -wholename "*pgadmin4"', capture=True)
		local("uwsgi --http 127.0.0.1:5050 --chdir %(pg4)s --wsgi-file pgAdmin4.wsgi --master --threads 4" %{"pg4":pg4})


@task
def runwsgisocket():
	with virtualenv():
		pg4 = local('find . -wholename "*pgadmin4"', capture=True)
		local("uwsgi --socket 127.0.0.1:5050 --chdir %(pg4)s --wsgi-file pgAdmin4.wsgi --master --threads 4" %{"pg4":pg4})



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



