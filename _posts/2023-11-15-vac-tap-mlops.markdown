---
layout: post
title:  'Accelerate AI: VAC & TAP in Action'
description: Discover the power of MLOps with Tanzu's VMware Application Catalog (VAC) and Tanzu Application Platform (TAP). Build a demo that can transform complex data into cutting-edge AI applications, illustrating the seamless journey from data engineering to model deployment and beyond.
date:   2023-11-15 14:00:35 +0300
image:  '/images/mclaren.png'
tags:   [MLOPS]
---

### Data & AI Landscape
As you know, we're generating a massive amount of data every year - over 64.2 zettabytes. This data is everywhere, from billions of devices, mobile phones to the Internet of Things, spread over various cloud environments.

With over 500 million data users globally, it’s essential to meet diverse needs and skills. More than just storing data, we can to use it through AI and machine learning. But, implementing AI successfully comes with its challenges.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/data-ai-world.jpg">
  </div>
</div>


### Challenges in AI and Machine Learning
Even though AI is growing, only 1% of AI and machine learning projects are completely successful. This shows big problems in how they're planned, supported, and carried out. 72% of companies are still trying to figure out the best way to use AI in their work.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/aifail2.png">
  </div>
</div>

### DevSecOps vs MLOps
MLOps is a crucial strategy for making more AI projects successful. 

- DevSecOps is an approach to software development that integrates security practices into the DevOps process. It emphasizes the importance of security in every stage of development, from initial design to deployment, ensuring that security considerations are an integral part of the workflow rather than an afterthought.

- MLOps is like DevSecOps but tailored for AI and ML projects. MLOps, or Machine Learning Operations, is a set of practices that combines Machine Learning, DevOps, and Data Engineering to streamline and automate the lifecycle of machine learning models. This approach focuses on improving collaboration between data scientists and operations professionals, ensuring consistent, efficient, and scalable deployment and management of ML models in production environments.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/ai-mlops1.png">
  </div>
</div>

In MLOps, the team plays a pivotal role by bringing together diverse expertise from data scientists, machine learning engineers, DevOps, and Application Developers:

- Data Engineers lay down the robust data infrastructure.
- Data Scientists craft predictive models.
- Business Analysts ensure models meet market needs.
- Application Developers integrate models into applications.
- DevOps oversee the smooth operation of these applications.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/ai-mlops2.png">
  </div>
</div>

Together, they turn data into actionable insights and drive business value.

### Our MLOps Demo: From Concept to Application
In our demo, we'll illustrate the MLOPS approach in action. There will be 3 roles: a Platform Engineer, a Data Scientist, and an App Developer. 
- The Platform Engineer will first deploy JupyterLab and MLflow.
- The Datascientist will create a smart image-detection model. 
- And then, The App Developper will use the Datascientist model and  incorporate it into an App.

We will demonstrate just how efficiently and effectively we can deploy JupyterHub and MLFlow with VMware Tanzu Application Catalog, and build an APP that use an AI models with Tanzu Application Platform.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/ai-mlops3.png">
  </div>
</div>

### VMware Application Catalog (VAC)
VAC is an enterprise solution that simplifies the utilization of open-source software in production environments. It offers a comprehensive catalog of tested open-source applications, with features like automated maintenance and vulnerability insights.

### Tanzu Application Platform (TAP)
TAP, a Platform as a Service (PaaS) solution, eases the deployment and management of cloud-native applications on Kubernetes. It enhances developer productivity and offers features like container orchestration, automation, and multi-cloud support.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/tap-detect.png">
  </div>
</div>

## JupyterHub

JupyterHub is a web-based platform that enables multiple users to collaboratively create and work with Jupyter notebooks on a shared server. It offers a secure and customizable environment, supports multiple users, and is commonly used in education, research, and data analysis for its collaborative and interactive capabilities.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/jupyterlabju.png">
  </div>
</div>

## MLFlow

MLflow is a tool that helps people who work with machine learning (ML) to do their work more easily. It helps with tracking and organizing ML experiments, packaging code, and deploying ML models. It's useful for managing the entire ML process, from trying out ideas to putting models into real-world applications.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/mflowju.png">
  </div>
</div>

### First to install JupyterHub, use the following Helm command:

```bash
helm install jupyterhub oci://harbor.jkolaric.eu/vac-library/charts/ubuntu-22/jupyterhub
```
### After installation, you can access JupyterHub using the following URL:

