# Backups

## Backups, Hydra Cloud

Hydra fully manages backups for you. First, Production databases have 2 copies of your "live" data, one for each database in your cluster. As such, it is unlikely that your database will not need to be restored from backup, even if there is hardware failure.

In addition, Hydra streams all changes to your database to S3 by storing the Postgres WAL, or write-ahead logs. These are streamed to S3 using [wal-g](https://github.com/wal-g/wal-g). This allows Hydra to restore your database should failure occur. In addition, a daily snapshot, or "base backup", is stored in S3. This allows your database to be restored more quickly, since only today's WAL needs to be replayed. This also gives you the ability to perform [point-in-time recovery](disaster-recovery-and-point-in-time-recovery-pitr.md) should data loss occur via other means.

### Logical backups

Hydra does not perform logical backups, i.e. `pg_dump`, on your database. In cases where a large database change will occur, you may wish to perform a logical backup of specific tables in case the operation does not go as you expect. You can run `pg_dump` from your local computer or an EC2 instance. Our recommendation is to use `pg_dump -Fc --no-acl --no-owner` when performing any `pg_dump`. This will produce a compressed file that is easiest to restore. For details, please see our documentation on [loading data from Postgres](../centralize-data/load/from-postgres.md).

## Backups, Self-managed

Backups are an important part of managing any Postgres database, and that applies to Hydra as well. We recommend taking the time to set up and test a backup process that meets your business needs.

One option is to use the `pg_dump` utility, which allows you to create a logical backup of the database. This dump can be used to restore the database to the state at the time of the backup. The `pg_dump` command has several options that allow you to customize the format and contents of the backup, such as specifying which tables or schemas to include in the backup.

Another option is to use continuous archiving and point-in-time recovery (PITR), which involves constantly copying transaction log files (WAL files) to a remote location. This allows you to restore the database to any point in time by replaying the WAL files up to the desired point. This can be useful if you need to undo a series of changes that were made to the database.
