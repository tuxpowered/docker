#!/bin/sh
set -e
mkdir -p /usr/share/applications
mkdir -p /tmp/crashplan
wget -O- ${CRASHPLAN_INSTALLER} | tar -xz --strip-components=1 -C /tmp/crashplan

cd /tmp/crashplan && /tmp/crashplan.exp || exit $?
cd / 

# Bind the UI port 4243 to the container ip
sed -i "s|</servicePeerConfig>|</servicePeerConfig>\n\t<serviceUIConfig>\n\t\t\
<serviceHost>0.0.0.0</serviceHost>\n\t\t<servicePort>4243</servicePort>\n\t\t\
<connectCheck>0</connectCheck>\n\t\t<showFullFilePath>false</showFullFilePath>\n\t\
</serviceUIConfig>|g" /usr/local/crashplan/conf/default.service.xml

# Remove unneccessary files and directories
rm -rf /usr/local/crashplan/jre/lib/plugin.jar \
   /usr/local/crashplan/jre/lib/ext/jfxrt.jar \
   /usr/local/crashplan/jre/bin/javaws \
   /usr/local/crashplan/jre/lib/javaws.jar \
   /usr/local/crashplan/jre/lib/desktop \
   /usr/local/crashplan/jre/plugin \
   /usr/local/crashplan/jre/lib/deploy* \
   /usr/local/crashplan/jre/lib/*javafx* \
   /usr/local/crashplan/jre/lib/*jfx* \
   /usr/local/crashplan/jre/lib/amd64/libdecora_sse.so \
   /usr/local/crashplan/jre/lib/amd64/libprism_*.so \
   /usr/local/crashplan/jre/lib/amd64/libfxplugins.so \
   /usr/local/crashplan/jre/lib/amd64/libglass.so \
   /usr/local/crashplan/jre/lib/amd64/libgstreamer-lite.so \
   /usr/local/crashplan/jre/lib/amd64/libjavafx*.so \
   /usr/local/crashplan/jre/lib/amd64/libjfx*.so

rm -rf /boot /home /lost+found /media /mnt /run /srv
rm -rf /usr/share/applications
rm -rf /tmp/crashplan
rm -rf /usr/local/crashplan/log
rm -rf /var/cache/apk/*
