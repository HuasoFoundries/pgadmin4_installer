# pgadmin4_installer
Steps to install pgAdmin4 in any machine

1. Check if `~/.local/bin` is in your `$PATH` environment variable, otherwise, run in your console:

```sh
	echo "PATH=$PATH:~/.local/bin" >> ~/.bashrc
	source ~/.bashrc
```

2. Install apt requirements by running `make install-deps-apt` (it might require running with sudo)

3. Find the latest pgAdmin4 release at [https://ftp.postgresql.org/pub/pgadmin/pgadmin4/](https://ftp.postgresql.org/pub/pgadmin/pgadmin4/)
 - it should be under v3.1/pip/pgadmin4*****.whl

4. Replace the value of the link in Makefile PIP_URL variable with the link to the latest release

5. At this point, `fabric` should have been installed in your machine. Use fabric tasks to install for python2 or 3
 
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

### Run as uwsgi

Start pgAdmin4 as an uwsgi process by running

Edit `./init_files/uwsgi.sh` replacing the placeholders with the current path.

For example 
 - <PATH/TO/THIS_REPO> could be `/opt/pgadmin4_installer`
 - <PATH/TO/PGADMIN4>  could be 
   - `/opt/pgadmin4_installer/env/lib/python3.5/site-packages/pgadmin4` if you used python3 or
   - `/opt/pgadmin4_installer/env/lib/python2.7/site-packages/pgadmin4` if you used python2

Then run in the console:

```sh
./init_files/uwsgi.sh
```

### Run as uwsgi service

Edit `./init_files/pgadmin.ini` replacing the placeholders with the current path.

For example 
 - <PATH/TO/THIS_REPO> could be `/opt/pgadmin4_installer`
 - <PATH/TO/PGADMIN4>  could be 
   - `/opt/pgadmin4_installer/env/lib/python3.5/site-packages/pgadmin4` if you used python3 or
   - `/opt/pgadmin4_installer/env/lib/python2.7/site-packages/pgadmin4` if you used python2

```sh
sudo cp ./init_files/uwsgi.conf  /etc/init/uwsgi.conf
sudo cp ./init_files/pgadmin.ini /etc/uwsgi/sites/pgadmin.ini
sudo service uwsgi start
sudo update-rc.d uwsgi defaults
sudo update-rc.d uwsgi enable
```
