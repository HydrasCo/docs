---
description: >-
  External tables allow you to read and write data between Hydra and other data
  sources.
---

# Using Hydra External Tables

External Tables are data that lives in databases outside Hydra. You can use External Tables to select, join, and insert data to and from your data warehouse. For example, in the image below, we see Hydra tables represented as “local” and RDS tables as “external.” Data in RDS is being fetched and returned through Hydra.

<figure><img src="../../.gitbook/assets/fdw_diagram.jpg" alt=""><figcaption><p>External Tables can be used to query and combine data from multiple data sources.</p></figcaption></figure>

## Use Cases

Data warehouses are referred to as an organization’s source of truth because they aggregate data from different sources into a single, central data store to support data analysis. Traditionally, organizations configure data pipelines to copy data from multiple sources into the warehouse. While this approach works well for immutable data like analytics, rapidly changing data quickly becomes out of date. Constantly refreshing this data is expensive, slow, and restrictive.

External tables address the following problems:

* Data copying grows storage and pipeline costs.
* The warehouse’s data recency is limited to the data copy rate.
* Impossible to run ad-hoc queries without copying relevant tables to the warehouse.

With External Tables, queries execute on source databases directly, which greatly reduces frictions and costs outlined above. In our first example, we’ll show how to query RDS tables from Hydra.

## List of External Tables

* [Postgres](../centralize-data/stream/from-a-database-dbms.md)
* [MySQL](../centralize-data/stream/from-a-database-dbms.md)
* [S3 CSV](../centralize-data/load/from-s3.md)
* [S3 Parquet](../centralize-data/load/from-s3.md)
* [Google Sheets](../centralize-data/load/from-google-sheets.md)

## Other External Table Engines

Hydra is working on providing connections to other data sources. If you have a request, please reach out to us via our support channel.
