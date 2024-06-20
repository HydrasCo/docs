---
description: In-depth answers to common Hydra questions
---

# FAQs

### Q: Why is Hydra so fast?

A: Columnar storage, query parallelization, vectorized execution, column-level caching, and tuning Postgres.

Learn more about:

* [Columnar storage](../organize/data-modeling/row-vs-column-tables.md)
* [Vectorized execution](what-is-vectorized-execution.md)
* [Query parallelization](what-is-query-parallelization.md)

### **Q: How do I start using the columnar format on Postgres?**

A: Data is loaded into columnar format by default. Use Postgres normally.

We have changed the default table type (or _access method_) to be columnar. Now that columnar tables support updates, deletes, and vacuuming it is ready to be the default.

If you wish to use a traditional Postgres row-based table, also known as a heap table, you will need to add `USING heap` at the end of a `CREATE TABLE` statement, or convert the table after creation:

```sql
-- create a new row-based table
CREATE TABLE new_table (...) USING heap;

-- convert a columnar table to row format
SELECT columnar.alter_table_set_access_method('table_name', 'heap');
```

You can also change the default back to `heap`:

```sql
ALTER DATABASE database_name SET default_table_access_method = 'heap';
```

### Q: What operations is Hydra meant for? Provide examples.

A: Aggregates (COUNT, SUM, AVG), WHERE clauses, bulk INSERTs, UPDATE, DELETE…

**Columnar aggregates**:

<figure><img src="../.gitbook/assets/Screen Shot 2023-06-16 at 12.27.01 PM.png" alt="" width="563"><figcaption></figcaption></figure>

Query 0 is 512X faster:

```sql
SELECT COUNT(*) FROM hits;
```

Query 2 is 283X faster:

```sql
SELECT SUM(AdvEngineID), COUNT(*), AVG(ResolutionWidth) FROM hits;
```

Postgres COUNTs are slow? Not anymore! Hydra parallelizes and vectorizes aggregates (COUNT, SUM, AVG) to deliver the analytic speed you’ve always wanted on Postgres.

**Filtering (WHERE clauses)**:

Query 1 is 1,412X faster:

```sql
SELECT COUNT(*) FROM hits WHERE AdvEngineID <> 0;
```

Filters on Hydra’s columnar storage resulted in a 1,412X performance improvement. That’s road runner fast: _beep, beep!_

#### Tables with large numbers of columns where only some columns are accessed

When you have a large number of columns on your table (for example, a denormalized table) and need quick access to a subset of columns, Hydra can provide very fast access to just those columns without reading every column into memory.

### Q: What is columnar not meant for?

A: Frequent large updates, small transactions…

Hydra supports both row and columnar tables, and any storage format has tradeoffs.

Columnar is not best for:

* Datasets that have frequent large updates. While updates on Hydra Columnar are supported, they are slower than on heap tables.
* Small transactions, particularly when the query needs to return very quickly, since each columnar transaction is quite a bit slower than a heap transaction.
* Queries where traditional indexes provide high cardinality (i.e. are very effective), e.g. “needle in a haystack” problems, like “find by ID.” For this reason, reference join tables are best stored using a heap table.
* Very large single table datasets may need special care to perform well, like using table partitioning. We plan to improve this further in the future. If you are tackling a “big data” problem, reach out to us for help!
* Use cases where high concurrency is needed. Analytical queries on Hydra make extensive use of parallelization, and thus consume large amounts of resources, limiting the ability to run queries concurrently.

Where columnar falls short, traditional heap tables can often help. On Hydra you can mix both!

### Q: What Postgres features are unsupported on columnar?

* Columnar tables do not support logical replication.
* Foreign keys are not supported.

### Q: How does Hydra handle complex queries?

A: Try Incremental Materialized Views

[Materialized views](materialized-views.md) are precomputed database tables that store the results of a query. Hydra offers automatic updates to materialized views based on changes in the underlying base tables. This approach eliminates the need to recalculate the entire view, resulting in improved query performance and without time-consuming recomputation.

### Q: Why did you build Hydra on Postgres? Is Hydra a fork?

A: Postgres is the world’s most advanced relational database on earth. It’s open source, fully portable, and accessible to anyone for free. Postgres is highly extensible, meaning it can be augmented with new capabilities without forking from the core Postgres community and features.

Hydra is not a fork of Postgres. Hydra Columnar is a Postgres extension. Postgres’ extension model was released in PostgreSQL 9.1 in 2011. Prior to this release, forking was required to add 3rd party capabilities to Postgres. Hydra makes use of `tableam` (table access method API) which was added in Postgres 12 released in 2019.

### Q: Can I deploy Hydra on my own AWS account?

A: Yes, we offer Managed Infrastructure deployments. [Book a demo](https://www.hydra.so/get-in-touch) to join our early access program.

Use Hydra locally, in Hydra Cloud, or on your own AWS account. Hydra is a database for anyone, anywhere and that principle extends to the infrastructure account. With Hydra’s Managed Infrastructure Deployment, users can control the bare metal, use reserve instance pricing, and wrap Hydra in their VPC. We’ll automatically deploy Hydra via terraform.

### Q: Is Hydra ACID compliant?

A: Yes. Hydra extends Postgres, which has maintained ACID compliance since 2001.
