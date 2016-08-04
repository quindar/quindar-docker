FROM centos:centos7
MAINTAINER Ray Lai <rayymlai@gmail.com>

RUN yum -y update; yum clean all
RUN yum -y groupinstall "Development Tools"; yum clean all
RUN yum -y install autoconf automake bzip2 gcc gcc-c++ gcc-gfortran git m4 make patch perl tar wget nc; yum clean all
RUN yum -y install vm vim-X11 vim-common vim-enhanced vim-minimal; yum clean all
RUN yum -y install curl zip unzip sudo; yum clean all
RUN yum -y install epel-release; yum clean all
RUN yum -y install pwgen wget logrotate; yum clean all
RUN yum -y install rabbitmq-server; yum clean all
RUN /usr/lib/rabbitmq/bin/rabbitmq-plugins enable rabbitmq_management

ENV TERM xterm

#
# add run/set passwd script
ADD run-rabbitmq-server.sh /run-rabbitmq-server.sh
RUN chmod 750 ./run-rabbitmq-server.sh
#
# generated password will be found under  /etc/rabbitmq/rabbitmq.config

# expose some ports
#
# 5672 rabbitmq-server - amqp port
# 15672 rabbitmq-server - for management plugin
# 4369 epmd - for clustering
# 25672 rabbitmq-server - for clustering
EXPOSE 5672 15672 4369 25672

#
# entrypoint/cmd for container
# we will set a random password and add one vhost for development
ENV DEVEL_VHOST_NAME develop

CMD ["/run-rabbitmq-server.sh"]
