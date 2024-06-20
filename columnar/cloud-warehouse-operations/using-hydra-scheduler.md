---
description: >-
  Hydra Scheduler is used to schedule tasks at a regular interval on your data
  warehouse.
---

# Using Hydra Scheduler

Hydra Scheduler is a cron-style task scheduler that can run arbitrary SQL inside your data warehouse on any schedule. You can use tasks to move data between data sources (using foreign data wrappers), move data from row to [columnar tables](../../features/columnar.md), perform transformations, refresh materialized views, or any other regular maintenance tasks.

Scheduler uses the standard cron syntax:

```
┌───────────── min (0 - 59)
│ ┌────────────── hour (0 - 23)
│ │ ┌─────────────── day of month (1 - 31)
│ │ │ ┌──────────────── month (1 - 12)
│ │ │ │ ┌───────────────── day of week (0 - 6) (0 to 6 are Sunday to
│ │ │ │ │                  Saturday, or use names; 7 is also Sunday)
* * * * *
```

In addition, you can use `@hourly`, `@daily`, `@weekly`, `@monthly`, and `@yearly` shortcuts. These are equivalent to:

```
0 * * * *    @hourly
0 0 * * *    @daily
0 0 * * 0    @weekly
0 0 1 * *    @monthly
0 0 1 1 *    @yearly
```

Note that the timezone used for all tasks is UTC.

## Administering tasks

All administration of tasks occur in the `postgres` database. Your Hydra user has permission to connect to this database for this purpose.

To connect to the database, connect normally, then switch to `postgres` using `\c postgres`.

```
$ psql service=hydra

d123456=> \c postgres

psql (13.7, server 13.6 (Ubuntu 13.6-1.pgdg18.04+1))
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
You are now connected to database "postgres" as user "u123456".
postgres=>
```

### Creating a task

To create a task:

```sql
SELECT cron.schedule_in_database(
  'refresh-abc', -- task name,
  '30 * * * *', -- schedule
  'd123456', -- database
  $$ REFRESH MATERIALIZED VIEW CONCURRENTLY abc $$ -- command
);
```

### Deleting a task

To delete a task:

```sql
SELECT cron.unschedule('refresh-abc');
```

### Modify, enable, or disable a task

You can alter any parameters about a task, such as its schedule, command, and whether it is currently active.

First you must obtain the job ID:

```sql
SELECT cron.jobid FROM cron.job WHERE jobname = 'refresh-abc';
```

You can then alter the task. `NULL` indicates that change is desired. The last parameter controls whether the task is disabled:

```sql
SELECT cron.alter_job(
  42,   -- job id
  NULL, -- schedule, NULL = do not change
  NULL, -- command, NULL = do not change
  NULL, -- database, NULL = do not change
  NULL, -- username, NULL = do not change
  false -- active, false=inactive, true=active
)
```

### Review tasks

The `cron.job` table contains all current jobs and their parameters.

```sql
SELECT * FROM cron.job;
```

#### Reviewing task logs

Each time a job runs, a record is placed in `cron.job_run_details`.

```sql
SELECT * FROM cron.job_run_details
ORDER BY start_time DESC
LIMIT 10
```

#### Deleting task logs

Cleaning the task logs is at your discretion. You could schedule a task to remove logs after a set time:

```sql
SELECT cron.schedule_in_database(
  'clean-cron-logs',
  '0 0 * * *',
  'postgres',
  $$ DELETE FROM cron.job_run_details WHERE end_time < now() - interval '7 days' $$
);
```

## Use Cases

Any SQL you can write can be turned into a scheduled task, but even better is writing a function you then schedule. This allows you to more easily write and test the function before scheduling the task. Functions can perform anything you need to do on your data warehouse.

### Update materialized views

[Materialized views](https://www.postgresql.org/docs/14/sql-creatematerializedview.html) are a great way to cache results of expensive analytical queries for your dashboards to consume. You can write a function to [refresh your materialized views](https://www.postgresql.org/docs/14/sql-refreshmaterializedview.html) periodically:

```sql
CREATE OR REPLACE FUNCTION refresh_materialize_views_hourly()
RETURNS void LANGUAGE PLPGSQL AS $function$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY abc;
  REFRESH MATERIALIZED VIEW CONCURRENTLY def;
END;
$function$;
```

You can then schedule this task:

```sql
SELECT cron.schedule_in_database(
  'refresh_materialize_views_hourly',
  '15 * * * *',
  'd123456',
  $$ SELECT refresh_materialize_views_hourly() $$
);
```

:warning: Refreshing too many views concurrently may cause a very large load spike on your database. You can use [`pg_sleep()`](https://www.postgresql.org/docs/current/functions-datetime.html#FUNCTIONS-DATETIME-DELAY) or multiple tasks to spread the load over time.

### Move data to columnar storage

You can create an hourly or daily process to move new data into columnar. This makes managing the incoming flow of data easier as you can replicate data into row-based tables at any interval, and then archive data in columnar storage once it no longer changes.

```sql
CREATE OR REPLACE FUNCTION copy_events_to_columnar()
RETURNS void LANGUAGE PLPGSQL AS $function$
BEGIN
  -- copy in new events
  INSERT INTO events_columnar
  SELECT *
  FROM events_row
  WHERE events_row.created_at > (
    SELECT MAX(created_at)
    FROM events_columnar
    -- adding this clause will greatly help with performance
    WHERE created_at > NOW() - interval '1 week'
  );

  -- clear the events_row table
  TRUNCATE events_row;
END;
$function$;
```

:warning: This query will only work as intended if some recent data exists in `events_columnar`. You should do an initial data load before running this function.

You can then schedule the task to move this data every day:

```sql
SELECT cron.schedule_in_database(
  'copy_events_to_columnar',
  '@daily',
  'd123456',
  $$ SELECT copy_events_to_columnar(); $$
);
```

As an added bonus, you can create a view to query from both tables:

```sql
CREATE VIEW events_all AS
SELECT * FROM events_columnar
UNION
SELECT * FROM events_row;
```
