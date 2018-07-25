# pgadmin4_installer
Steps to install pgAdmin4 in any machine

1. Make sure you have `python3` and `python2.7` installed. Otherwise, install then running:

```sh
sudo apt-get install python3 python2.7
```

2. Check if `~/.local/bin` is in your `$PATH` environment variable, otherwise, run in your console:

```sh
	echo "PATH=$PATH:~/.local/bin" >> ~/.bashrc
	source ~/.bashrc
```

3. Install apt requirements by running `make install-deps-apt` (your user must have sudo privileges)

4. Find the latest pgAdmin4 release at [https://ftp.postgresql.org/pub/pgadmin/pgadmin4/](https://ftp.postgresql.org/pub/pgadmin/pgadmin4/)
 - it should be under v3.1/pip/pgadmin4*****.whl

5. Replace the value of the link in Makefile PIP_URL variable with the link to the latest release

7. At this point, `fabric` should have been installed in your machine. Use fabric tasks to install for python2 or 3
 
```sh
fab install_python2
```

or

```sh
fab install_python3
```

The above scripts will install pgAdmin4 and its requirements, and copy the `config.py` file as `config_local.py`. Make any desired changes in `config_local.py` to customize the app's behavior.

### Important!!

Since the release 2.x, pgAdmin4 will set `SERVER_MODE = True` by default in its config file. If you want to run in desktop mode, **remember to edit**  `config_local.py` setting `SERVER_MODE = False`. Otherwise, `pgAdmin4` will try to create its local database in `/var/lib/pgadmin` instead of `~/.pgadmin`, and it will crash because you lack permissions.


### Run locally

Start pgAdmin4 by running

```sh
fab launch
```

Then open your browser at http://127.0.0.1:5050

## Run with uWSGI locally

Running with [uWSGI](http://uwsgi-docs.readthedocs.io/en/latest/) allows you to spawn multiple process exposing pgAdmin4. 

Start pgAdmin4 as an uWSGI process by running

```sh
fab runwsgihttp
```

This will spawn four uWSGI processes exposing them at http://127.0.0.1:5050

**however** uWSGI shines when you run it behing a reverse proxy such as Nginx


## Run with uWSGI behind a reverse proxy

Let's say you want to run pgAdmin4 on a production server. You should expose an nginx virtual host at port 80.

Said `vhost` configuration could be at `/etc/nginx/sites-enabled/pgadmin.mydomain.com` with the following contents:

```sh
upstream pgadmin {
    server 127.0.0.1:5050;
}

server {
   server_name  pgadmin.mydomain.com
   listen 80;
   charset utf-8;

   location / {
     include     /etc/nginx/uwsgi_params;
     uwsgi_pass  pgadmin;
   }
}
```

Then restart the nginx server with

```sh
sudo service nginx restart
```

Nginx will then forward incoming requests to internal port 5050 which you arent exposing to the internet.

Having done this, you can manually run uWSGI in socket mode **manually* by running:

```sh
fab runwsgisocket
```

**OR** you could run uWSGI as a service, so you don't need to keep the manually started process running.

Formerly, this README has some steps detailing how to manually create a uWSGI service. However, I found out it requires a lot of tinkering according to each machine particular configuration and its details are beyond the scope of the current repo.

I'd suggest using [supervisord](http://supervisord.org/) to run the above uWSGI scripts as a service.
