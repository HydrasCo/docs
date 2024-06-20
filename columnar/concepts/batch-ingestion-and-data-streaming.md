# Batch Ingestion & Data Streaming

Batch ingestion and streaming ingestion are two different approaches to loading data into a database. Batch ingestion involves loading data in large, pre-defined batches, while streaming ingestion involves continuously loading data as it is generated in real-time.

#### Batch ingestion

Batch ingestion is typically used when data is available in large, pre-defined sets, such as when importing data from a file or another database. In this approach, the data is loaded into the database in large batches, often using a pre-defined schedule. This can be an efficient way to load large amounts of data, but it may not be suitable for handling real-time data or data that is generated at unpredictable intervals.

#### Streaming ingestion

Streaming ingestion involves continuously loading data as it is generated in real-time. This can be useful for handling data that is generated at unpredictable intervals, such as data from sensors or social media feeds. Streaming ingestion can also be used to continuously update the database with the latest data, allowing for real-time analysis and reporting.

One common technique for streaming ingestion is change data capture (CDC), which involves continuously monitoring the source data for changes and then updating the database with only the changes, rather than loading the entire dataset. This can be more efficient than other streaming ingestion techniques, as it only loads the data that has changed, rather than the entire dataset.

