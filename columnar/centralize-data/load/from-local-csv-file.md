---
description: >-
  You can import a local CSV file using the `psql \COPY` command to Hydra
---

# From Local CSV File

Grab the `psql` command from the Hydra dashboard, and get into the `psql` console.
To import a CSV file using the `\COPY` command in `psql`, you first need to create a table with columns that match the order and data types of the data in the CSV file.
Then you can use the `\COPY` command to import the data from the CSV file into the table.

Considered a CSV file with path `path/to/file.csv` in your system:

```csv
name,email
owen,o@example.com
jd,jd@example.com
j,j@example.com
```

Here's an example:

```sql
-- Create a table with the same columns and data types as the CSV file

CREATE TABLE my_table (
    name text,
    email text,
    ...
);

-- Import the data from the CSV file into the table
\COPY my_table FROM 'path/to/file.csv' DELIMITER ',' CSV HEADER;
```

Replace the names and data types of the columns to match your actual CSV file, and replace `path/to/file.csv` with the actual path to the CSV file on your system.
The `DELIMITER` option specifies the character that separates the values in the CSV file (in this case, a comma), and the `CSV` and `HEADER` options tell psql to expect the file to be in CSV format and that the first row of the file contains column names, respectively.
It's a good idea to check the data after importing it to make sure it was imported correctly.
You can do this by running a `SELECT` query on the table to view the data.

For more information, you can refer to the `\COPY` command documentation in the `psql` [reference guide](https://www.postgresql.org/docs/current/sql-copy.html):

```sql
\COPY { table_name | ( query ) }
    [ ( column [, ...] ) ]
    FROM { 'filename' | STDIN }
    [ [ WITH ] ( option [, ...] ) ]
```

To learn more about the `\COPY` command and the options you can use with it, you can refer to the psql reference guide or type `\? COPY` in psql to view the help for this command.
