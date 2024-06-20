# Warehouse + S3 Data Lake

Hydra supports communicating with S3 for your data lake. We recommend using the Apache Parquet format and [S3 Parquet External Tables](../../centralize-data/load/from-s3.md) to read data.

## Data Warehouse

A data warehouse and a data lake are two commonly used data storage and management systems that are often used together to support a variety of data-driven workloads.

A data warehouse is a centralized repository of structured data that is designed for fast querying and analysis. Data warehouses typically store data in a dimensional model, which allows for easy querying and analysis using SQL. Data warehouses are often used for business intelligence (BI) and reporting, as well as for data mining and other analytical workloads.

## Data Lake

A data lake, on the other hand, is a large, scalable repository of raw, unstructured data. Data lakes are typically built on cloud-based storage systems, such as Amazon S3, and they are designed to store large amounts of data in a cost-effective and scalable manner. Data lakes are often used for storing raw data that may be used for future analysis or for data that is not yet ready to be loaded into a data warehouse.

By using a data warehouse and a data lake together, businesses can take advantage of the strengths of both systems to support a variety of data-driven workloads. The data warehouse can be used for fast querying and analysis of structured data, while the data lake can be used for storing and managing large volumes of raw, unstructured data.

For example, a business might use a data lake to store raw customer data from multiple sources, such as web logs, CRM systems, and social media feeds. The data in the data lake can then be cleaned, transformed, and structured using tools, such as Apache Spark or Amazon EMR, and loaded into a data warehouse for fast querying and analysis. This allows the business to gain insights into customer behavior and preferences, and to make data-driven decisions.

Overall, using a data warehouse and a data lake together can provide a powerful and flexible solution for storing, managing, and analyzing data. By combining the strengths of both systems, businesses can support a variety of data-driven workloads and gain insights into their data.
