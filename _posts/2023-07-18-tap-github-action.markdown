---
layout: post
title:  'Discover How to Integrate Tanzu Application Platform with Github Actions: A Step-by-Step Guide.'
description: Explore the powerful synergy of Github Actions and Tanzu Application Platform (TAP) in our latest blog post. Learn to automate Docker image creation from a Jekyll blog, push it to Docker Hub and a personal Harbor registry, and deploy it using TAP in a Kubernetes environment. The post simplifies the complexities of Kubernetes deployment, allowing you to focus on coding while improving your CI/CD pipeline efficiency.
date:   2023-07-18 14:00:35 +0300
image:  '/images/tap-github-action.png'
tags:   [CI/CD]
---

In **modern software development practices**, the Continuous Integration/Continuous Delivery **(CI/CD) pipeline** plays a vital role. It automates the process of integrating code changes and delivering the product to the production environment. In this post, we'll look at how we can integrate an existing **Github Actions CI pipeline** with the **Tanzu Application Platform** for seamless application delivery on a Kubernetes environment.


### Our Objectives
The use case we'll be exploring involves a Jekyll blog, a static website crafted with Jekyll's static site generator. Our objective is threefold:

1. **Automate the Docker Image Creation**: We aim to automate the process of constructing a Docker image from the Jekyll blog.

2. **Push Docker Image to Registries**: Following the creation, the Docker image should be automatically pushed to both Docker Hub and a personal Harbor registry upon any changes to the blog.

3. **Deploy and Expose the Blog with TAP**: Finally, we aim to utilize Tanzu Application Platform to deploy and expose the Jekyll blog on a Kubernetes cluster.

In order to achieve these objectives, we will set up a Dockerfile, configure a Github Actions workflow, and configure the Tanzu Application Platform.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/schema.png">
  </div>
</div>

#### What is Github & TAP ?

- **Github** is a web-based platform for software development using Git. It allows developers to collaborate, track changes, and manage code repositories. It offers features like version control, issue tracking, code review, and CI/CD automation through GitHub Actions. GitHub simplifies collaboration and helps developers work together effectively on projects.

- **Tanzu Application Platform** or **TAP**, is a cloud-native application platform developed by VMware Tanzu. It simplifies the deployment and management of applications on Kubernetes clusters, providing developers with an easier way to deploy and run their applications at scale. TAP automates the creation and management of Kubernetes resources, allowing developers to focus on writing code rather than dealing with infrastructure complexities.

### Leveraging Existing CI/CD Pipelines with Tanzu
Many organizations today have already invested significant effort into creating CI/CD pipelines that work well for their needs. In our case, we're looking at a scenario where we already have a Github Actions CI pipeline in place. The question is, how can we extend this to leverage Tanzu Application Platform's capabilities for the CD part of our pipeline?

The Tanzu Application Platform is designed to simplify the process of deploying and managing applications on Kubernetes. It's built with the understanding that developers and operators need a simplified, more effective way to build and run modern, cloud-native applications. By integrating Tanzu into your existing pipeline, it can take over the complexities of networking, scaling, and operational management, providing you a more effective way to build and run modern, cloud-native applications

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/tap-blog-cd.png">
  </div>
</div>

If you already have a Github Actions pipeline for building and pushing Docker images (the CI part), you can easily integrate this with Tanzu Application Platform for the deployment part (CD). The built Docker images will be pushed to Docker Hub or your personal Harbor registry and Tanzu will handle the deployment of these images into a Kubernetes environment.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/github-action-pipeline.png">
  </div>
</div>

### Integrating Tanzu with Github Actions - What we will do?
As we dive into this integration process, it's important to clarify what we're trying to achieve. In this particular scenario, we will be dealing with my personal Jekyll blog (blog.fklein.me). Jekyll is a popular static site generator that takes Markdown files and converts them into a complete static website. Our main goal here is to build a Docker image from this Jekyll blog, and then push this image to two different container registries: Docker Hub and a personal Harbor registry.

#### Step 1: Configure Github Actions – Set up Github Actions to automate tasks like building an docker image and push it to a registry.

- **To be able to build a Docker image from our Jekyll blog**, we will need a **Dockerfile** in our project. A Dockerfile is a text document that contains all the commands a user could call on the command line to assemble an image.

This is an example of a Dockerfile to run the Jekyll Blog:
~~~
# Container image that runs your code
FROM php:8.2-apache

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY /_site/ /var/www/html/
~~~

The source code is available on my github repo: https://github.com/fklein82/cloud-server

- **Once our Dockerfile is set up and our Jekyll blog is ready to be containerized**, we'll use **Github Actions to automate the Build process**. Each time a change is pushed to our Github repository (which could be a new blog post, an update to an existing post, a layout change, etc.), Github Actions will trigger our workflow.

Our workflow is defined in the YAML file in the .github/workflows directory. It starts by checking out the source code from our repository, and then it logs into Docker Hub using the credentials we've stored as secrets in our Github repository.

Next, it retrieves the current date and time, which we'll use to tag our Docker image. The Docker image is then built from our Dockerfile and tagged with the current date.

The workflow then pushes the newly built Docker image to Docker Hub, allowing it to be pulled and run on any Docker-enabled system that can access Docker Hub.

In the next steps, the workflow logs into a personal Harbor registry. Harbor is an open-source cloud-native registry that stores, signs, and scans container images for vulnerabilities. Just like with Docker Hub, the workflow then pushes our Docker image to the Harbor registry.

