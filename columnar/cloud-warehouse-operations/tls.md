---
description: >-
  Hydra is secured with end-to-end encryption with publicly-trusted
  certificates.
---

# TLS

{% hint style="warning" %}
You must use TLS (SSL) to connect to Hydra. Hydra does not support unencrypted connections.
{% endhint %}

Hydra has publicly-trusted certificates, issued by [Let's Encrypt](https://letsencrypt.org/), allowing you to connect safety and securely to your data warehouse from anywhere on the Internet.

* Whenever possible, we recommend validating the certificate. To do so, use `sslmode=verify-full` when connecting and configure your Postgres connection to read your public certificate bundle. More
* If you are unable to configure your Postgres connection, we recommend using `sslmode=require`.

For clients based on libpq, information on `sslmode` in [available in the Postgres documentation](https://www.postgresql.org/docs/current/libpq-ssl.html).

## GUI clients

For GUI clients, configuration for SSL will vary. Please look for SSL settings when configuring a connection. If you encounter issues, please check your client's documentation for more information. If you are still unable to connect, reach out to Hydra support and we'll do our best to assist you.

## Locating your root certificate bundle

To validate the certificate, you will need to know the location of your root certificate bundle. On many systems, this file is located at `/etc/ssl/cert.pem`.

If the file is not located in `/etc/ssl`, you can use `curl -v` to a secure URL and look for the `CAfile` line:

```shell-session
$ curl -v https://hydras.io/ 2>&1 | grep -i CAfile
*  CAfile: /etc/ssl/cert.pem
```

## Configuring psql

You have several options on how to connect with Hydra while validating the certificate. 

{% hint style="info" %}
You only need to use one of the following options to validate the certificate. Validating the certificate is recommended but optional. 
`psql` will automatically use SSL to connect to Hydra.
{% endhint %}

### Add sslrootcert to the connection string

The simplest option is to add the file to the end of the connection string using the parameter `sslrootcert`, as follows:

```shell
psql "postgres://.../d123456?sslmode=verify-full&sslrootcert=/etc/ssl/cert.pem"
```

### Add Hydra to the service file

You can manage and save your Hydra connection by creating an entry in your [service file](https://www.postgresql.org/docs/current/libpq-pgservice.html), located at `~/.pg_service.conf`.

```ini
[hydra]
user=u123456
password=UdW3zJT9FLfIpJrli47HMmL1
host=1ed22fba-b20a-6680-afd9-91fc7c62485e.us-east-1.aws.hydradb.io
port=5432
dbname=d123456
sslmode=verify-full
sslrootcert=/etc/ssl/cert.pem
```

Once you have added this entry, connect to your data warehouse using the name you specified at the top of block:

```shell
psql service=hydra
```

Any additional parameters will override your service entry. For example, you can use `psql service=hydra dbname=postgres` to connect to the `postgres` database.

### Always validate certificates

{% hint style="warning" %}
If you choose this path, `psql` will try to validate certificates when connecting to any Postgres database. This will cause connections to some other Postgres databases to return an error, even if you set `sslmode`.
{% endhint %}

You can instruct `psql` to always read your public certificate bundle my symlinking `~/.postgresql/root.crt` to your public root cert bundle:

```shell
mkdir -p ~/.postgresql
ln -s /etc/ssl/cert.pem ~/.postgres/root.crt
```

## From Your Application

You should refer to your application's Postgres library, but many libraries use `libpq` behind the scenes. You can configure `libpq` to read your cert bundle using the `PGSSLROOTCERT` environment variable. For example, add this environment variable to your application's environment:

```shell
PGSSLROOTCERT=/etc/ssl/cert.pem
```

Please double check the location of your CA cert bundle in your production environment.
