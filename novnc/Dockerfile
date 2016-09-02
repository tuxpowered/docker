FROM frolvlad/alpine-glibc:alpine-3.4

# Setup demo environment variables
ENV HOME=/root \
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768 \
    CRASHPLAN_VERSION=5.3.0 \
    CRASHPLAN_SERVICE=Code42CrashPlan \
    CRASHPLAN_INSTALLER=http://hosted.dfatech.ca:4280/client/installers/Code42CrashPlan_5.3.0_1452924000530_344_Linux.tgz

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY crashplan.exp /
COPY crashplan_install.sh /
COPY entrypoint.sh /

# x11vnc, xterm is in testing repo
RUN echo "http://dl-3.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk --update --upgrade add \
	cpio --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/ \
    bash \
	fluxbox \
	git \
	wget \
	supervisor \
	libvncserver \
	xterm \
	xvfb

# Install git, supervisor, VNC, & X11 packages
RUN apk --update add bash wget ca-certificates openssl findutils coreutils procps expect sed

# Install updates Crashplan
RUN apk --update --upgrade add \
	libnotify \
	gconf \
	libnss
	
RUN /crashplan_install.sh

# Clone noVNC from github
RUN git clone https://github.com/kanaka/noVNC.git /root/noVNC \
	&& git clone https://github.com/kanaka/websockify /root/noVNC/utils/websockify \
	&& rm -rf /root/noVNC/.git \
	&& rm -rf /root/noVNC/utils/websockify/.git \
	&& apk del git 
	
# Modify the launch script 'ps -p'
RUN sed -i -- "s/ps -p/ps -o pid | grep/g" /root/noVNC/utils/launch.sh

EXPOSE 8080 4243 4242

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
