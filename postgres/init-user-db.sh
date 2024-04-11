#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE USER appdev;
	CREATE DATABASE appdev;
	GRANT ALL PRIVILEGES ON DATABASE appdev TO appdev;
    CREATE DATABASE apptest;
    CREATE DATABASE temp;
    GRANT ALL PRIVILEGES ON DATABASE apptest TO appdev;
    GRANT ALL PRIVILEGES ON DATABASE temp TO appdev;
EOSQL