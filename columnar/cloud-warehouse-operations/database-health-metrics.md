# Database health metrics

_This article contains recommendations from [a blog post by Nate Matherson of ContainIQ](https://hydras.io/blog/2022-08-08-postgres-performance-monitoring-best-practices-and-tools). We will update this content with Hydra-specific recommendations soon._

## Key Hydra Metrics to Watch

Monitoring is a crucial aspect for any highly available and performant database. Monitoring helps database administrators to detect changes in user access behavior, pinpoint the reasons and translate the findings into insights for business value. PostgreSQL monitoring metrics are commonly categorized into **host system metrics** and **database metrics** that collectively help in efficiently identifying and mitigating potential concerns in real-time.

## System Resource Metrics

As the performance and health of any database typically rely on the underlying infrastructure of the host onto which it is deployed, system-level resource metrics help measure infrastructure resource usage that considerably impacts the performance of a database. Some of the host system resource metrics include:

**CPU Usage -** Complex queries and large batch updates on Postgres often cause an outpour of the CPU usage. As the Postgres database relies on the server’s compute power (CPU) to run complex queries and perform batch updates, continuous monitoring of the CPU usage metric help detect exceeding/approaching CPU usage and detect processes causing the surge. A common practice is to set up alerts when the CPU usage hits an alarming percentage (typically 85% of its allotted limit) to restrict an unresponsive database server.

**Memory Usage -** The system’s physical and swap memory (RAM) holds the data and instructions for low-latency processing. This makes memory usage a critical metric to monitor and observe for anomalies. Surges in memory usage are usually related to database configuration specifications such as **working memory (work\_mem)** or **shared buffers**, which define the memory limit to be used by a database. Similar to the CPU usage metric, administrators should also set alerts for spikes that consume anything above 85% of allocated memory usage.

**Network Metrics -** As Postgres clusters rely on network connections for replication and connection between servers, network metrics are important to monitor as any network complication with the database cluster can affect all other systems connecting to the application. Monitoring network connections help understand issues with server availability and hardware configuration.

Additionally, network failure or high-latency response from the database server can result in enormous log sizes filling up database storage. This can cause the database system to fail with an out-of-space error. Network metrics also help administrators monitor packet loss or latency which may be a result of network saturation, common misconfigurations, or a hardware related issue.

**Storage -** A surge in the storage of data or excessive access to disk storage can cause higher disk latency, server’s I/O throughput and delayed query processing. DBAs can monitor the disk’s read/write latency and read/write throughput of IO processes to baseline an ideal disk consumption and identify bottlenecks. An ideal disk usage should remain below 85%, while attributing 90% of baselined disk usage to a critical alert.

### Database Metrics

Database metrics describe how well Postgres can organize, access and process data, which help ensure the database runs optimally and is healthy. Some database metrics include:

**Active sessions -** The number of open connections currently present on the database server represents the active sessions for the database. The maximum number of active sessions Postgres can hold is predefined through the configurable parameter **max\_connections.**

For a database to run optimally, at any point the total active connections for the database are recommended to not exceed 90% of the max\_connections value. DBAs need to monitor the active connections and an alarmingly low difference between the maximum connections defined and active sessions should be flagged. This anomaly can typically indicate a networking issue, session locking or abuse of connection pools.

**Logs** -  Logs produced by the database include errors such as long-running queries, authentication issues, deadlock or FATAL errors. Monitoring log files is considered one of the most crucial activities in the identification of errors and root cause analysis. As a result, continuous monitoring of logs provides an early indication of anomalies that help mitigate similar issues proactively.

**Query performance -** It is important to understand query activity as using appropriate query patterns enables rapid and accurate data retrieval. Monitoring queries also allow DBAs to gain actionable insights from access patterns, improving database operations and performance. Administrators can also monitor the amount and size of specific queries (SELECT, INSERT, UPDATE, DELETE) on each Postgres instance.

**Replication delay -** PostgreSQL instances are usually replicated in **active-active** or **active-passive** clusters for high-availability. Lags in replication may often indicate issues in architecture, node resources or network connection. Monitoring replication state and replication lags help identify replication issues and ensure the delay does not exceed intended limits. This helps DBAs to maintain a highly-available ecosystem while ensuring replicated databases between connected nodes do not retain mismatched database versions.

**Cache Hit ratio -**  The cache hit rate defines the ratio between **the number of reads from cache memory** versus the **total number of reads from disk and cache combined**. Monitoring the ratio is crucial to analyzing the data reads and maintaining the proper ratio. Ideally, the cache hit rate should be 99%, meaning at least 99% of database reads should be from the cache memory and at most 1% from the disk.

**Index scan-total scan ratio -** Index scans utilize special lookup tables to optimize the retrieval of specific rows from a table. The ratio of index scans to total scans is key to the throughput and latency of IO operations, with a higher than 99% index scan:total scan ratio being desirable for optimized databases.

**Deadlock creation rate -** A deadlock is caused when two or more transactions are locked on the same database object, thereby creating a conflict. Postgres automatically aborts one of the transactions, and prints it out within the logs for deadlock errors. Correlating the error timestamp with the time a deadlock was triggered in the logs helps DBAs assess the conditions that caused the deadlock. Monitoring the rate of deadlock occurrence also helps DBAs prevent the system from propagating additional load on OS resources and causing delays in the future.

## Best Practices and Tools

Monitoring PostgreSQL is a multi-pronged undertaking that involves tracking various system resource metrics and events to ensure the database performs as expected. Following are some recommended practices and tools to simplify Postgres monitoring and prevent downtimes.

### Postgres Monitoring Best Practices

Some best practices for efficient PostgreSQL monitoring include:

**Create and Activate log\_checkpoints**

The Postgres log file records all queries sent to the database while including detailed information about each query used. A **checkpoint** is referred as a configuration parameter that helps monitor a write-ahead log sequence to indicate a stable, consistent state. Generating detailed logs for checkpoints provides enhanced visibility for database connection issues and related operations. It is recommended to enable the **log\_checkpoint** parameter for logging checkpoint verbose logs. The log data can subsequently be used to identify and troubleshoot performance-related issues of a database that occurs during a checkpoint operation.

**Tuning PostgreSQL Server Appropriately**

The default configurations of PostgreSQL ensure wide compatibility and are not tuned for any specific workloads. As a recommended practice, developers or DBAs should tune these default settings to high-level settings according to the workload requirements. As PostgreSQL configuration settings are dependent on the type of host used, the operating system and network infrastructure connecting the nodes, it is crucial to tune settings depending on the business-case, available hardware and open-source tools to ensure  enhanced performance and seamless collection of metrics for monitoring.

**Fine-Tune Query Parameters**

For improved database performance and quicker transactions, a diligent analysis of queries and optimizing them is significantly important. Some recommended optimization mechanisms for poorly performing queries include identifying and replacing slow queries, investigating unused or missing indexes, etc. DBAs should start with analyzing performance bottlenecks of queries and resolve them by either modifying the queries or changing/creating indexes, to get a finer execution plan.

To do so, it is recommended to utilize the `EXPLAIN` parameter with queries to display the query execution plan that is being used to run the query statement. Additionally adding `ANALYZE` along with the `EXPLAIN` parameter helps identify slower queries as it provides finer, more accurate details such as the total time spent on the query execution, the time required to finish a sort program, etc. It is also a suggested practice to maintain an appropriate index for each table and keep reviewing them periodically.

**Offload Large Tables**

As table size increases on Hydra's row heap tables, the speed will reduce for both reads and writes. Instead, offload your largest tables into columnar storage. Analytics queries can execute **30X faster** on columnar storage and observe a **3X- 4X data compression** benefit.

### Converting from Row to Columnar

Hydra has a convenience function that will copy your row table to columnar.

```sql
CREATE TABLE my_table (i INT8) USING heap;
-- convert to columnar
SELECT columnar.alter_table_set_access_method('my_table', 'columnar');
```

Data can also be converted manually by copying. For instance:

```sql
CREATE TABLE table_heap (i INT8) USING heap;
CREATE TABLE table_columnar (LIKE table_heap) USING columnar;
INSERT INTO table_columnar SELECT * FROM table_heap;
```

![Move largest tables into Hydra columnar format](https://hydras.io/assets/blog/2022-08-08/hydra-6de64f513f2b7a1731aba85b0b937c8b499f20423c3cb743970a288bc9e6488d.svg)

**Configure Appropriate Commit Interval**

In an auto-commit mode, the PostgreSQL server automatically commits transactions every 100 milliseconds. Holding open transactions for too long may result in the accumulation of a large number of uncommitted rows and strain the PostgreSQL server’s resources. To avoid this, it is recommended to set the optimum commit interval that matches the host’s memory and CPU limit, thereby ensuring there is no data loss due to commit failure.

## Ecosystem Monitoring Tools

Some popular tools that help simplify PostgreSQL monitoring include:

### pg\_stat\_statements

[This module](https://www.postgresql.org/docs/current/pgstatstatements.html) uses query identifier calculations to track the planning and execution statistics of all SQL statements the database server has executed. The module records the queries run against the database, extracts variables from the queries and saves the query’s performance and execution data. Instead of storing individual query data, the pg\_stat\_statements module parametrizes all queries run against the server and stores the aggregated result for future analysis.

### Prometheus with PostgreSQL Exporter

[Prometheus](https://prometheus.io/) integrates with the PostgreSQL exporter to extract database metrics such as queries per second (QPS), number of rows processed per second, database locks, active sessions, replications, etc. Prometheus contains a time-series database that stores these metrics and scrapes them for monitoring the PostgreSQL database performance and anomalies in database metrics.

![](https://hydras.io/assets/blog/2022-08-08/prometheus-46d43301d530552d186a4163dba5498997bc1e96a1f8e2094ebb5744ef0f8b32.png)[_image source: developpaper.com_](https://developpaper.com/)

Prometheus offers the flexibility to build custom metrics for analysis that are not inherently supported by PostgreSQL exporter. The Prometheus Alertmanager additionally helps to define and create alerts when metrics reach the threshold, facilitating real-time notifications for critical alerts. Prometheus also utilizes Grafana for creating metrics dashboards that help visualize the pattern, behavior, and anomalies in database performance.

### pganalyze

[pganalyze](https://pganalyze.com/) is a query and access library tool that enables Postgres monitoring through log insights. It is utilized for tracking slow queries, performance monitoring, setting alerts for critical issues and defining privileges.

<img src="https://hydras.io/assets/blog/2022-08-08/pganalyze-dc7b77c3804f2fc56fedb2f6911e8effd6046394586714f7bdcc765d7cf2b8f8.png" alt="" data-size="original">

Apart from highlighting performance issues, pganalyze also facilitates the root cause identification by enforcing insights into query execution plans and visualizing EXPLAIN outputs in a user-friendly tree view. The platform additionally allows query optimization by providing index recommendations and highlighting missing indexes based on the database schema and query workload statistics.

### explain.dalibo.com

A web UI for [visualizing and understanding EXPLAIN plans](https://explain.dalibo.com/). With this tool, a user only needs to paste the plans and queries to be used into a form and submit them with a single click. The platform subsequently helps calculate execution stats and visualizes them through a simple, intuitive UI.

![](https://hydras.io/assets/blog/2022-08-08/explain-9928f05dafc53fb91609469ec3c7c94b60df0b12ac5330ac69a1d0f8508fd165.png)
