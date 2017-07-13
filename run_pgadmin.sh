#!/bin/bash
find . -wholename "*pgadmin4/pgAdmin4.py" -exec python {} \;