```bash
export SERVICE_IP=$(kubectl get svc --namespace jupyter jupyterhub-proxy-public --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
echo "JupyterHub URL: http://$SERVICE_IP/"
```

### Admin user information:

```bash
echo Admin user: user
echo Password: $(kubectl get secret --namespace jupyter jupyterhub-hub -o jsonpath="{.data['values\.yaml']}" | base64 -d | awk -F: '/password/ {gsub(/[ \t]+/, "", $2);print $2}')
```
### You can access Jupyter notebooks using a URL like this:

```bash
http://20.67.149.113/user/user/lab/tree/opt/bitnami/jupyterhub-singleuser/Untitled.ipynb
```

### Test Jupyter Installation with a Deep Learning Model

The following code essentially demonstrates how to use a pre-trained deep learning model (MobileNetV2) to classify the content of an image fetched from a given URL and visualize the prediction along with the image. You can copy/paste to your Jupyter Notebook and execute it.


```python
import requests
from PIL import Image
import numpy as np
from io import BytesIO
import matplotlib.pyplot as plt
import tensorflow as tf
from tensorflow.keras.applications.mobilenet_v2 import MobileNetV2, preprocess_input, decode_predictions
from tensorflow.keras.preprocessing.image import img_to_array
import os


# Download an image from the Internet
def download_image(image_url):
    response = requests.get(image_url)
    if response.status_code == 200:
        img = Image.open(BytesIO(response.content))
        return img
    else:
        return None

# Predicts image content
def predict_image(model, img):
    img_resized = img.resize((224, 224))
    img_array = img_to_array(img_resized)
    img_array = np.expand_dims(img_array, axis=0)
    img_array = preprocess_input(img_array)

    predictions = model.predict(img_array)
    return decode_predictions(predictions, top=1)[0][0]

# Image URL
image_url = 'https://www.fklein.me/download/iphone2.jpg'  # Remplacez avec l'URL de l'image que vous souhaitez analyser

# Process recording with MLflow
# Download and analyze image
img = download_image(image_url)
if img is not None:
    model = MobileNetV2(weights='imagenet')
    prediction = predict_image(model, img)

    # Displays image and prediction
    plt.imshow(img)
    plt.axis('off')
    plt.title(f"\nObject: {prediction[1]} \n\n Confiance in the prediction : {prediction[2]*100:.3f}%\n")
    plt.show()
else:
    print("L'image n'a pas pu être téléchargée.")
```

### Prerequisite for MLflow
For using MLflow, install the Python package:
```bash
pip install mlflow
```
Restart the kernel after installation in Jupyter UI.

### To install MLflow, use the following Helm command:

```bash
helm install mlflow oci://harbor.jkolaric.eu/vac-library/charts/redhatubi-8/mlflow -n mlflow --create-namespace
```

### Expose the MLflow service:

```bash
export SERVICE_IP=$(kubectl get svc --namespace mlflow mlflow-tracking --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
echo "MLflow URL: http://$SERVICE_IP/"
```

### Login credentials:

```bash
echo Username: $(kubectl get secret --namespace mlflow mlflow-tracking -o jsonpath="{ .data.admin-user }" | base64 -d)
echo Password: $(kubectl get secret --namespace mlflow mlflow-tracking -o jsonpath="{.data.admin-password }" | base64 -d)
```


### Use Jupyter to test the MLflow Installation

The following code uses MLflow to track and log experiment information, metrics, and artifacts while performing image classification with the MobileNetV2 model. It also saves the model and the downloaded image for later reference and displays the image with the predicted object class and confidence score.

