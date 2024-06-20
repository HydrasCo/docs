---
description: >-
  Deepnote is a versatile notebook that revolutionizes analytics and data
  science workflow by seamlessly combining the power of SQL and Python with a
  wide range of data frameworks.
---

# Introduction

The focus of this guide is to display the ease of integrating Hydra into [Deepnote](https://deepnote.com/docs) to perform predictive analytics using Python scripts which can be used to anticipate customer behavior, improve operational efficiency and enhance your business decisions.

To cater to a broad audience, the data and KPIs were chosen to be as agnostic as possible. We will leverage a simple salary dataset on [Kaggle](https://www.kaggle.com/datasets/rsadiq/salary) with two columns:

  * Years of experience
  * Salary

Your datasets will likely differ in scope and complexity, but this will hopefully serve as a general tutorial on how to leverage your data with Hydra & Deepnote for predictive analytics.


## Setup

* Ensure you have your Hydra login details handy or follow the [setup guide](https://docs.hydra.so/getting-started/setup-guide) to create your initial Hydra data warehouse.

* [Sign up for a free instance at Deepnote](https://deepnote.com/sign-up).

### Building the table with Hydra

1. Sample data from Kaggle will be used for this guide. [Download the CSV file](https://www.kaggle.com/datasets/rsadiq/salary) from their website.
2. Connect to your Hydra database and import the CSV file to the database. To do so, [follow the documentation for importing a CSV file](https://docs.hydra.so/centralize-data/load/from-local-csv-file).

### Creating the Connection

Now we can connect Deepnote to our sample data in Hydra.

1. Start by [signing up for Deepnote](https://deepnote.com/sign-up) if you haven't done so already.
2. Within your Deepnote account, create a workspace name. In the case of this tutorial, the workspace name will be "Hydra-Team".
3. Next, choose "PostgreSQL" as the data source as shown in the image below.

<figure><img src="../.gitbook/assets/.predictive-analytics/datasource.png" alt=""><figcaption><p>Choosing Datasource</p></figcaption></figure>

4. Create a new project by clicking on "+" under "Projects" within the left panel of the Deepnote console.

<figure><img src="../.gitbook/assets/.predictive-analytics/create project.png" alt=""><figcaption><p>Creating project</p></figcaption></figure>

5. Within your new project, navigate to "Integrations" on the right panel and choose "PostgreSQL".

<figure><img src="../.gitbook/assets/.predictive-analytics/Integrating postgres.png" alt=""><figcaption></figcaption></figure>

6. In the "Connect to PostgresSQL"' pop-up, add your Hydra database credentials including hostname, user, password, and database. You can obtain these credentials from the [Hydra dashboard](https://dashboard.hydra.so/).

<figure><img src="../.gitbook/assets/.predictive-analytics/connecting postgres.png" alt=""><figcaption><p>Connecting PostgreSQL</p></figcaption></figure>

7. After establishing the connection, you can view the imported salary table within Deepnote.

Using a SELECT statement, you can run SQL queries on the salary table which enables you to retrieve and analyze specific data from the table. Let's run a simple query to make sure everything is working like we expect:

```sql
SELECT * FROM public.salary LIMIT 100
```

<figure><img src="../.gitbook/assets/.predictive-analytics/deepnote dashboard.png" alt=""><figcaption><p>Deepnote dashboard showing the salary table</p></figcaption></figure>

8. To access the table using Python scripts because predictions can not be done using SQL, an engine has to be created with the data warehouse credentials:

```python
import pandas as pd
from sqlalchemy import create_engine
engine = create_engine('postgresql://user:pass@server:5432/database')
data = pd.read_sql_table('Salary',con= engine, schema= 'public')
```

Congratulations! You've successfully connected Hydra with Deepnote! What's next?

## Making the predictions

Now that we have connected Deepnote to Hydra, we can use Python and SQL scripts to access the data. We will use the Linear Regression model to create predictions leveraging the salary data.

The linear regression model and matplotlib for our visualization are imported as shown below:

```python
#import Classes and lib needed
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
```

The dataset is divided into dependent (_y_) and independent (_x_) variables in order for the linear regression model to understand the relationship between the variables and make predictions. We train the linear regression model using the dataset. During the training process, the model learns from the data by identifying the patterns and relationships between the independent variables (years of experience) and the dependent variable (the salary).

```python
#defining variables X and Y
X = data.iloc[:,0].values.reshape(-1,1)
print(X)
Y = data.iloc[:,1].values.reshape(-1,1)
print(Y)
#creating a Linear Regression model for prediction
model = LinearRegression()

#Fitting the model on the Dataset
model.fit(X,Y)

Y_pred = model.predict(X)  # make predictions
```

Now you can create visualizations to show the difference between the actual salary versus the predicted salary:

```python
Y_pred = Y_pred.reshape(-1)
difference = pd.DataFrame({'Real' : data. salary, 'Predicted': Y_pred, })
print(difference)
graph = difference.head(10)
graph.plot(kind='bar')
plt.title('Actual vs Predicted')
plt.ylabel('salary')
```

<figure><img src="../.gitbook/assets/.predictive-analytics/Output.png" alt="" width="464"><figcaption><p>Visualization</p></figcaption></figure>

Your first prediction is complete! You can predict the range of a person's salary based on years of experience.

## Conclusion
At this point, we have performed a basic predictive analytics project by integrating the Hydra database with Deepnote. This basic guide can be leveraged to experiment with your own business metrics, but don't hesitate to reach out for more advance support through the [Hydra #experts channel in Discord](https://hydra.so/discord).
