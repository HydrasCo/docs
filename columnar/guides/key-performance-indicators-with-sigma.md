---
description: >-
  Sigma is a cloud-native analytics platform that uses a familiar spreadsheet
  interface to give business users instant access to explore and get insights
  from their cloud data warehouse.
---

# KPIs with Sigma

## **Scope**

The focus of this guide is to showcase the ease of integrating Hydra with [Sigma](https://www.sigmacomputing.com/) by developing several KPI metrics based on data within a Hydra database.

To cater to a large audience, the data and KPIs were chosen to be as agnostic as possible. The data used is mock sales data from IBM, and the metrics are the following:

* YoY Revenue Growth (card)
* YoY Net Profit Growth (card)
* QoQ Revenue Growth (time-series line chart)

Your KPIs will likely differ, but this will hopefully serve as a foundation for the development of more metrics.

## **Setup**

* Ensure you have the details of your Hydra instance handy.
* Sign up for a free trial at [Sigma](https://www.sigmacomputing.com/free-trial).

### Building the Table with Hydra

1. We will use sample sales data from [IBM](https://relational.fit.cvut.cz/dataset/GOSales). [Head to the repository](https://github.com/IBM/watson-machine-learning-samples/tree/master/cpd4.6/data/go\_sales) and download the `go_daily_sales.csv` file from the linked directory (`cpd4.6/data/go_sales`).
2.  Connect to your Hydra database and import the CSV file. We will be following the steps for importing a CSV outlined in the [documentation](https://docs.hydra.so/centralize-data/load/from-local-csv-file).

    a. Grab the `psql` command from the Hydra dashboard and get into the `psql` console.

    b. Due to the differences in date mapping between the `.csv` and the `DATE` data-type when creating the table, we will temporarily set the **datestyle** to `euro`.

    ```sql
    set datestyle = euro;
    show datestyle;
     DateStyle 
    -----------
     ISO, DMY
    ```

    c. The below code is used to create the sales\_data table. Note: we will create a [columnar table](https://docs.hydra.so/organize/data-modeling/row-vs-column-tables), which makes it much quicker to obtain all data for a particular column.

    ```sql
    CREATE TABLE sales_data (
    retailer_code INT,
    product_number INT,
    order_method_code INT,
    date DATE,
    quantity INT,
    unit_price FLOAT,
    unit_sale_price FLOAT
    ) USING columnar;
    ```

    d. Once the table has been created, upload the .csv by utilizing the following command: `\COPY sales_data FROM 'go_daily_sales.csv' DELIMITER ',' CSV HEADER;`
3. You should now have a sales-oriented table populated with approximately 150,000 rows.

### Creating the Connection

Now we can configure Sigma to access our sample data in Hydra.

1. Start by creating a [trial account](https://www.sigmacomputing.com/free-trial), or logging in if you have already done so.
2. Open your Admin Portal by selecting **Administration** in the user menu at the top right of your screen.
3. Select the **Connections** page from the top left-hand panel.
4. Click the **Create Connection** button on the top right.
5.  Choose a name for the connection (we went with **hydra-sales\_data\_2023**) and select PostgreSQL as the type of database you'd like to connect to.

    ![](../.gitbook/assets/.sigma-images/connection\_details.png)
6.  Retrieve your database credentials from your Hydra dashboard. You will need Hostname, User, Password, and Database. Keep all other options unchanged. Once all the information has been entered, select **Create** on the top right.

    ![](../.gitbook/assets/.sigma-images/connection-credentials.png)
7.  Once created, you will be able to view the connection details.

    ![](../.gitbook/assets/.sigma-images/connection-summary.png)

### Creating Your First Hydra-backend Dashboard

1. Back on the main page, click **Create New** on the top left followed by selecting **Workbook**. You will see a banner entitled **DATA ELEMENTS** on the toolbar to the left.
2.  Within the aforementioned toolbar, select **VIZ** followed by clicking on **TABLES AND DATASETS**. This will bring you to the Hydra database and will show you the available schemas. Your data should exist within the **public** schema.

    ![](../.gitbook/assets/.sigma-images/select-table.png)
3. Navigate to the aforementioned schema, select **sales\_data**, and then confirm your selection by clicking the button on the bottom right.

## Congratulations! You've connected Hydra with Sigma! What next?

### Building the Metrics

Now that your data is connected, you're able to utilize your Hydra tables and create insights using Sigma's visualization. Let's experiment with creating the below dashboard showcasing some important KPIs relating to YoY revenue and profit.

![](../.gitbook/assets/.sigma-images/final-dashboard.png)

1. Within the dashboard, click the **+** symbol on the top left.
2.  Navigate to **Layouts** and click on the layout showcasing two visuals side-by-side (third from the bottom).

    ![](../.gitbook/assets/.sigma-images/add-new.png)
3.  Select the left empty visual, and then select **sales\_data** as the table/data source.

    ![](../.gitbook/assets/.sigma-images/visual-source.png)
4.  Create two new columns, one for _Revenue_ and one for _Profit Margin_, by clicking the **Add Column** button on the toolbar to the left.

    ![](../.gitbook/assets/.sigma-images/add-column.png)

    * **Revenue**: Change the column name to Revenue and enter the following formula onto the formula bar at the top: `[Unit Price] * [Quantity]`.
    * **Profit Margin**: Change the column name to Profit Margin and enter the following formula onto the formula bar at the top: `([Unit Price] - [Unit Sale Price]) * [Quantity]`.
5.  Now that we have the two columns used for these KPI's, let's add them to the metrics. Click on the left empty visual and, from the top left toolbar, change its type from **Bar** to **Single Value**.

    ![](../.gitbook/assets/.sigma-images/new-bar-chart.png)
6.  Drag **Revenue** into both the **Value** and **Comparison** section in the toolbar.

    ![](../.gitbook/assets/.sigma-images/drag-columns.png)
7.  Select the newly added column under **Value** (should be automatically renamed to **Sum of Revenue** and change the formula, located in the top-middle, to `SumIf([Revenue], Year([Date]) = 2017)`. Change the formula of the newly added column under **Comparison**, now entitled **Sum of SumIf of Revenue**, to `SumIf([Revenue], Year([Date]) = 2016)`.

    ![](../.gitbook/assets/.sigma-images/function.png)

    ![](../.gitbook/assets/.sigma-images/add-metric-function.png)
8.  Rename **Sum of Revenue**, under **Value**, to **Annual Sales** and Format the type to _currency_ by hovering over the column and clicking on the arrow to the right. You should now have something looking like this:

    ![](../.gitbook/assets/.sigma-images/annual-sales.png)
9.  **Repeat steps 5-8 for YoY Profit**, but use the **Profit Margin** column instead of **Revenue**. When adding a new visual, choose **Annual Sales** as your data source when prompted, as it will include the new columns created in the visual prior.

    ![](../.gitbook/assets/.sigma-images/add-second-metric.png)

The Quarterly revenue graph is also made in similar fashion, with the addition of adding a date range and aggregation filter.

1. Add a new visual.
2. Change the visual type from **Bar** to **Line**.
3. Drag Revenue into the y-axis, and Date into the x-axis.
4.  On the x-axis toolbar, click on the arrow and navigate to **Truncate date**. Select **Quarter**.

    ![](../.gitbook/assets/.sigma-images/truncate-quarterly.png)
5.  Hovering over the data element again, click the arrow and then **Filter**. Change the filter type from **Between** to **Before**, and select December 31, 2017 as the date.

    ![](../.gitbook/assets/.sigma-images/filter-metric.png)

## **You're done!**

Congratulations on creating your first Hydra x Sigma KPI dashboard!

![](../.gitbook/assets/.sigma-images/final-dashboard.png)
