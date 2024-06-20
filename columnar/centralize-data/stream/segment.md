# Segment

## Add Hydra as a Segment destination

1. Open the Hydra dashboard
2. Select the warehouse you wish to connect to Segment.
3. Click the button to reveal your credentials and copy the host, database, user, and password values. You will need this information to connect your database to Segment in a later step.
4. Open the Segment app. On the Overview page, click **Add Destination**.
5. Search for and select the Postgres destination.
6. Choose the source(s) you’d like to connect to Postgres, and click **Next**.
7. Enter the host, database, user, and password values you copied from Hydra in an earlier step, and click **Connect**. If Segment connected to your destination, you’ll see the Next Steps screen. If you receive an “Invalid database” error, check that your host, database, user, and password fields match the credentials found in the Hydra dashboard.

## Sync schedule

Your data will be available in Warehouses between 24 and 48 hours from your first sync. Your warehouse then syncs once or twice a day depending on your [Segment Plan](https://segment.com/pricing).

Segment allows Business Tier (BT) customers to schedule the time and frequency of warehouse data syncs.

If you are on a BT plan, you can schedule warehouse syncs by going to **Warehouse > Settings > Sync Schedule** in the Segment web app. You can schedule up to the number of syncs allowed on your billing plan.

![](https://segment.com/docs/connections/destinations/catalog/images/syncsched.png)

## Security

### Database user and permissions

Once you have your Hydra database running, you should do a few more things before connecting the database to Segment.

The default username and password gives Segment full access to your database. While you _could_ give these credentials directly to Segment, for security purposes you should instead create a separate “service” user. Do this for any other third-parties who connect with your database. This helps isolate access, and makes it easier to audit which accounts have done what.

To use the SQL commands here, connect to your Hydra database with your preferred Postgres client, like psql.

```
-- this command creates a user named "segment" that Segment will use when connecting to Hydra
CREATE USER segment WITH PASSWORD '<enter password here>';

-- allows the "segment" user to create new schemas and temporary tables on the specified database.
GRANT CREATE, TEMPORARY ON DATABASE <enter database name here> TO segment;
```

## Browse & Query

And now the fun part - browsing and querying the data!

You’ll notice in your Hydra database that a new schema has been created for each source that was synced. Under the production source schema a whole bunch of tables were created. You can see the tables in the Compose data browser “Tables” view:

When the Segment data is loaded to the Hydra database, several tables are created by default: `aliases`, `groups`, `identifies`, `pages`, `screens` and `tracks`. You might also have `accounts` and `users` tables if you use unique calls for groups and for identifies. To learn more about these default tables and their fields, see the [Segment schema documentation](https://segment.com/docs/connections/storage/warehouses/schema/).

All of the other tables will be event-specific, according to the event names and properties you use in your `track` calls. The number of tables will depend on the number of unique events you’re tracking. For example, at Compose, there is a track call for when customers view their deployments such as:

```
 analytics.track('deployments_show', {
 deployment_name: 'heroic-rabbitmq-62',
 deployment_type: 'RabbitMQ'
 });
```

![](https://segment.com/docs/images/duplicate.svg)

In the Hydra database, there will then be a table named “deployments\_show” which can be queried for that deployment to see how many times it was viewed:

```
 SELECT COUNT(id)
 -- Don't forget the schema: FROM <source>.<table>
 FROM production.deployments_show
 WHERE deployment_name = 'heroic-rabbitmq-62';
```

![](https://segment.com/docs/images/duplicate.svg)

The result is 18 times in the past two months by a particular database user. To verify, just join to the identifies table, which contains user data, through the `user_id` foreign key:

```
 SELECT DISTINCT i.name
 FROM production.identifies i
 JOIN production.deployments_show ds ON ds.user_id = i.user_id
 WHERE ds.deployment_name = 'heroic-rabbitmq-62';
```

![](https://segment.com/docs/images/duplicate.svg)

A more interesting query for this, however, might be to see how many deployments were created in November using the “deployments\_new” event:

```
 SELECT COUNT(DISTINCT id)
 FROM production.deployments_new
 WHERE original_timestamp &gt;= '2015-11-01'
 AND original_timestamp &lt; '2015-12-01';
```

![](https://segment.com/docs/images/duplicate.svg)

This way, you can create custom reports for analysis on the tracking data, using SQL as simple or as complex as needed, to gain insights which Segment-integrated tracking tools may not be able to easily find.

![](https://segment.com/docs/images/duplicate.svg)

## Best Practices

Once you have your data in Hydra, you can do even more with it. You might develop an app that performs various functions based on different events being loaded to the database, potentially using [RabbitMQ](https://www.compose.io/articles/going-from-postgresql-rows-to-rabbitmq-messages/) as your asynchronous message broker. For example, you might want a banner to appear once your 1000th customer has signed up. The data is at your fingertips; you just need to decide how to use it.

### Query Speed

The speed of your queries depends on the capabilities of the hardware you have chosen as well as the size of the dataset. The amount of data utilization in the cluster will also impact query speed. Check with your hosting provider or Postgres docs for performance best practices.

#### Single and Double Quotes in PostgreSQL

If you use double quotes on the name of a table, column, index, or other object when you create it, and if there is even one capital letter in that identifier, you will need to use double quotes every single time you query it.

Single quotes and double quotes in PostgreSQL have completely different jobs, and return completely different data types. Single quotes return text strings. Double quotes return identifiers, but with the case preserved.

If you create a table using double quotes:

```
CREATE TABLE "Example" (
 ...
);
```

![](https://segment.com/docs/images/duplicate.svg)

Segment has now created a table in which the table name has not been forced to lowercase, but which has preserved the capital E. This means that the following query will now fail:

```
select * from example;
ERROR: relation "example" does not exist
```

![](https://segment.com/docs/images/duplicate.svg)

For more information on single vs double follow [this link](http://blog.lerner.co.il/quoting-postgresql/).

## FAQ

### Can I add an index to my tables?

Yes! You can add indexes to your tables without blocking Segment syncs. However, Segment recommends limiting the number of indexes you have. Postgres’s native behavior requires that indexes update as more data is loaded, and this can slow down your Segment syncs.

## Troubleshooting

### Permission denied for database

The syncs are failing due to a permissions issue. The user you configured does not have permission to connect to the appropriate database. To resolve these errors: connect to your warehouse using the owner account, or grant permissions to the account you use to connect to Segment. You can correct these permissions by running the following SQL statement, replacing `<user>` with the account you use to connect to Segment:

`GRANT CONNECT ON DATABASE <database_name> TO <user>`

### Permission denied for schema

The syncs for the source, `<source_name>`, are failing because of a permissions issue. In most cases, the user connected to Segment does not have permission to view the necessary schemas in the warehouse.

To resolve these errors, connect your warehouse using the owner account, or grant permissions to the user you use to connect to Segment. You can correct these permissions by running the following SQL statement - Replace `user` with the user you use to connect to Segment, and run this statement for each schema in the warehouse.

`GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA <schema_name> TO <user>`

### Dial TCP: no such host

Segment is unable to connect to the warehouse host, which is causing the syncs to fail. This error is usually due to an invalid host address, a warehouse hosted on a private IP, or a credentials issue.

In order to resolve the error, check the following settings:

* The host address listed in your Segment warehouse settings is correct
* The username and password you use to connect to your Segment workspace matches the username and password in Hydra

### Dial TCP: i/o timeout

The warehouse syncs are failing due to a connection issue:

`dial tcp XX.XXX.XXX.XXX:XXXX: i/o timeout`

This error can be caused for a few reasons:

* Your warehouse went offline.
* A network issue exists between Hydra and Segment.

Try connecting directly to your Hydra data warehouse to verify where the issue is occuring. If you continue to encounter an issue, contact Hydra Support.

### Schema does not exist

The syncs are failing due to a permissions issue. It looks like the user connected does not have permission to create schemas in your warehouse.

To resolve these errors Segment recommends connecting to your warehouse using the owner account, or granting permissions to the current account you use to connect to Segment. You can correct these permissions by running the following SQL statement - Replace `user` with the account you use to connect to Segment, and run this statement for each schema in the warehouse.

`GRANT CREATE ON DATABASE <database_name> TO <user>`
