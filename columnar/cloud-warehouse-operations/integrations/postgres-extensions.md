# Postgres Extensions

This is a list of extensions that are available in Hydra:

 * address_standardizer (3.2.1) - Used to parse an address into constituent elements. Generally used to support geocoding address normalization step.
 * address_standardizer-3 (3.2.1) - Used to parse an address into constituent elements. Generally used to support geocoding address normalization step.
 * address_standardizer_data_us (3.2.1) - Address Standardizer US dataset example
 * address_standardizer_data_us-3 (3.2.1) - Address Standardizer US dataset example
 * adminpack (2.1) - administrative functions for PostgreSQL
 * amcheck (1.3) - functions for verifying relation integrity
 * autoinc (1.0) - functions for autoincrementing fields
 * bloom (1.0) - bloom access method - signature file based index
 * btree_gin (1.3) - support for indexing common datatypes in GIN
 * btree_gist (1.6) - support for indexing common datatypes in GiST
 * citext (1.6) - data type for case-insensitive character strings
 * cube (1.5) - data type for multidimensional cubes
 * dblink (1.2) - connect to other PostgreSQL databases from within a database
 * decoderbufs (0.1.0) - Logical decoding plugin that delivers WAL stream changes using a Protocol Buffer format
 * dict_int (1.0) - text search dictionary template for integers
 * dict_xsyn (1.0) - text search dictionary template for extended synonym processing
 * earthdistance (1.1) - calculate great-circle distances on the surface of the Earth
 * extra_window_functions (1.0) -
 * file_fdw (1.0) - foreign-data wrapper for flat file access
 * first_last_agg (0.1.4) - first() and last() aggregate functions
 * fuzzystrmatch (1.1) - determine similarities and distance between strings
 * hll (2.16) - type for storing hyperloglog data
 * hstore (1.8) - data type for storing sets of (key, value) pairs
 * hstore_pllua (1.0) - Hstore transform for Lua
 * hstore_plluau (1.0) - Hstore transform for untrusted Lua
 * hstore_plpython3u (1.0) - transform between hstore and plpython3u
 * hypopg (1.3.1) - Hypothetical indexes for PostgreSQL
 * insert_username (1.0) - functions for tracking who changed a table
 * intagg (1.1) - integer aggregator and enumerator (obsolete)
 * intarray (1.5) - functions, operators, and index support for 1-D arrays of integers
 * isn (1.2) - data types for international product numbering standards
 * jsonb_plpython3u (1.0) - transform between jsonb and plpython3u
 * lo (1.1) - Large Object maintenance
 * ltree (1.2) - data type for hierarchical tree-like structures
 * ltree_plpython3u (1.0) - transform between ltree and plpython3u
 * moddatetime (1.0) - functions for tracking last modification time
 * multicorn (2.4) - Multicorn2 Python3.6+ bindings for Postgres 11++ Foreign Data Wrapper
 * mysql_fdw (1.1) - Foreign data wrapper for querying a MySQL server
 * old_snapshot (1.0) - utilities in support of old_snapshot_threshold
 * pageinspect (1.9) - inspect the contents of database pages at a low level
 * parquet_s3_fdw (0.3) - foreign-data wrapper for parquet on S3
 * pg_auth_mon (1.1) - monitor connection attempts per user
 * pg_buffercache (1.3) - examine the shared buffer cache
 * pg_cron (1.4-1) - Job scheduler for PostgreSQL
 * pg_dirtyread (2) - Read dead but unvacuumed rows from table
 * pg_freespacemap (1.2) - examine the free space map (FSM)
 * pg_mon (1.0) - monitor queries
 * pg_partman (4.7.1) - Extension to manage partitioned tables by time or ID
 * pg_permissions (1.2) - view object permissions and compare them with the desired state
 * pg_prewarm (1.2) - prewarm relation data
 * pg_profile (0.3.6) - PostgreSQL load profile repository and report builder
 * pg_repack (1.4.8) - Reorganize tables in PostgreSQL databases with minimal locks
 * pg_stat_kcache (2.2.1) - Kernel statistics gathering
 * pg_stat_statements (1.9) - track planning and execution statistics of all SQL statements executed
 * pg_surgery (1.0) - extension to perform surgery on a damaged relation
 * pg_tm_aux (1.1) - transfer manager auxilary functions
 * pg_trgm (1.6) - text similarity measurement and index searching based on trigrams
 * pg_visibility (1.2) - examine the visibility map (VM) and page-level visibility info
 * pgaudit (1.6.2) - provides auditing functionality
 * pgcrypto (1.3) - cryptographic functions
 * pgl_ddl_deploy (2.1) - automated ddl deployment using pglogical
 * pglogical (2.4.2) - PostgreSQL Logical Replication
 * pglogical_origin (1.0.0) - Dummy extension for compatibility when upgrading from Postgres 9.4
 * pglogical_ticker (1.4) - Have an accurate view on pglogical replication delay
 * pgq (3.5) - Generic queue for PostgreSQL
 * pgq_node (3.5) - Cascaded queue infrastructure
 * pgrowlocks (1.2) - show row-level locking information
 * pgstattuple (1.5) - show tuple-level statistics
 * pldbgapi (1.1) - server-side support for debugging PL/pgSQL functions
 * pllua (2.0) - Lua as a procedural language
 * plluau (2.0) - Lua as an untrusted procedural language
 * plpgsql (1.0) - PL/pgSQL procedural language
 * plpgsql_check (2.2) - extended check for plpgsql functions
 * plprofiler (4.1) - server-side support for profiling PL/pgSQL functions
 * plproxy (2.10.0) - Database partitioning implemented as procedural language
 * plpython3u (1.0) - PL/Python3U untrusted procedural language
 * pltcl (1.0) - PL/Tcl procedural language
 * pltclu (1.0) - PL/TclU untrusted procedural language
 * postgis (3.2.1) - PostGIS geometry and geography spatial types and functions
 * postgis-3 (3.2.1) - PostGIS geometry and geography spatial types and functions
 * postgis_raster (3.2.1) - PostGIS raster types and functions
 * postgis_raster-3 (3.2.1) - PostGIS raster types and functions
 * postgis_sfcgal (3.2.1) - PostGIS SFCGAL functions
 * postgis_sfcgal-3 (3.2.1) - PostGIS SFCGAL functions
 * postgis_tiger_geocoder (3.2.1) - PostGIS tiger geocoder and reverse geocoder
 * postgis_tiger_geocoder-3 (3.2.1) - PostGIS tiger geocoder and reverse geocoder
 * postgis_topology (3.2.1) - PostGIS topology spatial types and functions
 * postgis_topology-3 (3.2.1) - PostGIS topology spatial types and functions
 * postgres_fdw (1.1) - foreign-data wrapper for remote PostgreSQL servers
 * refint (1.0) - functions for implementing referential integrity (obsolete)
 * seg (1.4) - data type for representing line segments or floating-point intervals
 * set_user (3.0) - similar to SET ROLE but with added logging
 * sslinfo (1.2) - information about SSL certificates
 * tablefunc (1.0) - functions that manipulate whole tables, including crosstab
 * tcn (1.0) - Triggered change notifications
 * tsm_system_rows (1.0) - TABLESAMPLE method which accepts number of rows as a limit
 * tsm_system_time (1.0) - TABLESAMPLE method which accepts time in milliseconds as a limit
 * unaccent (1.1) - text search dictionary that removes accents
 * uuid-ossp (1.1) - generate universally unique identifiers (UUIDs)
 * vector (0.4.4) - vector data type and ivfflat access method
 * xml2 (1.1) - XPath querying and XSLT
