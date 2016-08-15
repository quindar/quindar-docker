FROM centos:centos7
MAINTAINER Ray Lai <rayymlai@gmail.com>

RUN yum -y update; yum clean all
RUN yum -y groupinstall "Development Tools"; yum clean all
RUN yum -y install autoconf automake bzip2 gcc gcc-c++ gcc-gfortran git m4 make patch perl tar wget nc; yum clean all
RUN yum -y install vm vim-X11 vim-common vim-enhanced vim-minimal; yum clean all
RUN yum -y install curl zip unzip sudo; yum clean all
RUN yum -y install epel-release; yum clean all

# install cmake, dependency for Julia and MbedTLS
RUN yum -y install cmake; yum clean all
#RUN mkdir -p /src/
#WORKDIR /src/
#RUN wget http://www.cmake.org/files/v3.0/cmake-3.0.0.tar.gz
#RUN tar -zxvf cmake-3.0.0.tar.gz
#WORKDIR cmake-3.0.0
#RUN ./bootstrap
#RUN gmake
#RUN gmake install

# install Julia
RUN yum -y install epel-release wget; yum clean all
ADD julia.repo /etc/yum.repos.d/julia.repo
RUN yum -y install julia; yum clean all

# install nodejs
RUN yum -y install nodejs npm
RUN yum -y clean all && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ADD . /opt/nodejs
RUN cd /opt/nodejs; npm install express mocha fs supertest

EXPOSE 8080
#CMD ["node", "/opt/nodejs/server.js"]

# install ssh
RUN yum -y install openssh-server passwd; yum clean all
RUN mkdir /var/run/sshd

RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
ENV TERM xterm

ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE 22
RUN /start.sh
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
