# Postgre container with multiple database

- Multiple database cna be created in postgres on container start by  using the init scripts.
- Postgres container requires the scripts to be present in a location: `/docker-entrypoint-initdb.d/`
- It can be a sh script or an sql script.

**Example Script:**
```shell
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
```


The above script will create 3 databases appdev, apptest, temp.

## Docker file
```dockerfile
FROM postgres:latest
COPY init-user-db.sh /docker-entrypoint-initdb.d/
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD appdev
VOLUME ["PGAPPDEV:/var/lib/postgresql/data/pgdata"]
```

- copies the shell script to init location
- sets user and password for database
- Defines a volume

To build the image
```shell
docker build -f Containerfile -t pgappdev .
```

To run the container
```shell
docker run -p 5436:5432 --name pgappdev pgappdev
```
> To run in detached mode use `-d` switch