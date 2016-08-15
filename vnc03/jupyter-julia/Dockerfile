# This Dockerfile is used to build an sakuli image based on Ubuntu

FROM ubuntu:14.04

MAINTAINER Tobias Schneck "tobias.schneck@consol.de"
ENV REFRESHED_AT 2015-12-01

ENV JAVA_VERSION 8u65
ENV JAVA_HOME /usr/lib/jvm/java-$JAVA_VERSION

ENV DEBIAN_FRONTEND noninteractive
ENV DISPLAY :1
ENV NO_VNC_HOME /root/noVNC
ENV VNC_COL_DEPTH 24
ENV VNC_RESOLUTION 1280x1024
ENV VNC_PW race2space

ENV SAKULI_DOWNLOAD_URL https://labs.consol.de/sakuli/install

############### add linux-mint dependicies and update packages
RUN apt-key adv --recv-key --keyserver keyserver.ubuntu.com "3EE67F3D0FF405B2"
RUN echo "deb http://packages.linuxmint.com/ rafaela main upstream import" >> /etc/apt/sources.list.d/mint.list \
    && echo "deb http://extra.linuxmint.com/ rafaela main " >> /etc/apt/sources.list.d/mint.list

############### xvnc / xfce installation
RUN apt-get update && apt-get upgrade -y && apt-get install -y supervisor vim xfce4 vnc4server wget unzip firefox
### Install noVNC - HTML5 based VNC viewer
RUN mkdir -p $NO_VNC_HOME/utils/websockify \
    && wget -qO- https://github.com/kanaka/noVNC/archive/master.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME \
    &&  wget -qO- https://github.com/kanaka/websockify/archive/v0.7.0.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME/utils/websockify \
    && chmod +x -v /root/noVNC/utils/*.sh

##### Add Oracle JAVA JRE8
RUN mkdir -p $JAVA_HOME \
    # download and extract
    && wget -qO- $SAKULI_DOWNLOAD_URL/3rd-party/java/jre-$JAVA_VERSION-linux-x64.tar.gz | tar xz --strip 1 -C $JAVA_HOME \
    # set alternatives
    && update-alternatives --install "/usr/bin/java" "java" "$JAVA_HOME/bin/java" 1 \
    && update-alternatives --install "/usr/bin/javaws" "javaws" "$JAVA_HOME/bin/javaws" 1 \
    && update-alternatives --install "/usr/lib/firefox/browser/plugins/mozilla-javaplugin.so" "mozilla-javaplugin.so" "$JAVA_HOME/lib/amd64/libnpjp2.so" 1

### Install chrome browser
RUN apt-get install -y chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg \
    && ln -s /usr/bin/chromium-browser /usr/bin/google-chrome \
    && echo "alias chromium-browser='/usr/bin/chromium-browser --user-data-dir'" >> /root/.bashrc

# xvnc server porst, if $DISPLAY=:1 port will be 5901
EXPOSE 5901
# novnc web port
EXPOSE 6901

ADD .vnc /root/.vnc
ADD .config /root/.config
ADD Desktop /root/Desktop
ADD scripts /root/scripts
RUN chmod +x /root/.vnc/xstartup /etc/X11/xinit/xinitrc /root/scripts/*.sh /root/Desktop/*.desktop

# install julia
USER root
RUN apt-get update
RUN apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o DPkg::Options::="--force-confold" 
RUN apt-get install -y man-db libc6 libc6-dev build-essential wget curl file vim screen tmux unzip
RUN apt-get install -y pkg-config cmake gfortran gettext libreadline-dev libncurses-dev libpcre3-dev 
RUN apt-get install -y libgnutls28-dev python python-yaml python-m2crypto python-crypto msgpack-python
RUN apt-get install -y python-dev python-setuptools supervisor python-zmq python-jinja2
RUN apt-get install -y python-requests python-isodate python-git python-pip 
RUN apt-get clean 
RUN pip install --upgrade PyDrive google-api-python-client jsonpointer jsonschema tornado sphinx pygments nose readline mistune invoke 
RUN git clone --recursive --branch 3.x https://github.com/ipython/ipython.git; cd ipython; python setup.py install; cd ..; rm -rf ipython

RUN mkdir -p /opt/julia_0.6.0 && curl -s -L https://status.julialang.org/download/linux-x86_64 | tar -C /opt/julia_0.6.0 -x -z --strip-components=1 -f - 
RUN ln -fs /opt/julia_0.6.0 /opt/julia 
RUN echo "PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/opt/julia/bin\"" > /etc/environment && echo "export PATH" >> /etc/environment && echo "source /etc/environment" >> /root/.bashrc 
RUN /opt/julia/bin/julia -e 'Pkg.add("IJulia")'

ENTRYPOINT ["/root/scripts/vnc_startup.sh"]
CMD ["--tail-log"]
