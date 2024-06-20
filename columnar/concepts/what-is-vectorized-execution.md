# What is Vectorized Execution?

Vectorized execution is a technique that is used to improve the performance of database queries by executing multiple operations simultaneously. This is in contrast to traditional execution, where each operation is performed one at a time.

Vectorized execution works by dividing data into small chunks, called vectors, and then executing multiple operations on each vector in parallel. This allows the database to take advantage of modern processors, which are designed to perform multiple operations simultaneously, and can significantly improve the performance of queries that involve large amounts of data.

For example, consider a query that calculates the sum of a column of numbers in a table. In traditional execution, the database would go through each row of the table one at a time, adding each number to the running total. With vectorized execution, the database would divide the data into vectors, and then use multiple processor cores to add the numbers in each vector simultaneously. This can significantly reduce the time it takes to perform the query.

By taking advantage of modern processors and executing multiple operations simultaneously, vectorized execution can significantly improve the speed and efficiency of database queries.
