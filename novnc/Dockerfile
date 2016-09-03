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
    MAX_MEMORY_MB=4096 \
    CRASHPLAN_INSTALLER=http://hosted.dfatech.ca:4280/client/installers/Code42CrashPlan_5.3.0_1452924000530_344_Linux.tgz

RUN mkdir -p /tmp/installation

COPY crashplan.exp /tmp/installation
COPY install.sh /tmp/installation
COPY entrypoint.sh /
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chmod 0755 /tmp/installation/crashplan.exp
RUN chmod 0755 /tmp/installation/install.sh
RUN chmod 0755 /entrypoint.sh

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
	nss
	
RUN /tmp/installation/install.sh && rm -rf /tmp/installation

# Clone noVNC from github
RUN git clone https://github.com/kanaka/noVNC.git /root/noVNC \
	&& git clone https://github.com/kanaka/websockify /root/noVNC/utils/websockify \
	&& rm -rf /root/noVNC/.git \
	&& rm -rf /root/noVNC/utils/websockify/.git \
	&& apk del git 
	
# Modify the launch script 'ps -p'
RUN sed -i -- "s/ps -p/ps -o pid | grep/g" /root/noVNC/utils/launch.sh

VOLUME [ "/var/crashplan", "/storage" ]

EXPOSE 8080 4243 4242

WORKDIR /usr/local/crashplan
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
