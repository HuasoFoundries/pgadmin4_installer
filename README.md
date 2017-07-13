# pgadmin4_installer
Steps to install pgAdmin4 in any machine

1. Install apt requirements by running `make install-deps-apt` (it might require running with sudo)

1. Find the latest pgAdmin4 release at [https://ftp.postgresql.org/pub/pgadmin/pgadmin4/](https://ftp.postgresql.org/pub/pgadmin/pgadmin4/)
 - it should be under v1.x/pip/pgadmin4*****.whl

2. Replace the value of the link in Makefile PIP_URL variable with the link to the latest release

3. Run install make tasks for python2 or python3, depending on what you prefer
 - make install_python2 or
 - make install_python3

4. Run in the shell
```sh
source ./env/bin/activate
```

5. Run in the shell
 - make requirements_python2 or
 - make requirements_python3


### Run locally

Start pgAdmin4 by running

```sh
./run_pgadmin.sh
```

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
sudo cp ./init_files/uwsgi.conf to /etc/init/uwsgi.conf
sudo cp ./init_files/pgadmin.ini to /etc/uwsgi/sites/pgadmin.ini
sudo service uwsgi start
sudo update-rc.d uwsgi defaults
sudo update-rc.d uwsgi enable
```
