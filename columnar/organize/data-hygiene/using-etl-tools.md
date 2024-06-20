# Using ETL Tools

When using ETL tools, you must take care to normalize your data.

## Normalization with Airbyte

At its core, Airbyte is geared to handle the EL (Extract Load) steps of an ELT process. These steps can also be referred in Airbyte's dialect as "Source" and "Destination".

However, this is actually producing a table in the destination with a JSON blob column... For the typical analytics use case, you probably want this json blob normalized so that each field is its own column.

So, after EL, comes the T (transformation) and the first T step that Airbyte actually applies on top of the extracted data is called "Normalization". You can find more information about it [here](https://docs.airbyte.com/understanding-airbyte/basic-normalization).

Airbyte runs this step before handing the final data over to other tools that will manage further transformation down the line.

To summarize, we can represent the ELT process in the diagram below. These are steps that happens between your "Source Database or API" and the final "Replicated Tables" with examples of implementation underneath:

![https://docs.airbyte.com/assets/images/connecting-EL-with-T-4-76a8ba79525fe9b69c81e4ca5ef0822e.png](https://docs.airbyte.com/assets/images/connecting-EL-with-T-4-76a8ba79525fe9b69c81e4ca5ef0822e.png)

Anyway, it is possible to short-circuit this process (no vendor lock-in) and handle it yourself by turning this option off in the destination settings page.

This could be useful if:

1. You have a use-case not related to analytics that could be handled with data in its raw JSON format.
2. You can implement your own transformer. For example, you could write them in a different language, create them in an analytics engine like Spark, or use a transformation tool such as dbt or Dataform.
3. You want to customize and change how the data is normalized with your own queries.

In order to do so, we will now describe how you can leverage the basic normalization outputs that Airbyte generates to build your own transformations if you don't want to start from scratch.

EXAMPLE HERE: [https://docs.airbyte.com/operator-guides/transformation-and-normalization/transformations-with-sql](https://docs.airbyte.com/operator-guides/transformation-and-normalization/transformations-with-sql)
