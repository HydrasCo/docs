# With Jupyter Notebooks

In this tutorial, we'll show you how to use [Hydra](https://hydra.so/) (an open-source, Postgres data warehouse) and [JupySQL](https://github.com/ploomber/jupysql) to analyze large datasets efficiently.

Using JupySQL to combine Jupyter Notebooks with Hydra allows data scientists to easily query data in SQL directly from Jupyter. This opens up a wide array of potential use cases to combine data across a number of sources using Postgres, or access hosted data sources which could contain hundreds or thousands of gigabytes of data. Locally, you can experiment with importing and combining datasets using both Hydra's columnar tables, Postgres built-in row tables, and external data using FDWs.

## Requirements

To run this tutorial, you need to install the following Python packages:

```python
%pip install jupysql pandas pyarrow psycopg2-binary --quiet
```

_Note:_ to run the `\copy` command, you need `pgspecial<2`, we recommend you getting it via `conda install`; since `pip install` might give you some issues.

```python
%conda install "pgspecial<2" -c conda-forge -y --quiet
```

You also need Docker installed and running to start the Hydra instance.

## Starting a Hydra instance

Let's fetch the docker image and start the Hydra instance. The next command will take a couple of minutes as it needs to fetch the image from the repository:

```
docker run --name hydra -e POSTGRES_DB=db \
  -e POSTGRES_USER=user \
  -e POSTGRES_PASSWORD=password \
  -p 5432:5432 -d ghcr.io/hydradatabase/hydra
```

**Console output (1/1):**

```
fd21cec1f520e7a992c09c038a74f01a3611e3ab75d08dc4011447eba9a654ca
```

## Data download

Now, let's fetch some sample data. We'll be using the [NYC taxi dataset](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page):

```python
import pandas as pd

df = pd.read_parquet("https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2021-01.parquet")
print(f"Number of rows: {len(df):,}")

# we convert it to CSV so we can upload it using the \COPY postgres command
df.to_csv("taxi.csv", index=False)
```

**Console output (1/1):**

```
Number of rows: 1,369,769
```

As you can see, this dataset contains \~1.4M rows.

## Uploading data to Hydra

