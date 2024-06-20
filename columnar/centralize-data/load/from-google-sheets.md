
# Load data from Google Sheets

With Hydra, you can import data and run queries against Google Spreadsheets. Google Spreadsheet External Tables are implemented using [`gspreadsheet_fdw`](https://github.com/hydradatabase/gspreadsheet\_fdw). To create a Google Spreadsheet External Table, create a Google Spreadsheet with some data:

* Put column names in the first row: untitled columns will not be read
* A blank row terminates the table (data below won't be read)
* Put it in the first (and only) worksheet

Get the spreadsheet ID from the HTTP URL. The ID is a 44-character string matching regexp `[A-Za-z0-9_]{44}`. It lives between the `/spreadsheets/d/` and possible trailing `/edit/blah` in the URL of your Google Spreadsheet.

Create a Google Service Account and enable Google Sheets API access by following [this guide](https://docs.gspread.org/en/latest/oauth2.html). Share your Google spreadsheet with the Google Service Account email that is in the format of `...@...gserviceaccount.com`.

Create a foreign table, replacing `...` with your Google Spreadsheet ID and Google Service Account credentials in JSON format:

```sql
CREATE EXTENSION multicorn;

CREATE SERVER multicorn_gspreadsheet FOREIGN DATA WRAPPER multicorn
  OPTIONS (
    wrapper 'gspreadsheet_fdw.GspreadsheetFdw'
  );

CREATE FOREIGN TABLE test_spreadsheet (
  id character varying,
  name   character varying
) server multicorn_gspreadsheet options(
  gskey '...',
  serviceaccount '...'
);
```
