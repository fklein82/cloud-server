
# Frederic Klein personal blog

Hello, and welcome to my blog! My name is Frédéric KLEIN, and I’m a solution engineer at VMware Tanzu. I have a passion for helping organizations design and implement cloud-native architectures using Kubernetes and Tanzu.

In addition to my work as a solution engineer, I also love to write and share my knowledge with others. On this blog, you’ll find a variety of articles about architectures, talks, and best practices related to Kubernetes, Tanzu, web development, data management, ethics, privacy, and development.

Whether you’re a seasoned pro or just getting started in the world of cloud computing, my blog has something for everyone. From technical tutorials to free resources and inspiration, I’m committed to providing value to the tech community and helping others succeed.

So, if you’re looking to stay up-to-date on the latest trends and technologies in cloud computing and software development, be sure to follow my blog and stay tuned for new articles and updates. Thanks for reading, and I look forward to connecting with you soon!

[Fred's Blog](https://blog.fklein.me)

* * *

### Theme features

- Works with GitHub Pages (host it for free)
- Dark and light mode user can select themself
- No jQuery, only vanilla JS
- 100% responsive Design
- Clean and Modern Code
- Optimized for mobile devices
- Super fast performance ⚡⚡⚡
- Social sharing buttons
- Scroll to top button
- Syntax highlighting (supports the Jekyll syntax highlighter)
- Compatible with modern browsers
- Medium style image zoom
- Image Lazy loading
- Image gallery
- Tags Page
- Custom logo support
- Supports video posts
- Supports contact form (Formspree)
- Supports MailChimp newsletter
- Supports Disqus comments
- Supports Google Analytics
- Ionicons icons
- Free Google Fonts
- Free Updates & Support

* * *

### Installation

#### Installing Ruby & Jekyll

If this is your first time using Jekyll, please follow the [Jekyll docs](https://jekyllrb.com/docs/installation/) and make sure your local environment (including Ruby) is setup correctly.

* * *

### Deployment

To run the theme locally, navigate to the theme directory and run `bundle install` to install the dependencies, then run `jekyll serve` or `bundle exec jekyll serve` to start the Jekyll server.

I would recommend checking the [Deployment Methods](https://jekyllrb.com/docs/deployment-methods/) page on Jekyll website.

* * *

### Docker Image Build & Push on Registries

- Public registry: <a href="https://hub.docker.com/r/yfke8313/blog/tags">DockerHUB</a>
- Private registry: <a href="https://registry.fklein.me/harbor/projects/26/repositories/fklein-blog/artifacts-tab">Harbor</a>

### How to deploy the website on Kubernetes? Some Examples...

1. Create the deployment:
~~~
kubectl create deployment fredblog --image=registry.fklein.me/sarycom/src-website:2023-05-03-10-24-45 --port=80
~~~

2. Expose the website with a Loadbalancer L4:
~~~
kubectl expose deployment fredblog --port 80 --type LoadBalancer --target-port=80 -n demotbs
~~~

3. Check the ip:
~~~
k get svc -n fredblog
~~~

4. Delete the ressource
~~~
k delete deployment fredblog
k delete service fredblog
~~~

* * *

### Support

<p>If you have any questions, please feel free to contact me by mail <a href="mailto:frederic.klein@gmail.com">Contact</a><p>