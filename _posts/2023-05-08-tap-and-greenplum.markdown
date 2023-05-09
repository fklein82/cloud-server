---
layout: post
title:  Discover the power of MLOps with Tanzu Application Platform (TAP) and Greenplum.
description: Learn how to train a Convolutional Neural Network, utilize DataHub for data set management, set up a JupyterHub notebooks environment, and build ML workflows with Kubeflow and Argo Workflows.
date:   2023-05-08 19:01:35 +0300
image:  '/images/mlops2.png'
tags:   [data-ia]
---

### Introduction to Machine Learning, Artificial Intelligence and Data Platforms.

In the world of data, companies use **Machine Learning (ML**) and **Artificial Intelligence (AI)** to stay competitive. As the demand for quick innovation and deployment of ML models increases, having a strong all-in-one data platform becomes crucial.

In this blog post, we will explore how combining the **Tanzu Application Platform (TAP)** with **Greenplum** can deliver a **full data platform with MLOps capabilities** by using Opensource projects. 

- [Tanzu Application Platform (TAP)](https://tanzu.vmware.com/application-platform) is a "Platform as a Service" that simplifies the development, deployment, and management of modern applications on Kubernetes.

- Tanzu Application Platform can easily integrate with just about any modern database using [Service Bindings](https://servicebinding.io/). This includes databases with support for in-database analytics. In this blog post, we will use VMware Greenplum.

- [VMware Greenplum](https://www.vmware.com/fr/products/greenplum.html) is an advanced, fully featured, open-source MPP data warehouse based on PostgreSQL. It provides powerful and rapid analytics on petabyte-scale data volumes. Uniquely geared toward big data analytics.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/data-ia-stack.png">
  </div>
</div>

### What is MLOps? Unlocking the Secrets to Efficient Machine Learning Development and Deployment
MLOps, aka Machine Learning Operations, is a set of practices that aim to streamline the development, deployment, and management of machine learning models. It involves integrating machine learning with DevOps principles to ensure smooth collaboration between data scientists, ML engineers, and IT operations teams. MLOps focuses on automating and monitoring various stages of the ML lifecycle, from data preprocessing to model deployment and maintenance, resulting in faster experimentation, improved model quality, and more reliable production systems.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/mlops1.png">
  </div>
</div>

### Why Greenplum for the Back-end?

Exporting data from a database and importing it into a server or desktop environment using popular data science tools (e.g., Python, R) can be inefficient for big data analytics. Data scientists often face challenges with these tools' memory and scalability limitations as well as bottlenecks associated with transferring large amounts of data between different platforms.
Choosing the right tool is critical for data scientists to overcome these issues. In this post, we focus on Greenplum, a massively parallel processing PostgreSQL engine which provides built-in tools for data scientists for high-scale data exploration and model training. These tools and extensions include:
1. [Procedural language extensions](https://docs.vmware.com/en/VMware-Tanzu-Greenplum/6/greenplum-database/GUID-analytics-intro.html) to enable massive parallelism for Python & R
2. [Apache MADlib](https://docs.vmware.com/en/VMware-Tanzu-Greenplum/6/greenplum-database/GUID-analytics-madlib.html) for scalable machine learning
3. [PostGIS](https://docs.vmware.com/en/VMware-Tanzu-Greenplum/6/greenplum-database/GUID-analytics-postGIS.html?hWord=N4IghgNiBcIA4HsDOAXA5gSySAvkA) for geospatial analytics and [GPText](https://docs.vmware.com/en/VMware-Tanzu-Greenplum-Text/3.10/tanzu-greenplum-text/GUID-topics-intro.html) for text search and processing
4. Interoperability with dashboarding tools such as Tableau and PowerBI for seamless data visualization and reporting

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/greenplum3.png">
  </div>
    <em><a href="https://github.com/greenplum-db/GreenplumPython" target="_blank">GreenplumPython for End-To-End MLOps tasks with MLflow</a></em>
</div>

### Our Journey
Our journey will take us through the process of training a Convolutional Neural Network (CNN) on TAP, discovering data sets with DataHub, setting up a development environment, building ML workflows with Kubeflow and Argo Workflows, and creating predictive apps with APIs.

### But what is a Convolutional Neural Network?

A Convolutional Neural Network (CNN) is a type of computer program designed to process and analyze grid-like data, such as images. It's especially good at tasks like recognizing and classifying objects in pictures. CNNs work by learning to identify patterns and features from the input data through multiple layers, ultimately producing an output like a category or label.

### 1. Training a Convolutional Neural Network on TAP
The Tanzu Application Platform is a powerful platform that simplifies the development, deployment, and management of modern applications. By combining TAP with Greenplum, an open-source, massively parallel data warehouse, we can efficiently train a Convolutional Neural Network on large-scale data sets. TAP provides the necessary infrastructure and tooling to enable seamless scaling and management of resources, ensuring optimal performance and efficiency throughout the training process.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/mlops-on-tap.jpg">
    <img src="/images/accelerator.png">
  </div>
  <em><a href="https://tanzu.vmware.com/application-platform" target="_blank">Tanzu Application Platform</a> & <a href="https://www.vmware.com/products/greenplum.html" target="_blank">Greenplum</a></em>
</div>

### 2. Discover Data Sets with DataHub
Data is the building block of any ML project, and having a comprehensive data catalog is essential for discovering and managing data sets. DataHub, a popular data catalog tool, allows users to easily discover, understand, and use data sets across the organization. By integrating DataHub with TAP and Greenplum, we can quickly locate the most relevant data sets for our ML projects and ensure that our data is accurate, consistent, and up-to-date.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/datahub1.png">
    <img src="/images/datahub2.png">
    <img src="/images/datahub4.png">
  </div>
    <em><a href="https://datahubproject.io/" target="_blank">Datahub - The #1 Open Source Data Catalog</a></em>
</div>

&rarr; [Install Datahub Accelerator for TAP](https://github.com/agapebondservant/datahub-accelerator)
~~~
tanzu acc create datahub --git-repository https://github.com/agapebondservant/datahub-accelerator.git --git-branch main
~~~


### 3. Set Up a Development Environment with JupyterHub notebooks
- Jupyter Notebooks is an open-source web application that allows users to create and share documents containing live code, equations, visualizations, and narrative text. It is widely used for data cleaning, transformation, and exploration, as well as for building and training ML models. By setting up a Jupyter Notebook environment on TAP, we can access our data stored in Greenplum and perform experiments with the latest ML frameworks and libraries, all within a single, unified platform.

- JupyterHub is a popular tool for Data Scientist. It is used for hosting Jupyter notebooks. A Jupyter notebook provides a browser-based IDE that enables live coding, experimentation, data exploration and model engineering. JupyterHub is a containerized, open-source app, making it easy to deploy on TAP.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/jupyter1.png">
    <img src="/images/jupyter2.png">
    <img src="/images/jupyter3.png">
  </div>
    <em><a href="https://jupyter.org/" target="_blank">JupyterLab - A Next-Generation Notebook Interface</a></em>
</div>

&rarr; [Install Jupyter Utilities Accelerator for TAP](https://github.com/agapebondservant/jupyter-accelerator)
~~~
tanzu acc create jupyter --git-repository https://github.com/agapebondservant/jupyter-accelerator.git --git-branch main
~~~

### 4. Build the ML Model Workflow with MLflow
MLflow is an open-source platform that streamlines the end-to-end management of machine learning projects. It provides a unified interface to manage the entire lifecycle of ML models, including experimentation, reproducibility, deployment, and monitoring. By integrating MLflow with TAP and Greenplum, we can easily track and compare experiments, package and share models, and deploy them in a scalable and reproducible manner. This integration ensures a smooth and efficient ML workflow, improving the overall effectiveness of our ML operations.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/mlflow1.png">
    <img src="/images/mlflow2.png">
    <img src="/images/mlflow3.png">
  </div>
    <em><a href="https://mlflow.org/" target="_blank">mlflow - An open source platform for the machine learning lifecycle</a></em>
</div>

&rarr; [Install Kubeflow Accelerator for TAP](https://github.com/agapebondservant/kubeflow-pipelines-accelerator)
~~~
tanzu acc create kubeflowpipelines --git-repository https://github.com/agapebondservant/kubeflow-pipelines-accelerator --git-branch main
~~~

### 5. Train scalable Machine Learning models on Greenplum platform using GreenplumPython

**Greenplum** has strong analytical capabilities that make them well suited for data science problems at a massive scale. Combining its **MPP capabilities** with **Python’s rich ecosystem** makes the end-to-end Machine Learning model development experience significantly faster.

To simplify the path to production and operational usage of trained ML models, we can unleash the power of **GreenplumPython**, it’s a **Python package that enables in-database execution of Python code** within Greenplum functions.

Data Scientists can then perform complex data processing and analysis tasks using familiar Python syntax and libraries, directly inside the Greenplum database. This integration **reduces data movement** and **improves performance**, as data processing occurs close to where the data is stored, making it an efficient way to perform advanced analytics, pre-processing, feature engineering, model training and deployment for your ML projects.

&rarr; [Greenplum Documentation](https://docs.vmware.com/en/VMware-Tanzu-Greenplum/index.html)

&rarr; [GreenplumPython Package](https://github.com/greenplum-db/GreenplumPython)

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/greenplum1.png">
  </div>
    <em><a href="https://github.com/greenplum-db/GreenplumPython" target="_blank">GreenplumPython for End-To-End MLOps tasks with MLflow</a></em>
</div>


### 6. Build and Train ML Model Workflow with TensorFlow.
TensorFlow is a popular open-source ML library developed by Google. It provides a flexible and efficient platform for building and deploying ML models across various platforms and devices. By integrating TensorFlow with TAP and Greenplum, we can develop and train our ML models on massive data sets, harnessing the full power of distributed computing for faster and more accurate results.

&rarr; [Install Tensorflow Accelerator for TAP](https://github.com/tanzumlai/sample-ml-app/tree/main/)
~~~
tanzu acc create sample-cnn-app --git-repository https://github.com/tanzumlai/sample-ml-app.git --git-branch main
~~~

### 7. Build ML Pipeline with Argo Workflows
Argo Workflows is an open-source, container-native workflow engine for orchestrating parallel jobs on Kubernetes. By integrating Argo Workflows with TAP, we can build and manage complex ML pipelines with ease, automating tasks such as data preprocessing, model training, and deployment. This enables faster experimentation and iteration, ultimately accelerating the delivery of high-quality ML models.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/argocd1.png">
    <img src="/images/argocd2.png">
    <img src="/images/argocd3.png">
  </div>
    <em><a href="https://argoproj.github.io/workflows/" target="_blank">ArgoCD Workflows - open source container-native workflow engine for orchestrating parallel jobs on Kubernetes.</a></em>
</div>

&rarr; [Install ArgoCD Workflows Accelerator for TAP](https://github.com/agapebondservant/argo-workflows-accelerator/tree/main/)
~~~
tanzu acc create argo-pipelines-acc --git-repository https://github.com/agapebondservant/argo-workflows-accelerator.git --git-branch main
~~~

&rarr; [More info on ArgoCD Workflows](https://argoproj.github.io/argo-workflows/)

### 8. Create Predictive Apps with APIs
Once our ML models are trained and optimized, we can use TAP to build predictive applications that leverage these models to provide valuable insights and predictions. By exposing our models through APIs, we enable seamless integration with existing applications and systems, ensuring that our data-driven insights can be easily consumed by end-users and decision-makers. This not only increases the value and impact of our ML efforts but also promotes a data-driven culture within the organization.

### References Architecture 

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/data-architecture.png">
  </div>
</div>

&rarr; [Source code for build a DATA E2E Demo Platform](https://github.com/agapebondservant/tap-data)

These insightfulls References Architecture are credited to [Omotola Awofolu](https://www.linkedin.com/in/tola-awofolu-b4a9576/) - Senior Platform Architect and [Caio Farias](https://www.linkedin.com/in/caiofarias/) - Account Data Engineer from VMware.

### Conclusion

In this blog post, We have demonstrated how combining the **Tanzu Application Platform** with **Greenplum** can deliver a **full data platform with MLOps** capabilities.

From training a Convolutional Neural Network on TAP to building predictive apps with APIs, this powerful combination enables organizations to harness the power of their data and accelerate the delivery of high-quality ML models. 

By integrating tools like **DataHub**, **Jupyter Notebook**, **Kubeflow**, **TensorFlow**, **GreenplumPython** and **Argo Workflows**, we can streamline the entire ML lifecycle, improving efficiency and scalability across the board.

With **TAP** and **Greenplum** at the core of your **data platform**, your organization will be well-equipped to **tackle the most challenging ML problems** and drive **innovation in the ever-evolving world of data and AI**.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/data-ia-stack-2.png">
  </div>
</div>

### Authors

This blog post was **co-written** with my friend [**Ahmed Rachid Hazourli**](https://www.linkedin.com/in/ahmed-rachid/), a very bright **Tanzu Data Engineer**. 

**Special Thanks** to [**Omotola Awofolu**](https://www.linkedin.com/in/tola-awofolu-b4a9576/) - **Senior Platform Architect** and [**Caio Farias**](https://www.linkedin.com/in/caiofarias/) - **Account Data Engineer** for their **invaluable contribution** in developing the **TAP accelerator**, the **Reference Architecture** and for being a constant **source of inspiration** to us.

We sincerely hope you **enjoyed reading it**!

#### Linkedin

- [Omotola Awofolu](https://www.linkedin.com/in/tola-awofolu-b4a9576/)
- [Caio Farias](https://www.linkedin.com/in/caiofarias/)
- [Ahmed Rachid Hazourli](https://www.linkedin.com/in/ahmed-rachid/)
- [Frédéric Klein](https://www.linkedin.com/in/fklein82/)
