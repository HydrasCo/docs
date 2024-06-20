---
description: >-
  Redshift is a popular data warehouse platform on AWS, and shares a lot of
  related code base with Hydra through Postgres. This document outlines
  migration for the sample 'tickit' database.
---

# Migrate from Redshift

## Redshift Migration Overview

Amazon [Redshift](https://aws.amazon.com/redshift/) is a popular data warehouse cloud platform provided in AWS. This document outlines one of many possible migration paths to Hydra, geared to be accessible and demonstrate key considerations.

### Key Considerations

Redshift is a heavily modified version of PostgresSQL, making migration from Redshift to Hydra easier. However, there are some key differences which need to be addressed in the migration.

* Code:
  * Table Functions and triggers won't be present in Redshift DDLs. What ever is executed on the database will be external, and with some minor upgrades work directly in Hydra. While further work could be done to bring external code internal to Hydra, this document will take the simple path.
* Data Model:
  * Constraints are not enforced in Redshift, even if they appear in the DDL. When ported to Hydra, they will be enforced. Likely if there are constraints they are a hold over from a previous migration to Redshift, and hopefully there is a system upstream still cleansing the data to enforce them. If not, there will likely be a data cleansing step to the migration which if you are not confident in handling is easily helped by our Data Service Providers.
* Indexes are not enforced in Redshift.
* DISTKEYS and SORTKEYS are index like features which not supported in Hydra. They can safely be ignored in favor of other tuning options which are not discussed in this document.
* Security Model:
  * Roles are not supported in Redshift. Priveleges will otherwise come over okay, however this document strongly suggests that the security model needs to be fully evaluated and ported over carefully.

#### Simplifications

In this guide, we use a dataset which has been simplified. There are no foreign keys or other constraints (because Redshift doesn't use them). There is also no security model present. A production database will need to those address these concerns during migration. The tools chosen for this are meant to be accessible to any level of user. This document only uses a text editor of your choice, DBeaver, and the Redshift console to accomplish the migration. Command-line tools, purpose-built migration tools, or migration code in Python and Spark can be very helpful for migrating production databases. We suggest you familiarize yourself with these options before migrating.

### Setup

You can read about setting up the 'tickit' database for Redshift [in the AWS documentation](https://docs.aws.amazon.com/redshift/latest/dg/c\_sampledb.html). A free trial evaluation of Hydra is available here. Simply turning both on for the first time is all that is needed for this exercise. You will also need an S3 bucket with the permissions to talk to it from both Redshift and Hydra.

### Steps

1. Migrate schema
   * export
   * edit
   * import
2. Migrate Data
   * Export to S3 bucket
   * Setup S3 acess through Foreign Tables
   * Import the table data

## Migration Steps

### Setup

#### Setup Redshift

Setup a Redshift workgroup and Setting up the 'tickit' database is explained [in the AWS documentation](https://docs.aws.amazon.com/redshift/latest/dg/c\_sampledb.html).

#### Setup Hydra

Start a trial of Hydra if you haven't already done so.

### DBeaver connections

**Connecting to Redshift**

1. Click on the 'copy to clipboard' icon next to the word "jdbc:redshift\[...] to get the JDBC URL.
2. Select from the menu "Database" -> "New Connection from JDBC URL"
3. Paste in the jdbc URL, hit enter and watch the redshift database show up in the explorer window.

**Connecting to Hydra**

1. On the Hydra dashboard, in the "Connect" frame, click on "Show Connection Details" and then click on the copy-to-clipboard icon to the left of "Database URL"
2. Select from the menu "Database" -> "New Connection from JDBC URL"
3. Paste in the jdbc URL, hit enter and watch the redshift database show up in the explorer window.

### Export the Schema/DDL

The data model is the structure all of the data is poured into. Our first task is to move over the structure, which will require some minor modifications.

To retrieve the DDL as a whole we will use DBeaver. As noted in the considerations, there are some parts of the Redshift DDL which will not be compatible with Hydra. You will need to edit the output from DBeaver in a text editor of your choice, but that will be described later.

#### Steps to Extract Schema with DBeaver

1. Right click on "tickit", then follow through with the menu options: "Generate SQL" -> "DDL" and then select "Show full DDL"
2. You will see a new window with lots of text in it, at the bottom of that window click the button that says ‘Copy’
3. Open up text editor and paste the contents of the clipboard. Saving it is a good idea as well.

#### Steps to export each table out to Parquet:

In the RedShift query tool, use the following code on each table you want to extract. (change "Category" for each table name on both unload-from and to-s3 lines.)

*   Sample code to extract tables into S3 parquet files

    ```sql
    unload ('select * from sample_data_dev.tickit.category')   
    to 's3://tiamath/tickit/category_'
    IAM_ROLE default
    ALLOWOVERWRITE
    PARALLEL OFF
    FORMAT AS PARQUET;
    ```

#### Fix Schema with text editor

1. Comment out the following by placing two ‘--’ in front of every occurrence of (or just delete it)
   * ENCODE
   * DISTSTYLE
   * DISTKEY
2. The ALTER statement tries to mark ownership to the user from AWS. We can remove that since the user for our purposes the user that creates the schema will be the owner anyway. Comment out “ALTER” same as above
3. Comment or delete the three lines establishing the SORTKEY, that is also not used. Below is an example for just one of the tables after all the alterations are made. Everything commented out was from the original DDL downloaded from Redshift.

*   Example output after alterations

    ```sql
    --DROP TABLE tickit.users;
    CREATE TABLE IF NOT EXISTS tickit.users
    (
        userid INTEGER NOT NULL  -- ENCODE RAW
        ,username CHAR(8)   -- ENCODE lzo
        ,firstname VARCHAR(30)   -- ENCODE lzo
        ,lastname VARCHAR(30)   -- ENCODE lzo
        ,city VARCHAR(30)   -- ENCODE lzo
        ,state CHAR(2)   -- ENCODE lzo
        ,email VARCHAR(100)   -- ENCODE lzo
        ,phone CHAR(14)   -- ENCODE lzo
        ,likesports BOOLEAN   -- ENCODE RAW
        ,liketheatre BOOLEAN   -- ENCODE RAW
        ,likeconcerts BOOLEAN   -- ENCODE RAW
        ,likejazz BOOLEAN   -- ENCODE RAW
        ,likeclassical BOOLEAN   -- ENCODE RAW
        ,likeopera BOOLEAN   -- ENCODE RAW
        ,likerock BOOLEAN   -- ENCODE RAW
        ,likevegas BOOLEAN   -- ENCODE RAW
        ,likebroadway BOOLEAN   -- ENCODE RAW
        ,likemusicals BOOLEAN   -- ENCODE RAW
    )

    -- DISTSTYLE KEY
     -- DISTKEY (userid)
     -- SORTKEY (
        -- userid
        -- )
    ;
    -- ALTER TABLE tickit.users owner to "admin";

    -- Permissions

    -- GRANT RULE, SELECT, REFERENCES, TRIGGER ON TABLE tickit.users TO "admin";
    -- GRANT SELECT ON TABLE tickit.users TO public;
    ```

#### Create the database in Hydra

1. Create a schema if you haven’t already done so
2. Using that schema, run the modified DDL sql from the step above

#### Create the foreign tables to access the S3 parquet

1.  Access to S3 through parquet\_s3\_fdw

    ```sql
    CREATE EXTENSION parquet_s3_fdw;

    CREATE SERVER parquet_s3_srv FOREIGN DATA WRAPPER parquet_s3_fdw OPTIONS (aws_region 'us-east-1');

    CREATE USER MAPPING FOR CURRENT_USER SERVER parquet_s3_srv OPTIONS (user '/ACCESSKEY/', password '/SECRETKEY/');
    Modify the CREATE TABLE statements for the foreign tables (example)
    CREATE foreign TABLE
    ```
2. Simplify the data types
   * All INTs and BOOLEAN to `int`. If you wish, you can shorten or lengthen the ints to different sized ints which will affect memory usage. You will need to re-convert the 0-1 boolean ints back to boolean. This can be done during the INSERT.
   * DATE and TIMESTAMP can be left alone
   * All VARCHAR and other strings to simply `text`

Example output:

```sql
CREATE foreign TABLE tickit.fdate
(
      dateid int -- SMALLINT NOT NULL  -- ENCODE RAW
      ,caldate DATE NOT NULL  -- ENCODE az64
      ,"day" text -- CHAR(3) NOT NULL  -- ENCODE lzo
      ,week int --SMALLINT NOT NULL  -- ENCODE az64
      ,"month" text --CHAR(5) NOT NULL  -- ENCODE lzo
      ,qtr text -- CHAR(5) NOT NULL  -- ENCODE lzo
      ,"year" int --SMALLINT NOT NULL  -- ENCODE az64
      ,holiday int --BOOLEAN  DEFAULT false -- ENCODE RAW
)
SERVER parquet_s3_srv
OPTIONS (
  filename 's3://tiamath/tickit/date_000.parquet'
);
```

3.  Insert the data from the foreign tables to Hydra:

    ```sql
    INSERT INTO tickit.category
    SELECT * FROM tickit.fcategory ;
    ```

In case there is any type casting that needs to be done, you will need to explicitly convert the fields. For example, below we convert from int to boolean:

````
```sql
INSERT INTO tickit.date (dateid, caldate, "day", week, "month", qtr, "year", holiday)
SELECT dateid, caldate, "day", week, "month", qtr, "year", holiday != 0
FROM tickit.fdate ;
```
````

### Conclusion

At this point, we have performed the main steps and considerations for migrating from Redshift. As noted in the beginning, this documentation has migrated the schema from Redshift and migrated data through a layover in S3. If more help is needed to modify code, security access models, or other items not in this documentation feel free to reach out to Hydra for professional assistance.
