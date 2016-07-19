# Quindar-docker - Managing Docker Containers
Updated: Jun 8, 2016

# Overview
The purpose of using docker container is to allow better management of creating Linux server nodes (e.g. automated, easier to upgrade), and optimizing server resources (e.g. 1 sec to start up a server node).  Container technology is usually considered the better option to optimize hardware resource because it does not use hypervisor technology to emulate the underlying hardware; it leverages native kernel and shared server resources such that the same parent docker host can run faster docker containers in the same machine.

This document depicts how you can build a basic platform stack using docker container to support your development (e.g.  NodeJS server), testing, migration to production. It also covers the DevOps infrastructure including Jenkins server for continu
ous integration.

Typically, DevOps engineers will create a parent docker host first, say, on RackSpace, amazon or your preferred cloud. They will only need basic components such as docker binaries, so that they can start to create new docker containers.  For example, they can create a CentOS Linux 7 host, and install docker binaries from https://docs.docker.com/engine/installation/linux/centos/.  Assuming their required docker images are already available from docker registry (public or private), they can start running new docker containers within seconds.

## Folder Structure
This project will include 4 main dockerfile definitions to create Web application development environment based on MEAN stack (MongoDB-Express-AngularJS-NodeJS).

/gmat - GMAT R2015a mission planning software
/mongodb - MongoDB database with additional database management tools
/nodejs - NodeJS with automated testing and additional npm modules
/ssh    - Linux sandbox with Julia binaries installed, accessible via SSH

The following subfolders are not customized so we do not publish custom dockerfiles.
/jenkins
/netdata
/rabbitmq

Each subfolder should contain a list of automated scripts in the file Dockerfile.  If there are additional config files or resources, they will be also documented with a readme.md file.

## Basic DevOps Infrastructure
A basic SaaS application will require
* Application server - in this case, we use NodeJS. We also add GMAT, which is a Matlab-like graphical package for simulation and data visualization, very essential for visual modeling and mission planning/operations. 
* Database - in this case, we use MongoDB with details how to set up a replica set of 3 nodes, and add database security.
* Middleware
  * RabbitMQ messaging server - in this case, this is a single node of RabbitMQ server, but we can extend by adding more instances to a RabbitMQ cluster.
  * WebSocket server - in this case, this is a single node of socket.io WebSocket server for real-time data streaming.
* Continuous integration - in this case, we use Jenkins server to automate the task of deploying NodeJS applications, running automated testing and creating/retiring docker containers. 

## Creating Docker Host
1. Login to your cloud provider, e.g. RackSpace
2. Select Create Server
3. Specify your server size, e.g. for development server, specify 4GB memory general purpose server
4. Your cloud provider will provide you the admin/root password. You can save it in a secure place.
5. Server access - Optional: (1) Create and add your SSH public keys. This will allow you to login to your server without prompting username and password each time. The benefit is that Linux server will white-list the users for login only if their SSH public keys are added to the file .ssh/authorized_keys stored in the Linux server. (2) Amazon AWS allows you to create .pem or key to login. However, if the key is stolen, then the server will be exposed to unauthorized users.
6. Data volume - it is a common practice to attach a data volume to the Linux server to allow more storage, and faster storage (if SSD data volume is used). For docker containers, it is also common to map to shared folders from the mounted data volume, such that whenever an old or new docker container is launched, it can retrieve the same data.
7. Admin users - you can create additional admin users.
8. Install docker binaries and other dependencies.
* To install docker binaries on CentOS, refer to https://docs.docker.com/engine/installation/linux/centos/ for details. You need to add a custom docker.repo, and execute "sudo yum install docker-engine". 
* Recommended Linux packages to install: JDK 8 (Java), X11 package (for GUI visual display).

### Reference
https://support.rackspace.com/how-to/preparing-data-disks-on-linux-cloud-servers/ explains how to mount a data volume to a Linux host.

## Creating Docker Images
There are 6 main docker images used:
* NodeJS server
* MongoDB
* RabbitMQ server
* Jenkins (continuous integration)
* NetData (server monitoring)
* GMAT (for mission planning, orbit trajectory calculation and simulation)

To build a docker container image, you need a file "Dockerfile", and you can build the image by:
```
docker build -t yournamespace/dockerimagename .
```

Example:
```
%sudo docker build -t rayymlai/nodejs .
```

