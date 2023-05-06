---
layout: post
title:  vSphere-with-Tanzu or k8s in vSphere?
description: vSphere-with-Tanzu (aka TKGs) is a powerful platform that enables businesses to deploy and manage Kubernetes clusters directly on their vSphere infrastructure. In this blog post, we'll take a closer look at VMware vSphere with Tanzu and how to use it with Tanzu CLI.
date:   2023-05-03 17:01:35 +0300
image:  '/images/vsphere-with-tanzu.png'
video_embed:
tags:   [vsphere-with-tanzu]
---

VMware vSphere-with-Tanzu is a powerful platform that enables businesses to deploy and manage Kubernetes clusters directly on their vSphere infrastructure. Tanzu is a VMware solution designed to simplify the deployment and management of Kubernetes for enterprise organizations. In this blog post, we'll take a closer look at VMware vSphere with Tanzu and how to use it with Tanzu CLI.

### What is Tanzu CLI?

Tanzu CLI is a command-line tool that provides a simplified interface for managing Kubernetes clusters and applications. It is designed to make it easy to manage Kubernetes clusters across multiple cloud providers, including vSphere with Tanzu.

Using Tanzu CLI, you can deploy and manage Kubernetes clusters, deploy and manage applications, and automate common tasks. It is a powerful tool that can help simplify the management of Kubernetes for enterprise organizations.

### How to use vSphere-with-Tanzu and the Tanzu CLI ?

Here's a step-by-step guide on how to use VMware vSphere with Tanzu with Tanzu CLI:

### Step 1: Install the Tanzu CLI and the Kubectl + vSphere plugin

The first step is to install the Tanzu CLI on your local machine. You can do this by asking your vsphere administrator to Get the link to the Kubernetes Command Line Interface Tools download page.

![image](/images/cli-tanzu.jpeg)

### Step 2: Configure the vSphere environment

Next, you'll need to configure your vSphere environment to work with Tanzu CLI. This involves setting up the appropriate credentials and configuring the vSphere endpoint. You can do this by running the following command:

~~~
kubectl vsphere login --server <vCenter server address> --vsphere-username <vCenter username> --insecure-skip-tls-verify
~~~

This will authenticate you with vSphere and allow you to manage your Kubernetes clusters using Tanzu CLI.

### Step 3: Create a Tanzu Kubernetes cluster

Once you've configured your vSphere environment, you can create a Tanzu Kubernetes cluster using the classical kubectl apply:

- First craft the yaml that will describe the cluster topology:

~~~
apiVersion: run.tanzu.vmware.com/v1alpha2           #TKGS API endpoint
kind: TanzuKubernetesCluster                        #required parameter
metadata:
  name: tkgs-dev01                                  #cluster name, user defined
  namespace: vns-dev-01
spec:
  topology:
    controlPlane:
      replicas: 1                                   #number of control plane nodes
      vmClass: best-effort-small                    #vmclass for control plane nodes
      storageClass: kubernetes-sp
      tkr:  
        reference:
          name: v1.21.6---vmware.1-tkg.1.b3d708a
    nodePools:
    - name: worker-nodepool-a1
      replicas: 1                                   #number of worker nodes
      vmClass: best-effort-small                    #vmclass for worker nodes
      storageClass: kubernetes-sp
      tkr:  
        reference:
          name: v1.21.6---vmware.1-tkg.1.b3d708a
~~~

- And then apply the file with the kubectl command

~~~
kubectl apply -f workload_prod_cluster01.yaml
~~~

### Step 4: Deploy your workloads

With your Tanzu Kubernetes cluster up and running, you can now deploy your container workloads using Kubernetes manifests or Helm charts. Tanzu CLI provides a number of built-in tools and integrations to make this process as simple and streamlined as possible.

- Connect to the Tanzu Kubernetes cluster

~~~
kubectl vsphere login --server <vCenter server address> --vsphere-username <vCenter username> --insecure-skip-tls-verify -tanzu-kubernetes-cluster-name <tkgs-dev01> --tanzu-kubernetes-cluster-namespace <vns-dev-01>
~~~

- Apply cluster rolebinding 

~~~
kubectl create clusterrolebinding default-tkg-admin-privileged-binding --clusterrole=psp:vmware-system-privileged --group=system:authenticated
~~~

- Deploy my blog App 

~~~
kubectl create deployment fredblog --image=registry.fklein.me/tanzu-blog/fklein-blog:2023-05-04-11-44-18 --port=80
~~~

- Expose the app (through a Loadbalancer L4 for example)

~~~
kubectl expose deployment fredblog --port 80 --type LoadBalancer --target-port=80
~~~

- Check the ip and connect with your browser

~~~
kubectl get svc 
~~~

### Step 5: Manage your Kubernetes clusters

Using Tanzu CLI, you can manage your Kubernetes clusters, including scaling them up or down, updating the Kubernetes version, and more. This provides a powerful command-line interface for managing both your VMs and containers.

### Conclusion

VMware vSphere with Tanzu is a powerful platform that enables businesses to deploy and manage Kubernetes clusters directly on their vSphere infrastructure. Tanzu CLI is a command-line tool that provides a simplified interface for managing Kubernetes clusters and applications. By following the steps outlined above, you can get started with VMware vSphere with Tanzu and Tanzu CLI and begin deploying and managing your container workloads more easily and efficiently.