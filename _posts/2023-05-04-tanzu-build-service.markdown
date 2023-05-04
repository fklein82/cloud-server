---
layout: post
title:  Tanzu Build Service - Automating Container Image Building and Management
description: Tanzu Build Service is a Kubernetes-native tool that automates the process of building, managing, and updating container images. How do I use TBS?
date:   2023-04-06 15:01:35 +0300
image:  '/images/06.png'
video_embed: https://www.youtube.com/embed/XqN_tqNxTOo
tags:   [tanzu-build-service]
---

### Tanzu Build Service: Automating Container Image Building and Management

As organizations continue to adopt modern software development practices, containers have become a popular way to package and deploy applications. However, building and managing container images can be a time-consuming and error-prone task, especially at scale. Tanzu Build Service is a tool that helps automate this process, making it easier for developers to focus on writing code and delivering business value.

### What is Tanzu Build Service?

Tanzu Build Service is a Kubernetes-native tool that automates the process of building, managing, and updating container images. It leverages Cloud Native Buildpacks, an open-source technology that provides a modular and composable approach to building containers. Cloud Native Buildpacks automatically detect the language and framework of an application and create optimized container images that are free from security vulnerabilities.

Tanzu Build Service provides a declarative way to define how container images should be built, including which base images to use, which buildpacks to include, and how to configure the resulting images. This declarative approach ensures that all images are built consistently, regardless of the developer or environment.

### How does Tanzu Build Service work?

Tanzu Build Service uses a set of controllers and operators to manage the entire container image build process. Developers define a build configuration, which specifies the source code location, buildpacks, and other build parameters. Tanzu Build Service then creates a build plan that determines the exact build steps required to create the container image. Finally, the build process is executed using Cloud Native Buildpacks, which create a secure and optimized container image.

Once the container image is built, Tanzu Build Service automatically stores it in a container registry, such as Harbor or Docker Hub. This ensures that the image is available to all developers, regardless of their location or access permissions.

- With one line, you can create an OCI that is listening to a git repository, and then push the image to a registry

~~~
kp image create fkleinblog --tag registry.fklein.me/tbs/fkleinblog:1.1 --git https://github.com/fklein82/tbs-blog-demo.git --git-revision main -n dev
~~~

- You can check the log of build the image

~~~
kp build logs fkleinblog -n dev
~~~

- Check the list of image

~~~
kp image list -n dev
~~~

### What are the benefits of Tanzu Build Service?

Tanzu Build Service provides several benefits for developers and IT organizations, including:

Consistency: Tanzu Build Service ensures that all container images are built using the same base images, buildpacks, and configurations, regardless of the developer or environment.

Security: Cloud Native Buildpacks automatically detect and remediate security vulnerabilities, ensuring that all container images are free from known security issues.

Speed: Tanzu Build Service automates the build process, reducing the time required to build and update container images.

Scalability: Tanzu Build Service can be easily scaled to support large and complex applications, making it an ideal solution for enterprise environments.

Ease of use: Tanzu Build Service provides a simple and intuitive interface for developers to define and manage container images, reducing the need for manual intervention.

### Conclusion

Tanzu Build Service is a powerful tool that automates the process of building, managing, and updating container images. By leveraging Cloud Native Buildpacks, Tanzu Build Service provides a secure, consistent, and scalable approach to container image management, freeing developers to focus on writing code and delivering business value. If you're looking to streamline your container image management process, Tanzu Build Service is definitely worth considering.

### More information


- Source code Application demo to test TBS : 

~~~
https://github.com/fklein82/tbs-blog-demo/tree/main
~~~

- Script to Make a demo on Kubernetes CNFC Compliant

~~~
https://github.com/fklein82/tbs-blog-demo/blob/main/demo/demo.sh
~~~