# Using Hydra Columnar

## Should I use a row or columnar table?

Please see our documentation about [when to use row and columnar tables](../organize/data-modeling/row-vs-column-tables.md).

## Enabling Columnar

For Hydra Cloud databases, columnar is already enabled.

For Hydra open source, the default `postgres` database has columnar enabled.
Additional databases you create need to have columnar enabled by running the
query below as superuser:

```sql
CREATE EXTENSION IF NOT EXISTS columnar;
```

Once installed, you will not need superuser to utilize columnar tables.

## Using a columnar table

Hydra supports both columnar and traditional Postgres row-based (`heap`) tables.
Columnar is the default type of table created on Hydra.

```sql
CREATE TABLE my_columnar_table
(
	id INT,
	i1 INT,
	i2 INT8,
	n NUMERIC,
	t TEXT
);
```

You can explicitly create either a row-based or columnar table by adding the `USING`
keyword:

```sql
CREATE TABLE heap_table (...) USING heap;
CREATE TABLE columnar_table (...) USING columnar;
```

Once created, the table operates like a normal Postgres table. You can SELECT, INSERT,
UPDATE, DELETE, and ALTER TABLE like you would expect, with a few restrictions:

* Columnar does not support logical replication. Creating a subscription on a columnar
table will cause any writes to that table to return an error.
* Foreign keys are not supported.
* Indexing may cause some queries to run slower; in many cases,
indexes are not necessary. For more information, [please read our documentation on using indexes](../concepts/optimizing-query-performance.md#indexes-and-indexing-strategies).
* BRIN indexes are not supported.

## Converting From Row to Columnar

Hydra has a convenience function that will copy tables between row and columnar:

```sql
CREATE TABLE my_table (i INT8) USING heap;
-- convert to columnar
SELECT columnar.alter_table_set_access_method('my_table', 'columnar');
-- convert back to row (heap)
SELECT columnar.alter_table_set_access_method('my_table', 'heap');
```

Data can also be converted manually by copying. For instance:

```sql
CREATE TABLE table_heap (i INT8) USING heap;
CREATE TABLE table_columnar (LIKE table_heap) USING columnar;
INSERT INTO table_columnar SELECT * FROM table_heap;
```

## Default table type

The default table type for the default database is `columnar`. You can change
this using an `ALTER DATABASE` statement:

```sql
ALTER DATABASE database_name SET default_table_access_method = 'heap';
```

For any database you create manually with `CREATE DATABASE`, the default table
type is `heap`.

The name of the default database on Hydra Cloud can be found with your
credentials in the Hydra Dashboard. With Hydra Open Source, the default
database is `postgres`.

## Partitioning

Columnar tables can be used as partitions. A partitioned table may be made up
of any combination of row and columnar partitions. You can use this feature to
have archived data from previous months or years stored in columnar tables
while active data is added to a heap table.

```sql
CREATE TABLE parent(ts timestamptz, i int, n numeric, s text)
PARTITION BY RANGE (ts);

-- columnar partition
CREATE TABLE p0 PARTITION OF parent
FOR VALUES FROM ('2020-01-01') TO ('2020-02-01')
USING columnar;

-- columnar partition
CREATE TABLE p1 PARTITION OF parent
FOR VALUES FROM ('2020-02-01') TO ('2020-03-01')
USING columnar;

-- row partition
CREATE TABLE p2 PARTITION OF parent
FOR VALUES FROM ('2020-03-01') TO ('2020-04-01')
USING heap;

INSERT INTO parent VALUES ('2020-01-15', 10, 100, 'one thousand'); -- columnar
INSERT INTO parent VALUES ('2020-02-15', 20, 200, 'two thousand'); -- columnar
INSERT INTO parent VALUES ('2020-03-15', 30, 300, 'three thousand'); -- row
```

When performing operations on a partitioned table with a mix of row and
columnar partitions, take note of the behaviors for operations that
are supported on row tables but not columnar (e.g. tuple locks).

## Creating additional databases

Hydra allows you to create additional databases with the `CREATE DATABASE` command.
New databases will have the default table type set to `heap`. To change this, run:

```sql
CREATE EXTENSION IF NOT EXISTS columnar;
ALTER DATABASE new_database_name SET default_table_access_method = 'columnar';
```
