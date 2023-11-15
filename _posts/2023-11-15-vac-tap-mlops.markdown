---
layout: post
title:  'Accelerate AI: VAC & TAP in Action'
description: Discover the power of MLOps with Tanzu's VMware Application Catalog (VAC) and Tanzu Application Platform (TAP). Build a demo that can transform complex data into cutting-edge AI applications, illustrating the seamless journey from data engineering to model deployment and beyond.
date:   2023-11-15 14:00:35 +0300
image:  '/images/mclaren.png'
tags:   [MLOPS]
---

### The Data Landscape and AI Proliferation
In a world where over 64.2 zettabytes of data are generated annually, the metaphor of traveling to the moon and back thousands of times if each byte were a kilometer vividly captures the enormity of data we're generating. This data, sprawling across billions of devices and the Internet of Things (IoT), isn't confined to a single location; it's distributed across multiple clouds and mixed environments.

With half a billion business data users worldwide, catering to a vast spectrum of needs and skills becomes imperative. However, it's not just the storage that's crucial; it's the intelligent utilization of this data through AI and machine learning that empowers a billion workers. Yet, the road to implementing AI is laden with challenges.

### The Challenge of Resource Constraints and Complexity
The stark reality is that only 1% of AI/ML projects fully achieve their objectives, underscoring a pressing challenge for the industry—not just in technology, but in strategy, support, and execution. No-code/low-code solutions emerge as a priority, with 96% of IT and engineering leaders acknowledging the acute shortage of software engineers. The complexity is another significant hurdle, with 72% of organizations still figuring out AI operationalization in their businesses.

### MLOps: A Beacon of Success in AI
MLOps stands out as the strategic approach that could pivot more AI projects into the 1% success bracket. It's about the right partners, strategy, and platform. For Tanzu Solution Engineers like us, it's about leveraging the 'DOO' framework, streamlining the app journey with TAP and the Golden Paths, optimizing app performance with our TKO bundle, and fostering continuous improvement with our Tanzu intelligence portfolio.

MLOps is essentially about DevSecOps, but with a unique spin for managing AI and ML projects efficiently. It involves:

- Preparing Data: Collecting, cleaning, and shaping data to train AI models effectively.
- Building the Model: Experimenting with various models to find the best fit and ensure reliability.
- Deploying, Consuming, and Monitoring: Integrating the model into applications, delivering business value, and ongoing performance monitoring.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/ai-mlops1.png">
  </div>
</div>

MLOps isn't a solo journey; it's a collaborative team sport where each role is crucial:

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

Together, they turn data into actionable insights and drive business value, ensuring MLOps transcends model development—it becomes a comprehensive solution-delivery system.

### Our MLOps Demo: From Concept to Application
In our demo, we'll illustrate this collaborative spirit in action. Julien will wear the dual hats of a Platform Engineer and Data Scientist—first deploying JupyterLab and MLflow, then creating a smart image-detection model. Subsequently, I will take Julien's model and swiftly incorporate it into a Python accelerator as an App Developer.

This is the essence of our MLOps approach—seamless integration of roles and tools, transforming innovative ideas into real-world applications with Tanzu's suite of products.

We will demonstrate just how efficiently and effectively we can harness the combined strength of JupyterHub, MLFlow, and TAP to bring AI models from development to deployment. For our demonstration we will VMware Application Catalog (VAC) and Tanzu Application Platform (TAP).

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/ai-mlops3.png">
  </div>
</div>

### VMware Application Catalog (VAC)
VAC is an enterprise solution that simplifies the utilization of open-source software in production environments. It offers a comprehensive catalog of tested open-source applications, with features like automated maintenance and vulnerability insights. This facilitates secure and compliant development processes.

### Tanzu Application Platform (TAP)
TAP, a Platform as a Service (PaaS) solution, eases the deployment and management of cloud-native applications on Kubernetes. It enhances developer productivity and offers features like container orchestration, automation, and multi-cloud support.

## JupyterHub

JupyterHub is a web-based platform that enables multiple users to collaboratively create and work with Jupyter notebooks on a shared server. It offers a secure and customizable environment, supports multiple users, and is commonly used in education, research, and data analysis for its collaborative and interactive capabilities.

### To install JupyterHub, use the following Helm command:

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

The following code essentially demonstrates how to use a pre-trained deep learning model (MobileNetV2) to classify the content of an image fetched from a given URL and visualize the prediction along with the image. You can copy/paste to your Jupyter and execute it.


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
# Télécharge et analyse l'image
img = download_image(image_url)
if img is not None:
    model = MobileNetV2(weights='imagenet')
    prediction = predict_image(model, img)

    # Affiche l'image et la prédiction
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

## MLFlow

MLflow is a tool that helps people who work with machine learning (ML) to do their work more easily. It helps with tracking and organizing ML experiments, packaging code, and deploying ML models. It's useful for managing the entire ML process, from trying out ideas to putting models into real-world applications.

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

