---
description: >-
  Hydra makes it easy to scale realtime apps and analytical reporting on
  Postgres.
layout:
  title:
    visible: true
  description:
    visible: false
  tableOfContents:
    visible: true
  outline:
    visible: true
  pagination:
    visible: true
---

# 🏠 Overview

<div align="left">

<figure><img src=".gitbook/assets/Screen Shot 2024-01-30 at 3.42.06 PM.png" alt=""><figcaption></figcaption></figure>

</div>

Hydra makes it easy to scale realtime apps and analytical reporting on Postgres. \
**Develop quicker. Scale faster**.

We developed Hydra Columnar, an open source database extension that adds an ultra fast columnar analytics engine to Postgres without the hassle of a database migration or rewriting application code.

The current version of Hydra Columnar is [v1.1.2](https://github.com/hydradatabase/hydra/blob/main/CHANGELOG.md).

## Getting Started

#### <img src=".gitbook/assets/image.png" alt="" data-size="line"> Install on macOS

The quickest way to try Hydra Columnar on macOS is using the Postgres Extension Manager pgxman with Homebrew.  pgxman is the package manager and community registry for all Postgres extensions. pgxman makes extension installation delightful and makes it easy to discover and use Postgres’ full capabilities in app development.

```sh
brew install pgxman/tap/pgxman
pgxman install hydra_columnar
```

#### <img src=".gitbook/assets/Group 36.png" alt="" data-size="line"> **Install on Linux**

The easiest way to install Hydra Columnar on Linux operating systems is to use the Postgres Extension Manager pgxman. Run the following command in your terminal and follow the on-screen getting started instructions. **Please note**: pgxman only supports Ubuntu 22.04 Jammy.

```bash
curl -sfL https://install.pgx.sh | sh -
pgxman install hydra_columnar
```

#### <img src=".gitbook/assets/Group 35.png" alt="" data-size="line"> **Deploy on Hydra Cloud**

Try the [Hydra Free Tier](https://dashboard.hydra.so/signup) to deploy a Postgres database with hydra\_columnar enabled on our fully managed cloud service. With Hydra Cloud, the default table access method is set to columnar. All data loaded into Hydra Cloud is converted and compressed into columnar format for ultra fast analytical performance. Simply connect to it with your preferred Postgres client (psql, dbeaver, etc).

#### **Run with Docker**

&#x20;If you prefer to use docker, Hydra Columnar publishes docker images with every commit. The Hydra Columnar docker image is a drop-in replacement for the standard Postgres image. Clone the Hydra repo, customize the settings as desired, then start Postgres:

```sh
git clone https://github.com/hydradatabase/hydra && cd hydra
cp .env.example .env
docker compose up
# in another tab
psql postgres://postgres:hydra@127.0.0.1:5432
```

#### **Compile from Source**

Install dependencies:

```bash
POSTGRES_VERSION=16 \
  apt-get install lsb-release gcc make libssl-dev autoconf pkg-config \
  postgresql-${POSTGRES_VERSION} postgresql-server-dev-${POSTGRES_VERSION} \
  libcurl4-gnutls-dev liblz4-dev libzstd-dev
```

Clone the source code, compile and install:

```bash
git clone https://github.com/hydradatabase/hydra.git
cd columnar && ./configure && make install
```

## Need Sample Data?

[Sample Datasets](getting-started/loading-sample-data.md)

## Useful Concepts

[FAQs](concepts/faqs.md)

[Row vs Column tables](organize/data-modeling/row-vs-column-tables.md)

[Batch ingestion vs data streaming](concepts/batch-ingestion-and-data-streaming.md)
