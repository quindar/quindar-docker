FROM centos:centos7
MAINTAINER Ray Lai rayymlai@gmail.com

# install dependencies
RUN yum -y update; yum clean all
RUN yum -y groupinstall "Development Tools"; yum clean all
RUN yum -y install epel-release; yum clean all

RUN yum -y install vm vim-X11 vim-common vim-enhanced vim-minimal; yum clean all
RUN yum -y install tar vim wget nc curl zip unzip sudo firefoxi git; yum clean all
ENV TERM xterm

#  Download nodejs
RUN yum -y install nodejs npm; yum clean all

# Upgrade NodeJS to v0.12
#RUN wget https://rpm.nodesource.com/pub_0.12/el/7/x86_64/nodejs-0.12.9-1nodesource.el7.centos.x86_64.rpm
#RUN yum -y install ./nodejs-0.12.9-1nodesource.el7.centos.x86_64.rpm; yum clean all
RUN cd /tmp && wget http://nodejs.org/dist/v0.12.3/node-v0.12.3-linux-x64.tar.gz && cd /usr && tar --strip-components 1 -xzf /tmp/node-v0.12.3-linux-x64.tar.gz

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD . /opt/nodejs
RUN cd /opt/nodejs; npm install express mocha fs supertest

EXPOSE 8080

CMD ["node", "/opt/nodejs/app.js"]