The following code uses MLflow to track and log experiment information, metrics, and artifacts while performing image classification with a pre-trained MobileNetV2 model. It also saves the model and the downloaded image for later reference and displays the image with the predicted object class and confidence score.

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
os.environ['MLFLOW_TRACKING_PASSWORD'] = 'K1aLXzz0QW'

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

The accelerator includes the Python script that we execute before on Jupiter for image classification. It use the MobileNetV2 model and MLflow. It allows you to download an image from the internet, predict its contents, log the prediction and image in MLflow, and display the image with the prediction confidence. This serverless function can be easily integrated into your application or workflow.

### Prequesite :
Have a Tanzu Application Platform installed.

To add the accelerator to your Platform:

```bash
tanzu acc create awesome-python-ai-image-function --git-repo https://github.com/fklein82/awesome-ai-python-function.git --git-branch main --interval
```

Clone this repository to your local development environment:
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

If you want to explore more code samples for serverless functions that can be deployed within Tanzu Application Platform, you can check out the samples folder.

### Image Classification Function
The core functionality of this accelerator is the image classification function, which performs the following steps:

- Downloads an image from a specified URL.
- Predicts the content of the image using the MobileNetV2 model.
- Logs the prediction and image in MLflow for tracking.
- Displays the image with the prediction confidence.
This function can be integrated into various applications and workflows that require image analysis and classification.

### Deployment
For detailed instructions on how to build, deploy, and test your customized serverless image classification function using Tanzu Application Platform, please refer to the Tanzu website.

To deploy this application on VMware Tanzu Application Platform, follow these steps:

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
Once deployed, access your application via the URL provided by Tanzu Application Platform. You can find the URL with the following command:
```bash
tanzu apps workload get awesome-python-ai-image-function
```


## Conclusion
In this  guide, we've covered a wide range of topics related to MLOps (Machine Learning Operations), DevOps, JupyterHub, MLflow, and the integration of various technologies, including VMware Application Catalog (VAC) and Tanzu Application Platform (TAP). Let's summarize the key takeaways:

### MLOps Demo with VAC and TAP
This guide has provided detailed instructions for setting up JupyterHub and MLflow on your Kubernetes (K8s) system, leveraging the power of VMware Application Catalog (VAC). The objective is to enable you to create an impressive MLOps demonstration and showcase AI applications deployed on Tanzu Application Platform (TAP), a robust Platform as a Service (PaaS) solution running seamlessly on top of Kubernetes.

With TAP, you can effortlessly deploy AI applications that utilize a Machine Learning API exposed by Kubeflow. Whether you're an AI enthusiast, data scientist, or a tech enthusiast, this guide empowers you to harness the potential of K8s, VAC, and TAP for an awe-inspiring AI journey.

VMware Tanzu Application Catalog simplifies and secures the use of open-source software components for production. It offers a diverse catalog of rigorously tested open-source applications, automated maintenance, vulnerability insights, and more. This streamlines development while ensuring security and compliance. Tanzu Application Catalog is the enterprise version of the open-source Bitnami Application Catalog, providing stronger control and visibility into open-source software supply chains.

VMware Tanzu Application Platform is a platform-as-a-service (PaaS) solution that simplifies the deployment and management of cloud-native applications and microservices in a Kubernetes environment. It offers developer productivity, container orchestration, self-service deployment, automation, monitoring, multi-cloud support, and security features.

### MLOps vs DevOps
MLOps and DevOps are related concepts focused on streamlining and automating software development and deployment processes, but they have different areas of application and emphasis:

- DevOps (Development and Operations): DevOps aims to unify software development and IT operations teams, focusing on improving collaboration, automation, and the software development lifecycle. Its goal is to shorten development cycles and enhance the quality of deployments.

- MLOps (Machine Learning Operations): MLOps is an extension of DevOps tailored specifically for machine learning and AI projects. It covers the end-to-end process of developing, deploying, and managing machine learning models in production. The primary goal is to streamline and automate the ML lifecycle.

Key differences include scope, focus on data, the model lifecycle, and specialized tools and technologies used in MLOps.

### JupyterHub
JupyterHub is a collaborative, web-based platform that allows multiple users to create and work with Jupyter notebooks on a shared server. It offers a secure and customizable environment, making it ideal for education, research, and data analysis.

### MLflow
MLflow is a versatile tool for tracking, organizing, packaging, and deploying machine learning experiments and models. It simplifies the entire ML process, from experimenting with ideas to deploying models in real-world applications. The guide includes instructions for installing and using MLflow in your environment.

To illustrate the capabilities of JupyterHub and MLflow, a code example was provided for image classification using a pre-trained MobileNetV2 model. This code showcases how to download an image, make predictions, log experiment information, metrics, and artifacts using MLflow, and display the image with predictions.

Before using MLflow, don't forget to install the Python package using pip install mlflow and restart the Jupyter kernel if necessary.

### In a nutshell
This guide give you the knowledge and tools needed to set up a powerful MLOps environment using VAC, TAP, JupyterHub, and MLflow. It empowers you to explore the exciting world of AI and machine learning with confidence, whether you're a data scientist, developer, or IT professional.

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