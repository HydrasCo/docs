# What is Query Parallelization?

Query parallelization is a technique that is used to improve the performance of database queries by executing them in parallel across multiple processor cores or machines. This is in contrast to traditional serial execution, where each operation is performed one at a time.

Query parallelization works by dividing the work of a query into smaller tasks, which are then executed simultaneously on multiple cores or machines. This allows the database to take advantage of modern processors, which are designed to perform multiple operations simultaneously, and can significantly improve the performance of queries that involve large amounts of data.

For example, consider a query that calculates the sum of a column of numbers in a table. In traditional serial execution, the database would go through each row of the table one at a time, adding each number to the running total. With query parallelization, the database would divide the data into smaller chunks and distribute them among multiple cores or machines, which would then calculate the sum of their respective chunks simultaneously. This can significantly reduce the time it takes to perform the query.

By taking advantage of modern processors and executing queries in parallel, query parallelization can significantly improve the speed and efficiency of database operations.
