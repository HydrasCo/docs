---
description: >-
  Amazon S3 is a popular cloud-based storage service that is often used to store
  large amounts of data. You can load CSV data or Parquet data from S3 to Hydra.
---

# From S3

## Loading CSV data from S3

You can load data or run queries against CSV files stored on Amazon S3 using an **S3 CSV External Table**. S3 CSV External Tables are implemented using [`s3csv_fdw`](https://github.com/eligoenergy/s3csv\_fdw). To create a S3 CSV External Table, create a `data.csv` file with the following content:

```csv
1,o@example.com
2,jd@example.com
3,joe@example.com
```

Upload the file to S3 and create a `multicorn` S3 CSV foreign table, replacing `...` with your AWS credentials and S3 bucket name:

```sql
CREATE EXTENSION multicorn;
CREATE SERVER multicorn_s3 FOREIGN DATA WRAPPER multicorn
  OPTIONS (
    wrapper 's3fdw.s3fdw.S3Fdw'
  );
create foreign table users_csv (
  id int,
  email text
) server multicorn_s3 options (
  aws_access_key '...',
  aws_secret_key '...',
  bucket '...',
  filename 'data.csv'
);
```

You can now load this data into Hydra using a `INSERT ... SELECT` query:

```sql
INSERT INTO users (id, email)
SELECT id, email FROM users_csv;
```

## Loading Parquet data from S3

You can load data or run queries against [Apache Parquet files](https://parquet.apache.org/) stored on Amazon S3. S3 Parquet External Tables are implemented using [`parquet_s3_fdw`](https://github.com/hydradatabase/parquet\_s3\_fdw). As an example, we are using the same data from [here](https://github.com/Teradata/kylo/tree/master/samples/sample-data/parquet).

The column details are as followed:

```
column#  column_name        hive_datatype
=====================================================
1        registration_dttm  timestamp
2        id                 int
3        first_name         string
4        last_name          string
5        email              string
6        gender             string
7        ip_address         string
8        cc                 string
9        country            string
10       birthdate          string
11       salary             double
12       title              string
13       comments           string
```

Upload the parquet files to a S3 bucket folder called `sample-data`, and create a S3 Parquet foreign table, replacing `...` with your AWS credentials, region, and S3 bucket name:

```sql
CREATE EXTENSION parquet_s3_fdw;

CREATE SERVER parquet_s3_srv FOREIGN DATA WRAPPER parquet_s3_fdw OPTIONS (region '...');

CREATE USER MAPPING FOR CURRENT_USER SERVER parquet_s3_srv OPTIONS (user '...', password '...');

CREATE FOREIGN TABLE userdata (
    registration_dttm timestamp,
    id int,
    first_name text,
    last_name text,
    email text,
    gender text,
    ip_address text,
    cc text,
    country text,
    birthdate text,
    salary FLOAT8,
    title text,
    comments text
)
SERVER parquet_s3_srv
OPTIONS (
    dirname 's3://.../sample-data'
);
```

You can now read data from the Parquet file using `SELECT ... FROM userdata`. Note that every query will read the data again, incurring charges on your AWS account. For better performance and avoiding ongoing charges, we recommend caching the data locally in Hydra by creating a materialized view:

```sql
CREATE MATERIALIZED VIEW userdata_local
USING COLUMNAR
AS
SELECT * FROM userdata;
```

Or inserting it into a table:

```sql
INSERT INTO users (id, first_name, last_name, email)
SELECT id, first_name, last_name, email
FROM userdata;
```
