FROM centos:latest
MAINTAINER Ray Lai <"rayymlai@gmail.com">
# Purpose: create a dockerfile container image for GMAT
# Author:  Ray Lai
# Updated: Jun 2, 2016
#
# VNC settings
ENV DISPLAY :1
ENV NO_VNC_HOME /root/noVNC
ENV VNC_COL_DEPTH 24
ENV VNC_RESOLUTION 1280x1024
ENV VNC_PW race2space

# install vnc, xvnc, xfce
RUN yum -y install epel-release; yum clean all
RUN yum -y update; yum clean all
RUN yum -y install sudo; yum clean all
RUN yum --enablerepo=epel -y -x gnome-keyring --skip-broken groups install "Xfce"; yum clean all
RUN yum -y groups install "Fonts"; yum clean all
RUN yum -y install tigervnc-server wget net-tools unzip firefox; yum clean all
RUN yum -y install vm vim-X11 vim-common vim-enhanced vim-minimal; yum clean all
RUN yum -y groupinstall "Desktop" "Desktop Platform" "X Window System" "Fonts"; yum clean all
RUN yum -y install tar vim wget nc curl zip unzip sudo firefox git; yum clean all
ENV TERM xterm

### Install noVNC - HTML5 based VNC viewer
RUN mkdir -p $NO_VNC_HOME/utils/websockify \
    && wget -qO- https://github.com/kanaka/noVNC/archive/master.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME \
    &&  wget -qO- https://github.com/kanaka/websockify/archive/v0.7.0.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME/utils/websockify \
    && chmod +x -v /root/noVNC/utils/*.sh

# install jdk 8
ENV JAVA_VERSION 8u91
ENV BUILD_VERSION b14
ENV JAVA_MAXMEMORY 256
RUN wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$BUILD_VERSION/jdk-$JAVA_VERSION-linux-x64.rpm" -O /tmp/jdk-8-linux-x64.rpm
RUN yum -y install /tmp/jdk-8-linux-x64.rpm
RUN alternatives --install /usr/bin/java java /usr/java/latest/bin/java 200000
RUN alternatives --install /usr/bin/javaws javaws /usr/java/latest/bin/javaws 200000
RUN alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000
ENV JAVA_HOME /usr/java/latest

# install GMAT
RUN yum -y install gtk3-devel xorg-x11-server-Xorg; yum clean all
RUN yum -y install cmake python-pip python34 freeglut-devel mesa-libGL mesa-libGL-devel; yum clean all

# install chrome browser
ADD repos /etc/yum.repos.d/
RUN yum -y install google-chrome-stable \
    && echo "alias google-chrome='/usr/bin/google-chrome --user-data-dir'" >> /root/.bashrc \
    && echo "alias google-chrome='/usr/bin/google-chrome -no-default-browser-check --user-data-dir'" >> /etc/bashrc

# xvnc server porst, if $DISPLAY=:1 port will be 5901
EXPOSE 5901
# novnc web port
EXPOSE 6901

ADD .vnc /root/.vnc
ADD .config /root/.config
ADD Desktop /root/Desktop
ADD scripts /root/scripts
RUN chmod +x  /root/scripts/*.sh /root/.vnc/xstartup /etc/xdg/xfce4/xinitrc /root/Desktop/*.desktop
RUN /bin/dbus-uuidgen > /etc/machine-id

ENTRYPOINT ["/root/scripts/vnc_startup.sh"]
CMD ["--tail-log"]
