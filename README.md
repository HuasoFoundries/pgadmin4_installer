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

6. Start pgAdmin4 by running
```sh
./run_pgadmin.sh
```