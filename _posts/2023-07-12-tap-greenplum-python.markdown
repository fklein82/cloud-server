---
layout: post
title:  Setup your DATA & IA Platform with Tanzu - A Real-World Guide Machine Learning use-case.
description: In this blog post, we walk you through the process of setting up the DATA-IA platform with Tanzu Application Platform and Greenplum Database. We leverage these technologies to build and deploy a Machine Learning model that predicts the age of abalone, providing a practical use-case to help you understand the capabilities of these robust data platforms.
date:   2023-07-12 19:01:35 +0300
image:  '/images/data-ia.png'
tags:   [data-ia]
---

### Building an MLOps Platform with Tanzu Application Platform and Greenplum

As a team of data scientists and engineers at VMware Tanzu, we've been exploring how we can leverage Tanzu Application Platform (TAP) and Greenplum to build a comprehensive MLOps platform. In this blog post, we'll explain how to set up such a platform and provide a practical example of machine learning in action, predicting the age of abalones using linear regression.

### Tanzu Application Platform and Greenplum

For this case study, we are working with a system that uses both the Tanzu Application Platform (TAP) and Greenplum, both of which are deployed on the Azure Cloud platform.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/data-architecture-simple.png">
  </div>
</div>

- Azure Cloud is Microsoft's public cloud computing platform. It provides a range of cloud services, including those for computing, analytics, storage, and networking. Users can pick and choose from these services to develop and scale new applications, or run existing applications, in the public cloud.

- Tanzu Application Platform (TAP) is a part of VMware Tanzu. It is designed to make it easier for developers to build, deploy, and manage applications on Kubernetes. In our case, TAP is deployed on the Azure Kubernetes Service (AKS), which is a managed container orchestration service provided by Azure. AKS simplifies the deployment, scaling, and operations of Kubernetes, thereby allowing TAP to fully utilize its modular capabilities for modern applications.

- Greenplum is a high-performance, massively parallel data warehouse that provides powerful and rapid analytics on petabyte-scale data volumes. In our setup, Greenplum is deployed on top of virtual machines (VMs) on Azure Cloud. These VMs can be easily scaled and managed within the Azure ecosystem, allowing for the efficient handling of large data workloads by Greenplum.

So, our platform foundation is a Kubernetes cluster hosted on Azure's AKS. This cluster is used to run TAP, which supports the development and management of our modern applications. Concurrently, we use Greenplum on Azure VMs to provide robust analytics on large-scale data. This setup provides us with a scalable, efficient, and powerful platform for both application development and data analytics.

Before we get started, it's important to note that we assume you already have a Kubernetes cluster with TAP installed. In this guide, we have deployed a TAP platform on AKS by following the instructions [here](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.5/tap/install-azure-intro.html). 

