---
description: Copy data from Postgres, including Supabase, Amazon RDS, Heroku Postgres, etc.
---

# From Postgres

You can use any Postgres tool to import data. The most common way is to use `pg_dump` and `pg_restore`.

## Using pg\_dump to create a backup

First, capture a backup file of your existing database. You will need to know the hostname, username, password, and database name of the database you wish to capture.

```shell
pg_dump -Fc --no-acl --no-owner \
    -h your.db.hostname \
    -U username \
    databasename > mydb.dump
```

### Tips and tricks

* `pg_dump` has many useful options. For instance, if you wish to capture only
  specific tables in your database, use `-t tablename1 -t tablename2`. Run
  `pg_dump --help` for more information.
* `pg_dumpall` can also be a useful tool if you are migrating multiple databases.
  Run `pg_dumpall --help` for more information.
* When importing, Hydra will create columnar tables by default. If you wish to
  import any of your tables as row-based (heap) tables, you will need to add
  `USING heap` at the end of the `CREATE TABLE` statements in your schema. To
  do this, create separate dumps of your data and your schema by using
  `--data-only` and `--schema-only`; do not use `-Fc` when dumping your
  schema. Then modify the schema SQL as needed for your needs.

### Restoring data into Hydra

Using the captured data backup, you can copy your data into Hydra using
`pg_restore` as follows. You will need the hostname, username, password, and
database name of your Hydra database. You can find these on the Hydra
dashboard.

```shell
pg_restore --verbose --clean --no-acl --no-owner \
    -h hydra-hostname.us-east-1.hydras.io \
    -U username \
    -d databasename \
    mydb.dump
```