We're ready to upload our data; we'll load the [JupySQL](https://github.com/ploomber/jupysql) extension and start the database connection:

```python
%load_ext sql
```

```python
%sql postgresql://user:password@localhost/db
```

Let's create the table on Hydra. Note that Hydra uses columnar tables by
default, which will optimize storage for analytical queries. Below, we add the
[`USING columnar`](https://docs.hydra.so/concepts/what-is-columnar) clause
explicitly for clarity.

*Note:* to execute SQL on Jupyter via JupySQL, we must add `%%sql` at the beginning of the cell:

```sql
%%sql
CREATE TABLE "taxi" (
    "VendorID" DECIMAL NOT NULL,
    tpep_pickup_datetime TIMESTAMP WITHOUT TIME ZONE,
    tpep_dropoff_datetime TIMESTAMP WITHOUT TIME ZONE,
    passenger_count DECIMAL,
    trip_distance DECIMAL NOT NULL,
    "RatecodeID" DECIMAL,
    store_and_fwd_flag BOOLEAN,
    "PULocationID" DECIMAL NOT NULL,
    "DOLocationID" DECIMAL NOT NULL,
    payment_type DECIMAL NOT NULL,
    fare_amount DECIMAL NOT NULL,
    extra DECIMAL NOT NULL,
    mta_tax DECIMAL NOT NULL,
    tip_amount DECIMAL NOT NULL,
    tolls_amount DECIMAL NOT NULL,
improvement_surcharge DECIMAL NOT NULL,
    total_amount DECIMAL NOT NULL,
    congestion_surcharge DECIMAL,
    airport_fee DECIMAL
) USING columnar;
```

**Console output (1/2):**

```
*  postgresql://user:***@localhost/db
Done.
```

**Console output (2/2):**

```
[]
```

Let's now upload the data:

```sql
%%sql
\copy taxi from 'taxi.csv' WITH DELIMITER ',' CSV HEADER;
```

**Console output (1/2):**

```
*  postgresql://user:***@localhost/db
0 rows affected.
```

**Console output (2/2):**

Let's now query our data:

```sql
%%sql
SELECT COUNT(*) FROM taxi
```

**Console output (1/2):**

```
*  postgresql://user:***@localhost/db
1 rows affected.
```

**Console output (2/2):**

| count   |
| ------- |
| 1369769 |

We see that the \~1.4M are there. Let's take a look at the first rows:

```sql
%%sql
SELECT * FROM taxi
LIMIT 3
```

**Console output (1/2):**

```
*  postgresql://user:***@localhost/db
3 rows affected.
```

**Console output (2/2):**

| VendorID | tpep\_pickup\_datetime | tpep\_dropoff\_datetime | passenger\_count | trip\_distance | RatecodeID | store\_and\_fwd\_flag | PULocationID | DOLocationID | payment\_type | fare\_amount | extra | mta\_tax | tip\_amount | tolls\_amount | improvement\_surcharge | total\_amount | congestion\_surcharge | airport\_fee |
| -------- | ---------------------- | ----------------------- | ---------------- | -------------- | ---------- | --------------------- | ------------ | ------------ | ------------- | ------------ | ----- | -------- | ----------- | ------------- | ---------------------- | ------------- | --------------------- | ------------ |
| 1        | 2021-01-01 00:30:10    | 2021-01-01 00:36:12     | 1.0              | 2.1            | 1.0        | False                 | 142          | 43           | 2             | 8.0          | 3.0   | 0.5      | 0.0         | 0.0           | 0.3                    | 11.8          | 2.5                   | None         |
| 1        | 2021-01-01 00:51:20    | 2021-01-01 00:52:19     | 1.0              | 0.2            | 1.0        | False                 | 238          | 151          | 2             | 3.0          | 0.5   | 0.5      | 0.0         | 0.0           | 0.3                    | 4.3           | 0.0                   | None         |
| 1        | 2021-01-01 00:43:30    | 2021-01-01 01:11:06     | 1.0              | 14.7           | 1.0        | False                 | 132          | 165          | 1             | 42.0         | 0.5   | 0.5      | 8.65        | 0.0           | 0.3                    | 51.95         | 0.0                   | None         |

Hydra allows us to perform analytical queries efficiently. Let's compute the average trip distance given the passenger count:

```sql
%%sql
SELECT
    passenger_count, AVG(trip_distance) AS avg_trip_distance
FROM taxi
GROUP BY passenger_count
ORDER BY passenger_count ASC
```

**Console output (1/2):**

```
*  postgresql://user:***@localhost/db
10 rows affected.
```

**Console output (2/2):**

| passenger\_count | avg\_trip\_distance    |
| ---------------- | ---------------------- |
| 0.0              | 2.5424466811344758     |
| 1.0              | 2.6805563237138753     |
| 2.0              | 2.7948325921160876     |
| 3.0              | 2.7576410606577899     |
| 4.0              | 2.8681984015618327     |
| 5.0              | 2.6940995207308051     |
| 6.0              | 2.5745177825092658     |
| 7.0              | 11.1340000000000000    |
| 8.0              | 1.05000000000000000000 |
| None             | 29.6651257727346673    |

JupySQL comes with powerful plotting capabilities. Let's create a histogram of trip distance:

```python
%sqlplot histogram --table taxi --column trip_distance --bins 50
```

**Console output (1/2):**

```
<AxesSubplot: title={'center': "'trip_distance' from 'taxi'"}, xlabel='trip_distance', ylabel='Count'>
```

**Console output (2/2):**

![26-1](jupyter-images/26-1.png)

We cannot see much since there are some outliers. Let's find the 99th percentile:

```sql
%%sql
SELECT percentile_disc(0.99) WITHIN GROUP (ORDER BY trip_distance)
FROM taxi
```

**Console output (1/2):**

```
*  postgresql://user:***@localhost/db
1 rows affected.
```

**Console output (2/2):**

| percentile\_disc |
| ---------------- |
| 19.24            |

Now, let's use this value as a cutoff:

```sql
%%sql --save no_outliers --no-execute
SELECT trip_distance
FROM taxi
WHERE trip_distance < 19.24
```

**Console output (1/1):**

```
*  postgresql://user:***@localhost/db
Skipping execution...
```

```python
%sqlplot histogram --table no_outliers --column trip_distance --bins 50 --with no_outliers
```

**Console output (1/2):**

```
<AxesSubplot: title={'center': "'trip_distance' from 'no_outliers'"}, xlabel='trip_distance', ylabel='Count'>
```

**Console output (2/2):**

![31-1](jupyter-images/31-1.png)

Much better! We just created a histogram of 1.4M observations!

## Where to go from here

* [Hydra documenation](https://docs.hydra.so/)
* [JupySQL documentation](https://jupysql.readthedocs.io/en/latest/quick-start.html)

## Clean up

To finish the tutorial, let's shut down the container:

```python
! docker container ls
```

**Console output (1/1):**

```
CONTAINER ID   IMAGE                         COMMAND                  CREATED         STATUS         PORTS                    NAMES
fd21cec1f520   ghcr.io/hydradatabase/hydra   "docker-entrypoint.s…"   9 minutes ago   Up 9 minutes   0.0.0.0:5432->5432/tcp   hydra
```

```python
%%capture out
! docker container ls --filter ancestor=ghcr.io/hydradatabase/hydra --quiet
```

```python
container_id = out.stdout.strip()
print(f"Container id: {container_id}")
```

**Console output (1/1):**

```
Container id: fd21cec1f520
```

```python
! docker container stop {container_id}
```

**Console output (1/1):**

```
fd21cec1f520
```

```python
! docker container rm {container_id}
```

**Console output (1/1):**

```
fd21cec1f520
```

```python
! docker container ls
```

**Console output (1/1):**

```
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

## Package versions

For reproducibility, these are the package versions we used:

```python
# jupysql
import sql; sql.__version__
```

**Console output (1/1):**

```
'0.5.3dev'
```

```python
import pandas; pandas.__version__
```

**Console output (1/1):**

```
'1.5.2'
```

```python
import pyarrow; pyarrow.__version__
```

**Console output (1/1):**

```
'8.0.0'
```

```python
import psycopg2; psycopg2.__version__
```

**Console output (1/1):**

```
'2.9.3 (dt dec pq3 ext lo64)'
```

```python
import pgspecial; pgspecial.__version__
```

**Console output (1/1):**

```
'1.13.1'
```
