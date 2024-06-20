# Vector data types and similarity search

Hydra supports vector data types and similarity search, implemented with
[pgvector](https://github.com/pgvector/pgvector). For usage details, please see
the [README for pgvector](https://github.com/pgvector/pgvector/blob/master/README.md).

## Enabling the extension

You must enable the extension before using it. Note that if you create
additional databases (with `CREATE DATABASE`) you will need to enable it in
each database.

```sql
CREATE EXTENSION vector;
```

## Use with Hydra Columnar

Hydra Columnar implicitly supports vector data types and operations. However, it does
not support approximate nearest neighbor search since this requires the use of the
pgvector index, `ivfflat`. If use of `ivfflat` is desired, this feature can be used on
heap tables.

## Current version

Hydra's current version of pgvector is 0.4.4.
