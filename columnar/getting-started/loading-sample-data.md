# Sample Datasets

This section contains sample dataset that you can load into Hydra.

## GitHub Events Dataset

We prepared a dataset from the [GH Archive](https://www.gharchive.org/) that contains 9MB of events on `2015-01-01-15` that have 4000 rows. You can download the zip file [here](https://hydra-sample-data.s3.amazonaws.com/github\_events.tar.gz), unzip it, and load it into Hydra:

```
psql ... -f path_to_github_events.sql
```

or in `psql` console:

```
\i path_to_github_events.sql
```
