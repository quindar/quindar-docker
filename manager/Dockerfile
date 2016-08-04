FROM centos

RUN yum -y update; yum clean all
RUN yum -y groupinstall "Development Tools"; yum clean all
RUN yum -y install vm vim-X11 vim-common vim-enhanced vim-minimal; yum clean all
RUN yum -y install tar vim wget nc curl zip unzip firefoxi git; yum clean all
ENV TERM xterm

#Download nodejs
RUN cd /usr && curl https://nodejs.org/dist/v4.4.5/node-v4.4.5-linux-x64.tar.xz | tar --strip-components 1 -xJ

#Update npm
RUN npm install npm -g

ENV PATH $PATH":/opt/nodejs/bin"

RUN npm install apidoc -g
RUN npm install openssl -g
RUN yum -y install openssl
RUN npm install mocha -g

WORKDIR /opt/nodejs

ENTRYPOINT ["/bin/bash", "-c"]
