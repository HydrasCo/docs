# Updates and Deletes

Hydra Columnar tables support updates and deletes, yet remains an append-only
datastore. In order to achieve this, Hydra maintains metadata about which rows
in the table have been deleted or modified. Modified data is re-written to the
end of the table; you can think of an `UPDATE` as a `DELETE` followed by an
`INSERT`.

When querying, Hydra will automatically return only the latest version of your data.

## Read Performance

To maximize performance of `SELECT` queries, columnar tables should have a
maximum of data in every stripe. Like an `INSERT`, each transaction with an
`UPDATE` query will write a new stripe. To maximize the size of these stripes,
update as much data in a single transaction as possible. Alternatively, you can
run `VACUUM` on the table which will combine the most recent stripes into a
combined stripe of maximum size.

## Write Performance

Each updates or deletes query will lock the table, meaning multiple `UPDATE` or
`DELETE` queries on the same table will be executed serially (one at a time).
`UPDATE` queries rewrite any rows that are modified, and thus are relatively
slow. `DELETE` queries only modify metadata and thus complete quite quickly.

## Space Reclamation via VACUUM

The columnar store provides multiple methods to vacuum and clean up tables.
Among these are the standard `VACUUM` and `VACUUM FULL` functionality, but
also provided are UDFs, or User Defined Functions that help for incremental
vacuuming of large tables or tables with many holes.

### UDFs

Vacuuming requires an exclusive lock while the data that is part of the
table is reorganized and consolidated. This can cause other queries to
pause until the vacuum is complete, thus stalling other activity in the
database.

Using the vacuum UDF, you can specify the number of `stripes` to consolidate
in order to lower the amount of time where a table is locked.

```
SELECT columnar.vacuum('mytable', 25);
```

Using the optional stripe count argument, a vacuum can be performed
incrementally. A value will return of how many stripes were modified.
Calling this function repeatedly is fine, and it will continue to vacuum
the table until there is nothing more to do, and will return `0` as the
count.

| Parameter    | Description                 | Default        |
| ------------ | --------------------------- | -------------- |
| table        | Table name to vacuum        | none, required |
| stripe_count | Number of stripes to vacuum | `0`, or all    |

### Vacuuming All

In addition, you are provided a convenience function that can vacuum a
whole schema, pausing between each vacuum and table to unlock and allow
for other queries to continue on the database.

```
SELECT columnar.vacuum_full();
```

By default, this will vacuum the `public` schema, but there are other options
to control the vacuuming process.

| Parameter    | Description                                                                                   | Default  |
| ------------ | --------------------------------------------------------------------------------------------- | -------- |
| schema       | Which schema to vacuum, if you have more than one schema, multiple calls will need to be made | `public` |
| sleep_time   | The amount of time to sleep, in seconds, between vacuum calls                                 | `0.1`    |
| stripe_count | Number of stripes to vacuum per table between calls                                           | `25`     |

#### Examples

```
SELECT columnar.vacuum_full('public');
SELECT columnar.vacuum_full(sleep_time => 0.5);
SELECT columnar.vacuum_full(stripe_count => 1000);
```

## Isolation

ℹ️ For terms used in this section, please refer to [the Postgres documentation on isolation levels][tx-iso].

[tx-iso]: https://www.postgresql.org/docs/current/transaction-iso.html

Hydra Columnar updates and deletes will meet the isolation level requested for
your current transaction (the default is `READ COMMITTED`). Keep in mind that
an `UPDATE` query is implemented as a `DELETE` followed by an `INSERT`. As new
data that is inserted in one transaction can appear in a second transaction in
`READ COMMITTED`, this can affect concurrent transactions even if the first
transaction was an `UPDATE`. While this satisfies `READ COMMITTED`, it may
result in unexpected behavior. This is also possible in heap (row-based)
tables, but heap tables contain additional metadata that limit the impact of
this case.

For stronger isolation guarantees, `REPEATABLE READ` is recommended. In this
isolation level, your transaction will be cancelled if it references data that
has been modified by another transaction. In this case, your application should
be prepared to retry the transaction.
