FROM centos:centos7
MAINTAINER Ray Lai <rayymlai@gmail.com>

# install dependencies
RUN yum -y update; yum clean all
RUN yum -y groupinstall "Development Tools"; yum clean all
RUN yum -y install epel-release; yum clean all
RUN yum -y install vm vim-X11 vim-common vim-enhanced vim-minimal; yum clean all
RUN yum -y install tar wget nc curl zip unzip sudo firefox; yum clean all
ENV TERM xterm

# install mongodb v3.2
# RUN yum -y install mongodb-server; yum clean all
ADD ./mongodb.repo /etc/yum.repos.d/mongodb.repo
RUN yum -y install mongodb-org; yum clean all
RUN mkdir -p /data/db
#RUN /etc/rc.d/init.d/mongod restart
RUN chkconfig mongod on

# install pymongo dependencies (python and pip)
RUN yum install gcc
# RUN cd /tmp
#RUN wget -qO- https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tgz | tar xzf Python-2.7.10.tgz
#RUN cd /tmp/Python-2.7.10
#RUN ./configure
#RUN make altinstall
RUN python -V

# install pymongo 3.2.1
RUN yum -y install python-pip; yum clean all
RUN python -m pip install pymongo

# install mongoDB tools
RUN yum -y install python-devel; yum clean all
RUN pip install --upgrade pip
RUN pip install virtualenv
#RUN cd /tmp
RUN git clone https://github.com/jwilder/mongodb-tools
RUN ls -al
RUN cd ./mongodb-tools && ls -al && ./setup.sh && source ./virtualenv/bin/activate

EXPOSE 27017
ENTRYPOINT ["/usr/bin/mongod"]
