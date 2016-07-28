FROM centos:centos7
MAINTAINER Ray Lai rayymlai@gmail.com

# install dependencies
RUN yum -y update; yum clean all
RUN yum -y groupinstall "Development Tools"; yum clean all
RUN yum -y install epel-release; yum clean all

RUN yum -y install vm vim-X11 vim-common vim-enhanced vim-minimal; yum clean all
RUN yum -y install tar vim wget nc curl zip unzip sudo firefoxi git; yum clean all
ENV TERM xterm

# install nodejs 6.x
RUN cd /tmp && curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
RUN cd /tmp && yum -y install nodejs; yum clean all

#Update npm
RUN npm install npm -g

#Install nodemon (nodejs CI tool)
RUN npm install nodemon -g

#Install forever (nodejs CI tool)
RUN npm install forever -g

EXPOSE 3000

ADD . /opt/nodejs
RUN cd /opt/nodejs; npm install express mocha fs supertest

WORKDIR /opt/nodejs
ENTRYPOINT ["forever", "--killSignal=SIGTERM", "--minUptime=10000", "--spinSleepTime=20000", "-c", "nodemon --delay 10 --exitcrash", "server.js"]