With this workflow, not only are we able to keep our Docker image up-to-date on Docker Hub and our personal Harbor registry automatically, but we can also ensure that our Jekyll blog is quickly and consistently deployed each time we make a change.

This is the : .github/workflows/push-docker-image.yaml file
~~~
name: Build-Push-DockerHUB-Harbor
on: [push] # When pushing to any branch then run this action
# Env variable
env:
  DOCKER_USER: ${{secrets.DOCKER_USER}}
  DOCKER_PASSWORD: ${{secrets.DOCKER_PASSWORD}}
  REPO_NAME: ${{secrets.REPO_NAME}}
  HARBOR_USER: ${{secrets.HARBOR_USER}}
  HARBOR_PASSWORD: ${{secrets.HARBOR_PASSWORD}}
jobs:
  push-image-to-docker-hub:  # job name
    runs-on: ubuntu-latest  # runner name : (ubuntu latest version) 
    steps:
    - uses: actions/checkout@v2 # first action : checkout source code
    - name: DockerHub login
      run: | # log into docker hub account
        docker login -u $DOCKER_USER -p $DOCKER_PASSWORD  
    - name: Get current date # get the date of the build
      id: date
      run: echo "::set-output name=date::$(date +'%Y-%m-%d-%H-%M-%S')"
    - name: Build the Docker image # push The image to the docker hub
      run: docker build . --file Dockerfile --tag $DOCKER_USER/$REPO_NAME:${{ steps.date.outputs.date }} --tag registry.fklein.me/tanzu-blog/fklein-blog:${{ steps.date.outputs.date }}
    - name: DockerHub Push
      run: docker push $DOCKER_USER/$REPO_NAME:${{ steps.date.outputs.date }}
    - name: Fklein Harbor login
      run: | # log into Personal Harbor account
        docker login registry.fklein.me -u $HARBOR_USER -p $HARBOR_PASSWORD  
    - name: fklein harbor Push
      run: docker push registry.fklein.me/tanzu-blog/fklein-blog:${{ steps.date.outputs.date }}
~~~



#### Step 2: Unleashing Tanzu Application Platform for Deployment
After your Github Actions workflow successfully builds and pushes the Docker image of your Jekyll blog to Docker Hub or your personal Harbor registry, it's time for Tanzu Application Platform (TAP) to take the lead. In our case, we have deployed TAP on top of AKS (Azure Kubernetes Service), which provides a robust and scalable Kubernetes cluster.

**TAP simplifies the deployment process** by automating the creation and management of Kubernetes resources, such as deployments, services, and pods. With TAP on AKS, you get the benefits of both Tanzu's streamlined deployment experience and AKS's reliable and scalable infrastructure.

To deploy your Jekyll blog using TAP on AKS, you can utilize the Tanzu CLI with the following command:

~~~
tanzu apps workload create blog \
  --type web \
  --label app.kubernetes.io/part-of=blog \
  --image registry.fklein.me/tanzu-blog/fklein-blog:2023-07-18-14-23-00
~~~

This command is an instruction set to Tanzu to orchestrate the creation of a new workload for your blog. It includes essential configurations for the deployment - the type of the workload, any necessary labels or annotations, and crucially, the Docker image to use. Once this information is processed, Tanzu swings into action, deploying this image seamlessly into your Kubernetes environment.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/tanzu-cli.png">
  </div>
</div>

The integration of Tanzu in this process not only offloads the complexity of deployment from your team but also ensures an efficient, scalable and robust solution, leaving you free to focus on your core application development tasks.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/delivery-cd-tap.png">
  </div>
</div>

But that's not all—TAP goes a step further by integrating continuous deployment and security testing into the supply chain.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/image-scan.png">
  </div>
</div>



With the continuous deployment pipeline configured in Tanzu, you can seamlessly integrate security testing steps before deploying your applications. These steps can include vulnerability scanning and compliance checks to ensure your deployments meet the required security standards. This helps you deliver high-quality and secure applications to your users.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/cve-dashboard.png">
  </div>
</div>


#### Conclusion
Incorporating Tanzu Application Platform with Github Actions allows you to extend your existing CI pipelines and benefit from Tanzu's powerful application management capabilities. This setup enables automated and consistent deployments of your applications into a Kubernetes environment, eliminating the need for complex YAML files and streamlining the deployment process.

By integrating Tanzu, you can leverage its higher-level abstractions and standardized components to simplify the deployment of your applications on Kubernetes. Tanzu handles the creation and management of Kubernetes resources, such as deployments, services, and pods, so you can focus on writing code rather than dealing with infrastructure complexities.

<div class="gallery-box">
  <div class="gallery">
    <img src="/images/kubedeploy.png">
  </div>
</div>


This seamless integration between **Tanzu Application Platform** and **Github Actions** showcases Tanzu's flexibility and its ability to seamlessly integrate with pre-existing workflows. You can continue to leverage the power of Github Actions for your CI pipeline, while Tanzu takes care of the deployment process on Kubernetes.

By leveraging **Tanzu Application Platform**, you save time and ensure repeatability in your deployment processes. The automation provided by Tanzu eliminates manual steps and reduces the risk of errors, leading to more efficient and consistent deployments.

In conclusion, **Tanzu Application Platform is an excellent choice** for organizations looking to optimize their Kubernetes application deployments. By integrating it with Github Actions, you can **enhance your CI pipeline**, **simplify the deployment process**, and enjoy the benefits of automated and consistent deployments into a Kubernetes environment, **all without the need for complex YAML files**.