Next, we installed Greenplum 7 along with its data science Python packages which you can learn more about [here](https://docs.vmware.com/en/VMware-Greenplum/7/greenplum-database/install_guide-platform-requirements-overview.html) and [here](https://docs.vmware.com/en/VMware-Greenplum/7/greenplum-database/install_guide-install_python_dsmod.html).

### Jupyter Lab and Accelerators

JupyterLab is an interactive development environment for working with notebooks, code and data. It provides the ability to execute code in a number of programming languages and to organize that code along with narrative text, equations, images, and visualizations in a single document.

On the other hand, an accelerator for Tanzu Application Platform (TAP) is a bit of software that aids in speeding up the development and deployment process of applications on TAP. Accelerators provide pre-configured templates or a set of scripts that automate the generation of code, configuration, and other operational aspects, enabling developers to focus on coding rather than configuration.

In this case, we'll use a JupyterLab accelerator available [here](https://github.com/fklein82/jupyter-lab-for-tap). 

You can add the accelerator to Tanzu Application Platform List by executing the following code: 

~~~
tanzu acc create jupyter-lab --git-repo https://github.com/fklein82/jupyter-lab-for-tap --git-branch main --interval 5s
~~~

Then you can deploy Jupyter-LAB by generate the acceleraror on your local machine and execting the following commands:

~~~
tanzu apps workload create -f $DIR/config/workload.yaml
~~~

And this will deploy Jupyter-LAB on TAP: 

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/supplychain-jupyter.png">
  </div>
</div>

You can see the Pod running on AKS and the url with the TAP UI: 

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/backstage-jupyter.png">
  </div>
</div>

This is the UI of Jupyter-LAB deployed on our Tanzu Application Platform:

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/jupyter.png">
  </div>
</div>



### MLflow

MLflow is an open-source platform to manage the ML lifecycle, including experimentation, reproducibility, and deployment. It integrates with any Python, R, or Java-based Machine Learning algorithm and simplifies the process of tracking experiments, packaging code into reproducible runs, and sharing and deploying models.

For MLflow, we used the Accelerator from our colleagues Omotola Oawofolu, and it can be found [here](https://github.com/agapebondservant/mlflow-accelerator).

You can add the accelerator to Tanzu Application Platform List by executing the following code: 

~~~
tanzu acc create jupyter-lab --git-repo --git-repository https://github.com/agapebondservant/mlflow-accelerator --git-branch main --interval 5s
~~~

This is the UI of MLflow deployed on our Tanzu Application Platform:

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/mlflow.png">
  </div>
</div>


### Python Script for Abalone Age Prediction

With our MLOps platform ready, we're set to tackle a real-world machine learning use case: predicting the age of abalones using linear regression. Let's dive into the Python script.

The script uses Greenplum's ability to directly access external data to read the abalone dataset from an online source. The script is also utilizing sql_magic, an IPython extension, to write SQL queries to run against Greenplum database, as well as the GreenplumPython library for manipulating Greenplum data with Python.

#### 1. Environment setup: 
The script starts by installing the required packages and importing them. These include Python libraries such as pandas, numpy, plotly, and sqlalchemy for data manipulation, analysis, and visualization; greenplumpython for connecting to and interacting with the Greenplum database; and SQL magic commands that allow running SQL queries in Jupyter notebooks. It also sets up the database connection to Greenplum.

~~~
## Setup environment: install & import packages

!pip install greenplum-python pandas numpy plotly ipython-sql sqlalchemy plotly-express sql_magic pgspecial

import pandas as pd
import numpy as np
import os
import sys
import plotly_express as px
# For DB Connection
from sqlalchemy import create_engine
import psycopg2
import pandas.io.sql as psql
import sql_magic
import greenplumpython as gp
import plotly.io as pio
pio.renderers.default = 'iframe'
~~~

#### 2. Data Collection: 
The script creates an external web table that pulls in the abalone data directly from an online resource using Greenplum's CREATE EXTERNAL WEB TABLE statement. The external web table data is then transferred to a regular Greenplum table.

~~~
### Database Connection

%load_ext sql
%sql postgresql://gpadmin:password@xxx.xxx.xxx.xxx/warehouse

%%sql 
SELECT version ();

# Data Collection: Access external web data directly from Greenplum

%%sql
-- External Table
DROP EXTERNAL TABLE IF EXISTS abalone_external;
CREATE EXTERNAL WEB TABLE abalone_external(
    sex text
    , length float8
    , diameter float8
    , height float8
    , whole_weight float8
    , shucked_weight float8
    , viscera_weight float8
    , shell_weight float8
    , rings integer -- target variable to predict
) EXECUTE 'curl http://archive.ics.uci.edu/ml/machine-learning-databases/abalone/abalone.data'
format 'CSV'
(null as '?');

%%sql
-- Create abalone table from an external table
DROP TABLE IF EXISTS abalone;
CREATE TABLE abalone AS (
    SELECT ROW_NUMBER() OVER() AS id, *
    FROM abalone_external
) DISTRIBUTED BY (sex);
~~~

#### 3. Exploratory Data Analysis (EDA): 
Basic SQL queries and the GreenplumPython library are used to inspect the data and get a sense of what it contains. This part also uses Plotly to visualize the distribution of the "sex" category.

~~~
# Exploratory Data Analysis
### Inspect the table using basic SQL

%%sql 
SELECT * FROM abalone LIMIT 10;
~~~

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/result-abalone.png">
  </div>
</div>

~~~
### Inspect the table using GreenplumPython library
# GreenplumPython connection to DB
db = gp.database("postgresql://gpadmin:password@xxx.xxx.xxx.xxx/warehouse")

abalone = db.create_dataframe(table_name="abalone")

# SELECT * FROM abalone ORDER BY id LIMIT 10;

abalone.order_by("id")[:10]
~~~

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/result2-abalone.png">
  </div>
</div>

~~~
#### Row-count of the "abalone" table

# SELECT gp_segment_id, COUNT(*)
# FROM abalone

import greenplumpython.builtins.functions as F

abalone.apply(lambda _: F.count())
~~~
count
66832
~~~
### Distribution of "sex" in abalone dataset
group_by_sex = abalone.group_by("sex").apply(lambda _: F.count())
df_group_by_sex = pd.DataFrame.from_records(iter(group_by_sex))
df_group_by_sex
~~~

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/result3-abalone.png">
  </div>
</div>

~~~
px.pie(df_group_by_sex, names = 'sex', values = 'count', title='Distribution of sex categories')
~~~
<div class="gallery-box">
  <div class="gallery">
    <img src="/images/pie-chart-python.png">
  </div>
</div>

#### 4. Feature Engineering: 
The dataset is split into a training set and a test set using SQL queries.
~~~
%%sql
CREATE TEMP TABLE temp_abalone_label AS
    (SELECT *, random() AS __samp_out_label FROM abalone);

CREATE TEMP TABLE train_percentile_disc AS
    (SELECT sex, percentile_disc(0.8) within GROUP (ORDER BY __samp_out_label) AS __samp_out_label
    FROM temp_abalone_label GROUP BY sex);
CREATE TEMP TABLE test_percentile_disc AS
    (SELECT sex, percentile_disc(0.2) within GROUP (ORDER BY __samp_out_label) AS __samp_out_label
    FROM temp_abalone_label GROUP BY sex);

DROP TABLE IF EXISTS abalone_train;
CREATE TABLE abalone_train AS
    (SELECT temp_abalone_label.*
        FROM temp_abalone_label
        INNER JOIN train_percentile_disc
        ON temp_abalone_label.__samp_out_label <= train_percentile_disc.__samp_out_label
        AND temp_abalone_label.sex = train_percentile_disc.sex
    );
DROP TABLE IF EXISTS abalone_test;
CREATE TABLE abalone_test AS
    (SELECT temp_abalone_label.*
        FROM temp_abalone_label
        INNER JOIN test_percentile_disc
        ON temp_abalone_label.__samp_out_label <= test_percentile_disc.__samp_out_label
        AND temp_abalone_label.sex = test_percentile_disc.sex
    )
~~~
Command result:
~~~
66832 rows affected.
3 rows affected.
3 rows affected.
Done.
53467 rows affected.
Done.
13368 rows affected.
~~~
#### 5. In-database Machine Learning: 
The main function is defined. It uses the GreenplumPython library to load the train and test datasets from the database. The function linreg_func is created, which takes in three lists (length, shucked weight, and rings) and returns a data class LinregType. Inside this function, the linear regression model is trained on the length and shucked weight, and the model is serialized. The model is logged to MLFlow, and the model's coefficients, intercept, and metadata are returned.

~~~
import greenplumpython as gp
from typing import List
import dataclasses

def main():
    db = gp.database("postgresql://gpadmin:password@xxx.xxx.xxx.xxx/warehouse")

    abalone = db.create_dataframe(table_name="abalone")
    import greenplumpython.builtins.functions as F

    abalone_train = db.create_dataframe(table_name="abalone_train")
    abalone_test = db.create_dataframe(table_name="abalone_test")

    print(abalone_test[:1])
    print(abalone_train[:1])


    # -- Create function
    # -- Need to specify the return type -> API will create the corresponding type in Greenplum to return a row
    # -- Will add argument to change language extensions, currently plpython3u by default

    @dataclasses.dataclass
    class LinregType:
        model_name: str
        col_nm: List[str]
        coef: List[float]
        intercept: float
        serialized_linreg_model: bytes
        created_dt: str
        run_id: str
        registered_model_name: str
        registered_model_version: str

    @gp.create_column_function
    def linreg_func(length: List[float], shucked_weight: List[float], rings: List[int]) -> LinregType:
        from typing import List
        import dataclasses
        from sklearn.linear_model import LinearRegression
        import numpy as np
        import pickle
        import mlflow
        import datetime
        import os
        os.environ["AZURE_STORAGE_ACCESS_KEY"] = "XXX"
        os.environ["AZURE_STORAGE_CONNECTION_STRING"] = "DefaultEndpointsProtocol=https;AccountName=XXX;AccountKey=XXX;EndpointSuffix=core.windows.net"

        @dataclasses.dataclass
        class LinregType:
            model_name: str
            col_nm: List[str]
            coef: List[float]
            intercept: float
            serialized_linreg_model: bytes
            created_dt: str
            run_id: str
            registered_model_name: str
            registered_model_version: str

        mlflow.set_tracking_uri("http://20.93.3.160:5000")
        mlflow.set_experiment('test')
        experiment = mlflow.get_experiment_by_name('test')
        experiment_id = experiment.experiment_id
        mlflow.autolog()
        with mlflow.start_run(experiment_id=experiment_id,nested=True) as run:
            model_name="model_greenplum"
            mlflow.log_param("start_run_test", "This is a test")
            X = np.array([length, shucked_weight]).T
            y = np.array([rings]).T

            # OLS linear regression with length, shucked_weight
            linreg_fit = LinearRegression().fit(X, y)
            linreg_coef = linreg_fit.coef_
            linreg_intercept = linreg_fit.intercept_
            mlflow.log_param("start_run_test2", "This is a test 2")
            # Serialization of the fitted model
            serialized_linreg_model = pickle.dumps(linreg_fit, protocol=3)
            mlflow.sklearn.log_model(linreg_fit, model_name)

            # Register the model to MLFlow
            model_uri = "runs:/{}/model".format(run.info.run_id)
            mv = mlflow.register_model(model_uri, model_name)
            mlflow.sklearn.log_model(
                    sk_model=linreg_fit,
                    artifact_path="model",
                    registered_model_name=model_name,
                )

            return LinregType(
                model_name=model_name,
                col_nm=["length", "shucked_weight"],
                coef=linreg_coef[0],
                intercept=linreg_intercept[0],
                serialized_linreg_model=serialized_linreg_model,
                created_dt=str(datetime.datetime.now()),
                run_id=str(run.info.run_id),
                registered_model_name=str(mv.name),
                registered_model_version=str(mv.version)
            )

    linreg_fitted = (
        abalone_train.group_by()
        .apply(lambda t: linreg_func(t["length"], t["shucked_weight"], t["rings"]), expand=True)
    )

    print(linreg_fitted[["model_name", "col_nm", "coef", "intercept", "created_dt", "run_id", "registered_model_name",
                   "registered_model_version"]])

    linreg_test_fit = linreg_fitted.cross_join(
        abalone_test,
        self_columns=["col_nm", "coef", "intercept", "serialized_linreg_model", "created_dt", "registered_model_name",
                      "registered_model_version"]
    )
    print(linreg_test_fit[:1])
~~~

#### 6. Model Training:
The linear regression function is applied to the training data using the group_by().apply() method from the GreenplumPython library.

#### 7. Model Testing:
The test data is combined with the trained model using the cross_join() method, and predictions can be made based on the trained model.

In this script, Greenplum's power is used to perform in-database machine learning. This allows processing large amounts of data without moving it out of the database, leading to improved performance.

#### 8. Integration with MLflow:
The script also showcases the integration with MLflow for model tracking and versioning. Once you've run some experiments with MLflow, you can go to its web interface to see an overview of all your experiments, each one with a unique name, start time, user, and other useful metadata. 

By clicking on a specific run, you can see more detailed information including the input parameters, output metrics, tags, and any notes you may have added. You can also visualize the model's performance over time and across different parameters. Additionally, MLflow allows you to store the model for each run. You can compare different runs, revert to older models, or deploy the model directly from MLflow.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/mlflow-result-abalone.png">
  </div>
</div>

This script is used to predict the age of abalones (represented by the "rings" column in the dataset) using a linear regression model trained on two features: the length and shucked weight of the abalones. It's an example of supervised learning as it uses labelled data (i.e., we know the actual age of the abalones in the training set).

The data for this example comes from the UCI Machine Learning Repository. It's a well-known dataset in the machine learning community, often used to illustrate various data analysis and machine learning techniques. In this case, the dataset provides a practical use case for the Tanzu Application Platform and Greenplum capabilities in setting up an MLOps environment.

### Conclusion:
Machine learning and data analysis are becoming increasingly vital in the modern data-driven world. Tools like the Tanzu Application Platform and Greenplum enable you to leverage the power of in-database machine learning to handle large volumes of data effectively and efficiently. By applying these tools to real-world datasets, like the Abalone dataset from the UCI Machine Learning Repository, we're able to see just how powerful and practical these technologies can be.

The script showcased in this blog post takes advantage of the in-database processing capabilities of Greenplum, demonstrating that you can build and test machine learning models without moving your data out of the database. This not only enhances performance but also adds a layer of security, as the data remains within its original environment.

The integration with MLflow provides invaluable assistance in managing our machine learning lifecycle. It helps keep track of various model versions, logs all relevant metrics, parameters, and even notes, ensuring an organized and transparent machine learning process. With its visual interface, it becomes easier to compare different model runs, deploy the model, or revert to older models, thus enabling robust and reproducible machine learning.

In the grand scheme of MLOps, the combination of Greenplum for in-database machine learning and MLflow for model tracking and versioning provides a powerful and efficient solution. This empowers data scientists and engineers to perform more complex analyses, develop more sophisticated models, and ultimately extract more valuable insights from their data. As the field of machine learning continues to evolve, these tools will undoubtedly play an integral role in shaping its future.

Thank you for joining us in this exploration of Greenplum and MLflow. I hope this post has helped illustrate their potential and inspires you to consider how they could enhance your own data science projects. Stay tuned for more insights and tutorials in machine learning and data science. Happy coding!

### Authors

This blog post was **co-written** with my friends [**Ruxue Zeng**](https://www.linkedin.com/in/ruxue-zeng/) and [**Ahmed Rachid Hazourli**](https://www.linkedin.com/in/ahmed-rachid/). 

We sincerely hope you **enjoyed reading it**!