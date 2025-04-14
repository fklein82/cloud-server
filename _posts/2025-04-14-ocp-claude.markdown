---
layout: post
title:  Supercharging OpenShift with MCP - Natural Language Meets Cloud-native Ops
description: Use natural language to control OpenShift with Claude Desktop and the open-source MCP server.
date:   2025-04-14 09:00:00 +0200
image:  '/images/MCP-OCP2.png'
video_embed: 
tags:   [AI]
---

## From KubeCon to Openshift...

After attending the **KubeCon Europe 2025**, one major takeaway was clear:  AI isn’t just a trend, it’s redefining the future of infrastructure and developer tools

Many sessions focused on how to **hide infrastructure complexity** through approaches like **Platform Engineering** and **AI-powered developer tools**. I came home inspired to test it out myself.

So I built a simple demo: using **Claude Desktop**, **OpenShift**, and the **Model Context Protocol (MCP)** to show how natural language can drive real actions in a live Kubernetes cluster.

And yes — it works. Let me show you how.

![claude](/images/list-pods.png "claude")

## What is MCP – Model Context Protocol?

Connecting AI models to real-world systems like APIs, databases, or Kubernetes is usually complex and requires custom code.

The **Model Context Protocol (MCP)**, created by Anthropic, is an **open standard** that makes this much easier.

It allows AI models (like Claude) to understand the context and **safely perform actions** by talking to small programs called **MCP servers**.

![mcp](/images/mcp-server.png "mcp")

## A Kubernetes MCP Server, Built by [Marc Nuri](https://www.linkedin.com/in/marcnuri/)

My colleague [Marc](https://www.linkedin.com/in/marcnuri/) at Red Hat has developed a open-source MCP server implementation:  
🔗 [kubernetes-mcp-server](https://github.com/manusa/kubernetes-mcp-server)

This MCP server can:
- Connect to any Kubernetes or OpenShift cluster  
- Read and manage pods, namespaces, events, deployments, and more  
- Show pod logs, execute commands, and even run containers  
- Work seamlessly with Claude Desktop or VS Code  

It runs locally with no dependency on `kubectl`, `helm`, or other CLI tools — lightweight, flexible, and ready to use.

## Live Demo: Claude Diagnoses and Fixes a Broken Pod on OpenShift

Let’s walk through a simple and visual demo you can try today.

We’ll deploy a pod that fails to start (due to a bad image), then use Claude to identify the issue and fix it — using natural language only.

### What You Need

- A **Mac** with [Homebrew](https://brew.sh)
- [Claude Desktop](https://www.anthropic.com/index/claude-desktop) installed
- A running **OpenShift** cluster (for example on AWS like me)
- OpenShift CLI (`oc`):

```bash
brew install openshift-cli
```

Make sure you can log in to your OpenShift cluster:

```bash
oc login <cluster-url> --token=sha256-...
```

### Step 1: Connect Claude to the MCP server

Open this file:

```bash
open ~/Library/Application\ Support/Claude\ Desktop/claude_desktop_config.json
```

And add:

```json
{
  "mcpServers": {
    "kubernetes": {
      "command": "npx",
      "args": [
        "-y",
        "kubernetes-mcp-server@latest"
      ]
    }
  }
}
```

Then restart Claude Desktop and verify that the MCP Server is running.

![mcp](/images/run_ok.png "mcp")

### Step 2: Create a Broken Pod

Let’s create a pod in a new namespace, using a non-existent image.

```bash
oc create namespace demo

cat <<EOF | oc apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: mon-app
  namespace: demo
  labels:
    app: mon-app
spec:
  containers:
    - name: web
      image: nginx:doesnotexist
      ports:
        - containerPort: 80
EOF
```

The pod will fail with an `ImagePullBackOff` error.

![mcp](/images/pod_errors.png "mcp")

![mcp](/images/ocp-errors.png "mcp")

### Step 3: Let Claude Fix It

In Claude Desktop, simply type:

```
Diagnose and fix the pod `mon-app` in the `demo` namespace.
```

Claude will:

- Inspect the pod and retrieve logs and events  
- Detect the image error  
- Suggest replacing the image with a working version (`nginx:latest`)  
- Apply the change if you confirm  

All this, using natural language and the MCP server — no CLI needed.

![mcp](/images/diagnose_and_solve.png "mcp")

### Step 4: Clean Up

Once you're done:

```bash
oc delete namespace demo
```

## Security Considerations

As with any automation that interacts directly with a live Kubernetes cluster, it’s important to apply proper safeguards. While using natural language to drive actions is powerful, it can also introduce risk if commands aren’t well-scoped or validated.

For example (and this actually happened during my testing) the AI confidently suggested pulling an image… and two lines earlier, it quietly picked the latest tag. 

_Spoiler: that’s rarely what you want in production._

![mcp](/images/diagnose_and_solve_notok.png "mcp")

So, always make sure to:
- Validate image tags explicitly (avoid :latest)
- Use admission policies or image scanners when possible
- Limit the scope of actions the assistant is allowed to perform
- Log and monitor AI-triggered activity separately

Natural language makes things easier — let’s make sure it doesn’t also make them riskier.

##  Bonus: OpenShift Lightspeed ⚡️

Red Hat also offers a **built-in AI assistant** for OpenShift:  
🔗 [OpenShift Lightspeed](https://www.redhat.com/en/products/interactive-walkthrough/red-hat-openshift-lightspeed)

Lightspeed enables:

- YAML generation and validation with AI  
- Built-in troubleshooting suggestions  
- Secure, production-ready GenAI workflows — right in the OpenShift web console  

If MCP + Claude is the open playground for experimentation, **Lightspeed is the enterprise solution**, fully integrated and supported.

---

## 🧭 What’s Next?

In my **next blog post**, I’ll dive into **OpenShift Lightspeed** — how it works, and how it helps DevOps teams.

![mcp](/images/lightspeed.png "mcp")
