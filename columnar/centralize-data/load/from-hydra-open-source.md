# From Hydra Open Source

## Using pg\_dump to create a backup

First, capture a backup file of your existing database. You will need to know the hostname, username, password, and database name of the database you wish to capture.

```shell
pg_dump -Fc --no-acl --no-owner \
    -h your.db.hostname \
    -U username \
    databasename > mydb.dump
```

`pg_dump` has additional options if needed. For instance, if you wish to capture only specific tables in your database, use `-t tablename1 -t tablename2`.

## Restoring data into Hydra

Using the captured data backup, you can copy your data into Hydra using `pg_restore` as follows. You will need the hostname, username, password, and database name of your Hydra database. You can find these on the Hydra dashboard.

```shell
pg_restore --verbose --clean --no-acl --no-owner \
    -h hydra-hostname.us-east-1.hydras.io \
    -U username \
    -d databasename \
    mydb.dump
```
