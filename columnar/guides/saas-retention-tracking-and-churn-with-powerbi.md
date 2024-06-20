---
description: Power BI is a unified, scalable platform for self-service and enterprise business intelligence (BI) created and maintained by Microsoft.
---

# Retention Tracking with Hydra and PowerBI

## Scope
The focus of this guide is to showcase the ease of integrating Hydra with [PowerBI](https://powerbi.microsoft.com/) to develop a customer retention & churn-oriented dashboard on sample data within a Hydra database.

To cater to a broad audience, the data and KPIs were chosen to be as agnostic as possible. The data used is mock sales data created specifically for this demo, and the metrics are the following:

* YoY Time Series Customer Retention Rate by Quarter 
* YoY Time Series Customer Churn Rate by Quarter

Your KPIs will differ, but this will hopefully serve as a foundation for the development of more metrics.

## Setup

### Before You Start
- Ensure you have the details of your Hydra instance handy.
- Download [PowerBI Desktop](https://powerbi.microsoft.com/en-us/desktop/).


### Building the Table with Hydra

1. We will use sample data created specifically for this demo. The data comes in two .sql scripts: one to [create the table](https://github.com/hydradatabase/docs/tree/main/.gitbook/assets/.saas-retention-powerbi/.sql/saas_retention_ddl.sql), and one to [populate the table](https://github.com/hydradatabase/docs/tree/main/.gitbook/assets/.saas-retention-powerbi/.sql/saas_retention_data.sql) with the data. Retreive these two scripts and save them locally.

2. Connect to your Hydra database via PSQL and run the two scripts with the following commands:

	a. Grab the psql command from the Hydra dashboard and get into the psql console.

	b. Run **saas_retention_ddl.sql** by entering: `\i '<path_to_file_directory>/saas_retention_ddl.sql'`.

    c. Run **saas_retention_data.sql** by entering `\i '<path_to_file_directory>/saas_retention_data.sql'`.

3. You should now have a table called user_activity populated with 96 monthly user records.


### Creating the Connection

Now we can configure PowerBI to access our sample data in Hydra.

1. Select Get data from the toolbar at the top. Click on More.

    ![](/.gitbook/assets/.saas-retention-powerbi/get_data_more.png)

2. Enter postgres in the search bar and select PostgreSQL database. Select connect on the bottom.

    ![](/.gitbook/assets/.saas-retention-powerbi/get_data_postgres.png)

3. Enter both your Hydra Hostname and Database in the Server and Database fields, respectively. Click on OK.

    ![](/.gitbook/assets/.saas-retention-powerbi/get_data_hydra_host_db.png)

4. You will be prompted to enter both your Hydra Username and Password. Ensure you have your Hydra instance selected (the Hostname) in the Select which level to apply these settings to field.

	![](/.gitbook/assets/.saas-retention-powerbi/get_data_hydra_username_password.png)

5. Select the table public.user_activity from the list of available tables within the database. Click on Load.

	![](/.gitbook/assets/.saas-retention-powerbi/select_table.png)

6. You should now be able to see the table, and respective columns, on the Data banner to the right.

	![](/.gitbook/assets/.saas-retention-powerbi/data_banner.png)

7. Navigate to Data view on the left tab and, for each of the monthly_retention and monthly_churn columns, select the column and format it to Percentage by clicking on the % at the top.

	![](/.gitbook/assets/.saas-retention-powerbi/format_percentage.png)


## Building Customer-Centric Metrics

We're going to make a few metrics focused on retention and churn.


## YoY Time Series Customer Retention Rate by Quarter
1. In the Report view, where you're able to select your visualizations, choose Line chart. Click on the blank chart, and then drag monthly_retention from the Data panel on the right into the Y-axis field. Click on the drop-down arrow on what is now called Sum of monthly_retention and choose Average. Drag record_date and put it into the X-axis field, then delete Day and Month. 

	![](/.gitbook/assets/.saas-retention-powerbi/yoy_time_series_quarter_retention_1.png)

2. Within the Y-axis field, right click and select Rename for this visual. Enter Average Customer Retention.

3. You should now have a metric titled Average Customer Retention by Year and Quarter.

	![](/.gitbook/assets/.saas-retention-powerbi/yoy_time_series_quarter_retention_2.png)

## YoY Time Series Customer Churn Rate by Quarter
1. Create a new tab and add a line chart. Click on the blank chart, and then drag monthly_churn from the Data panel on the right into the Y-axis field. Click on the drop-down arrow on what is now called Sum of monthly_churn and choose Average. Drag record_date and put it into the X-axis field, then delete Day and Month. 

	![](/.gitbook/assets/.saas-retention-powerbi/yoy_time_series_quarter_churn_1.png)

2. Within the Y-axis field, right click and select Rename for this visual. Enter Average Customer Churn.

3. You should now have a metric titled Average Customer Retention by Year and Quarter.

	![](/.gitbook/assets/.saas-retention-powerbi/yoy_time_series_quarter_churn_2.png)