# Optimizing Query Performance

## Column Cache

The columnar store makes extensive use of compression, allowing
for your data to be stored efficiently on disk and in memory as
compressed data.

While this is very helpful, in some circumstances a long running
analytical query can retrieve and decompress the same columns on
a recurring basis. In order to counter that, a column caching
mechanism is available to store uncompressed data in-memory, up
to a specified amount of memory per worker.

These uncompressed columns are then available for the lifetime
of a `SELECT` query, and are managed by the columnar store
directly. NOTE that this cache is not used for `UPDATE`, `DELETE`,
or `INSERT`, and are released after the `SELECT` query is complete.

### Enabling the Cache

Caching is be enabled or disabled with a GUC: `columnar.enable_column_cache`.
By default, the cache is enabled on Hydra Cloud, and disabled in Hydra Open
Source. For queries where the cache is not helpful, you may find slightly
better performance by disabling the cache.

```
-- enable the cache
set columnar.enable_column_cache = 't';

-- disable the cache
set columnar.enable_column_cache = 'f';
```

In addition, the cache size can be set, with a default of `200MB` per
process.

```
set columnar.column_cache_size = '2000MB';
```

This size can range between `20MB` and `20000MB`, and is consumed by
each parallel process. This means that if you have `8` parallel processes
and set the cache size to `2000MB`, then a query can consume up to
`8 * 2000000` bytes, or up to `16GB` of RAM, so it is very important to
choose a cache size that is appropriate for your workload.

## Vacuum Tables

Vacuuming tables will optimize tables that have had many inserts, updates, or
deletes. There are three levels of vacuum on columnar tables:

- `VACUUM table` will rewrite recently created stripes into optimal stripes of
  maximum size. If making many small inserts or updates into a columnar table,
  run `VACUUM` frequently to optimize the table.
- `SELECT columnar.vacuum_all()` will reclaim space from updated and deleted
  rows, writing new optimal stripes and compact the amount of space the table
  occupies.
- `VACUUM FULL table` will do a full rewrite of the table making fully
  optimized stripes. This operation is very expensive but produces the best
  results.

## Indexes and Indexing Strategies

You have the ability to use indexes with columnar storage, but it will not
behave in the same way that you have come to expect from a heap (row based)
storage solution. Under most cases, the plan that Postgres chooses will be
correct, and we've worked hard to ensure that when using the columnar storage
backend that the plan chosen will be the best one for accessing columnar data.

This is not always the case, so in addition to the normal per query adjustments
that you can make with Columnar and Postgres (`columnar.enable_custom_scan`,
`enable_seqscan`, etc), you can also use [pg_hint_plan](https://github.com/ossc-db/pg_hint_plan/blob/master/docs/description.md)
to help alter the query plan and make use of any indexes that you have created.
Note that some index types are not supported with the columnar storage engine,
such as bitmap or BRIN indexes, and some will be slower than the highly
optimized query plan that the columnar engine provides you.

`pg_hint_plan` uses a _comment_ syntax to allow you to attempt to alter the
created plan wherever possible:

```
EXPLAIN ANALYZE /*+ IndexScan(hits) */
SELECT url, COUNT(*)
FROM hits;
```

In this case, anything within the comment block `/*+` and `*/` is interpreted
as guidance for `pg_hint_plan`.

While there are some [limitations](https://github.com/ossc-db/pg_hint_plan/blob/master/docs/functional_limitations.md)
to what will work, generally it will try its best to give you the plan that
you asked for.

Some of the common hints include:

- `SeqScan(tablename)` - force a sequential scan on the table listed
- `IndexScan(tablename[indexname])` - force the use of an index scan on a specific table, and optionally an index to use by name
- `IndexOnlyScan(tablename[indexname])` - force the use of an index only scan on a specific table, and optional an index to use by name

A full list of hints can be found [here](https://github.com/ossc-db/pg_hint_plan/blob/master/docs/hint_list.md), and the documentation has many more settings and
options that are supported.
