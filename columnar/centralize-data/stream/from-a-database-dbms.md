# From a database (DBMS)

Hydra External Tables can be used to import data into your Hydra data warehouse. Hydra supports a variety of External Tables.

## Postgres External Tables

Postgres External Tables are implemented using [`postgres_fdw`](https://www.postgresql.org/docs/current/postgres-fdw.html). To set up a Postgres External Table from `psql`, run the following SQL, replacing `...` with your server's information.

```sql
CREATE EXTENSION postgres_fdw;

CREATE SERVER remote_pg_server FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '...', port '...', dbname '...');

CREATE USER MAPPING FOR CURRENT_USER SERVER remote_pg_server OPTIONS (user '...', password '...');
```

You can now create foreign tables from your remote Postgres database. You can [import all of your remote tables](https://www.postgresql.org/docs/current/sql-importforeignschema.html) at once as follows:

```sql
CREATE SCHEMA remote_pg;

IMPORT FOREIGN SCHEMA public FROM SERVER remote_pg_server INTO remote_pg;
```

💡 You can name the server and schema as you see fit.

You can now query your remote database from Hydra, including:

* Using `JOIN` between data in Hydra and in your remote database
* Inserting, updating, or deleting data

## MySQL External Tables

MySQL External Tables are implemented using [`mysql_fdw`](https://github.com/EnterpriseDB/mysql_fdw). To set up a MySQL External Table from `psql`, run the following SQL, replacing `...` with your server's information.

```sql
CREATE EXTENSION mysql_fdw;

CREATE SERVER remote_mysql_server FOREIGN DATA WRAPPER mysql_fdw OPTIONS (host '...', port '...');

CREATE USER MAPPING FOR CURRENT_USER SERVER remote_mysql_server OPTIONS (username '...', password '...');
```

You can now create foreign tables from your remote MySQL database. Assuming your remote MySQL database's name is `mysql`, you can [import all of your remote tables](https://www.postgresql.org/docs/current/sql-importforeignschema.html) at once as follows:

```sql
CREATE SCHEMA remote_mysql;

IMPORT FOREIGN SCHEMA mysql FROM SERVER remote_mysql_server INTO remote_mysql;
```

You can now query your remote database from Hydra, including:

* Using `JOIN` between data in Hydra and in your remote database
* Inserting, updating, or deleting data