## Creating Docker Containers
* Naming convention - define your naming convention for docker container instances, e.g. node01, node02, ... for your NodeJS server.
* Use external data volume as shared folders for each docker container. If your docker container stores data in the mounted data volume, you can back up the data volume periodically using your cloud provider. Besides, when you restart your docker containers, or add new docker containers, they can re-use the same data without the need to migrate existing data.
* 

Common commands to manage docker containers:
* To run or launch a new docker container 
 
```
docker run -d --name myname -p 1234:5678 yournamespace/dockerimagename
```

* If you want to map the container to a shared data volume:
```
docker run -d --name myname -p 1234:5678 -v /mnt/data/prod/mysharedfolder:/opt/mydockerfolder yournamespace/dockerimagename
```

Example:
```
%sudo docker run --name node08 --hostname platform.audacy.space -d -v /mnt/data01/prod/quindar-platform:/src -p 7902:3000 -p 7903:3001 -p 7904:3002 -p 7905:3003 rayymlai/nodejs 
```

* To access the Linux command shell of the docker container, you need to ssh to the docker host first (assuming your docker container does not expose remote access via SSH directly, outside the docker host):

```
docker exec -ti mydockercontainername /bin/bash
```

Example:
```
%sudo docker exec -ti node08 bash
```

## Creating Basic SaaS Environment - DevOps Runbook
This set of instructions will build Quindar development environment from scratch, after you create a docker host.

The high level steps are:
1. create jenkins
2. create NodeJS Web server
3. create mongoDB, and set up database cluster (MongoDB replica set) and database security
4. create RabbitMQ server
5. create NetData server for systems monitoring
6. set up automated build job to deploy NodeJS whenever there are code changes pushed to GitHub
7. run automated tests 
8. verify docker setup for reliability and availability

(Detailed examples will be added)

## Test cases
In order to verify your docker setup, we need to verify the following test cases:
* Restart - If a docker container crashes or stops, you should be able to restart without losing data (if external data volume is mapped)
* Recovery - If data volume is corrupted or inaccessible (unmounted or offline), you should be able to restore from backup.
* Database recovery - If the primary MongoDB node is offline, then one of the secondary MongoDB nodes should take over as primary nodes. 
* Load balancing - If we configure a new endpoint (e.g. nodejs.audacy.space) to map to a load balancer, and set a round robin to 3 nodejs servers (which have 3 different unique HTTP port numbers if using docker). Workload should be distributed to 3 nodejs servers
* Continuous integration - we can set up Jenkins to start or stop docker containers. There are at least 2 ways to verify: (1) Use docker API. This will require setting up SSL keys on docker host.  (2) Use Jenkins 1.x which has embedded docker plugin. You can create a Jenkins job to run docker commands (not docker API) but you need to set up Linux access rights and shared folders with any docker containers.

# Appendix
## Primer to Using Docker
https://docs.docker.com/ provides a good and concise tutorial.

There are plenty of concise tutorials on docker, e.g.
* http://prakhar.me/docker-curriculum/
* https://scotch.io/tutorials/getting-started-with-docker
* http://www.slideshare.net/larrycai/learn-docker-in-90-minutes
* https://github.com/gopher-net/dockerized-net-tools/tree/master/docker-tutorial
* https://prezi.com/v1n3o4y4tvoc/get-dockerized-in-90-minutes/
* https://www.jayway.com/2015/03/21/a-not-very-short-introduction-to-docker/
* http://developers.redhat.com/blog/2014/05/15/practical-introduction-to-docker-containers/
* http://blog.flux7.com/blogs/docker/docker-tutorial-series-part-1-an-introduction

## Setting up Your Learning Environment
* For Windows or mac users, you may consider creating a Linux virtual machine using VirtualBox.
Most tutorials recommend beginners to use Vagrant in conjunction with docker because Vagrant has some
useful scripting to automate creating docker images using virtual machines running on VirtualBox.
* Alternatively, you may consider using a Linux machine hosted in RackSpace, amazon or your cloud providers.

## How to Extend
* Manageability - We can encapsulate the creation and management of these docker containers using "docker swarm" or "mesophere" for automated build.
* Reliability - We can add "Consul" which can detect heartbeats from each docker container, and then manage the lifecycle of docker containers, e.g. if we lose a heart beat, we can re-launch the docker container, or to add a new container instance.* Scalability - We can enable load balancing capability by adding nginx (for reverse proxy) or haproxy (for load balancing). 