```python
import requests
from PIL import Image
import numpy as np
from io import BytesIO
import matplotlib.pyplot as plt
import tensorflow as tf
from tensorflow.keras.applications.mobilenet_v2 import MobileNetV2, preprocess_input, decode_predictions
from tensorflow.keras.preprocessing.image import img_to_array
import mlflow
import os

os.environ['MLFLOW_TRACKING_USERNAME'] = 'user'
os.environ['MLFLOW_TRACKING_PASSWORD'] = 'password'

# Configuration de MLflow
mlflow.set_tracking_uri('http://20.67.145.120:80')
mlflow.set_experiment("image_classification_experiment")

# Télécharge une image depuis Internet
def download_image(image_url):
    response = requests.get(image_url)
    if response.status_code == 200:
        img = Image.open(BytesIO(response.content))
        return img
    else:
        return None

# Prédit le contenu de l'image
def predict_image(model, img):
    img_resized = img.resize((224, 224))
    img_array = img_to_array(img_resized)
    img_array = np.expand_dims(img_array, axis=0)
    img_array = preprocess_input(img_array)

    predictions = model.predict(img_array)
    return decode_predictions(predictions, top=1)[0][0]

# URL de l'image
image_url = 'https://www.fklein.me/download/iphone2.jpg'  # Remplacez avec l'URL de l'image que vous souhaitez analyser

# Enregistrement du processus avec MLflow
with mlflow.start_run():
    # Télécharge et analyse l'image
    img = download_image(image_url)
    if img is not None:
        model = MobileNetV2(weights='imagenet')
        prediction = predict_image(model, img)
        
        # Log information
        mlflow.log_param("image_url", image_url)
        mlflow.log_metric("prediction_confidence", float(prediction[2]))

        # Log l'image
        img.save("predicted_image.jpg")
        mlflow.log_artifact("predicted_image.jpg")
        
        # Log an instance of the trained model for later use
        mlflow.tensorflow.log_model(model, artifact_path="object-detection")

        # Affiche l'image et la prédiction
        plt.imshow(img)
        plt.axis('off')
        plt.title(f"\nObject: {prediction[1]} \n\n Confiance in the prediction : {prediction[2]*100:.3f}%\n")
        plt.show()
    else:
        print("L'image n'a pas pu être téléchargée.")
```
## Image Classification Python Accelerator for TAP 🐍📸

The Python accelerator for TAP help you to deploy a serverless image classification function as a workload. The accelerator leverages the buildpacks provided by VMware's open-source Function Buildpacks for Knative project.

The accelerator includes the Python script that we execute before on Jupiter for image classification. It use the MobileNetV2 model and MLflow. It allows you to download an image from the internet, predict its contents, log the prediction and image in MLflow, and display the image with the prediction confidence

### Prequesite :
Have a Tanzu Application Platform installed with a Python accelerator:

To add the Python accelerator to your TAP Platform:

```bash
tanzu acc create awesome-python-ai-image-function --git-repo https://github.com/fklein82/awesome-ai-python-function.git --git-branch main --interval
```

Then clone this repository to your local development environment:
```bash
git clone <repository-url>
cd python-accelerator-for-tanzu
```

Inside the python-function directory, you will find the func.py file. This Python function is invoked by default and serves as the entry point for your serverless image classification logic.

```bash
python-function
    └── func.py // EDIT THIS FILE
```
You can customize the code inside this file to implement your specific image classification logic.

### Deployment

To deploy the application on VMware Tanzu Application Platform, follow these steps:

Ensure you have the Tanzu CLI installed and configured with access to your Tanzu Application Platform instance.

Navigate to your project directory:

```bash
cd [your-repo-directory]
```
Use the Tanzu CLI to deploy your application:
```bash
tanzu apps workload create -f config/workload.yaml
```
Monitor the deployment status:
```bash
tanzu apps workload tail awesome-python-ai-image-function --timestamp --since 1h
```
<div class="gallery-box">
  <div class="gallery">
    <img src="/images/logtap.png">
  </div>
</div>

Once deployed, access your application via the URL provided by Tanzu Application Platform. You can find the URL with the following command:
```bash
tanzu apps workload get awesome-python-ai-image-function
```
For detailed instructions on how to build, deploy, and test your customized serverless image classification function using Tanzu Application Platform, please refer to the Tanzu website.

## Conclusion
The expansive growth of data and AI in today's digital landscape presents both opportunities and challenges. While we're capable of generating and handling vast amounts of data, effectively utilizing this data through AI and ML is a complex task. The fact is that a small fraction of projects fully achieve their goals. Embracing methodologies like MLOps and leveraging platforms such as VMware's Tanzu Application Catalog and Tanzu Application Platform are essential. These tools not only streamline the process of deploying and managing AI applications but also facilitate collaboration across various roles, turning data into actionable insights and driving business value. Our demonstration shows how using JupyterHub and MLflow with these platforms effectively and efficiently applies these methods in real-world situations.

### Authors

This blog post was **co-written** with my friend [**Julien Kolaric**](https://www.linkedin.com/in/julien-kolaric-7557782a/). 

##### Linkedin :
- [Julien Kolaric](https://www.linkedin.com/in/julien-kolaric-7557782a/)
- [Frédéric Klein](https://www.linkedin.com/in/fklein82/)
<div class="gallery-box">
  <div class="gallery">
    <img src="/images/julien.jpeg">
     <img src="/images/fred.jpeg" height="158" width="158">
  </div>
</div>