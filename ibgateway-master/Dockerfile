FROM phusion/baseimage:18.04-1.0.0

############# Global Tasks #############
USER root
SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive \
    DISABLE_SYSLOG=0 \
    DISABLE_SSH=1 \
    DISABLE_CRON=1 \
    DISPLAY=:0 \
    TZ=America/Argentina/Buenos_Aires

CMD ["/sbin/my_init"]

RUN install_clean \
        wget \
        unzip \
        socat \
        xvfb \
        libxrender1 \
        libxtst6 \
        libxi6 \
        x11vnc \
 && echo "source /etc/profile" >> /root/.bashrc
########################################

################ Services ##############
ENV VNC_PASSWORD=123456 \
    VNC_PORT=5900
COPY components/services/xvfb /etc/service/00_xvfb
COPY components/services/vnc /etc/service/01_vnc
COPY components/services/ibc /etc/service/02_ibc
COPY components/services/socat /etc/service/03_socat

RUN chmod a+x /etc/service/*/*
########################################

###### Instalacion del IBGateway #######
# TODO: DETECTAR LA VERSION IBGateway
ENV IBGATEWAY_PKG_URL="https://download2.interactivebrokers.com/installers/ibgateway/stable-standalone/ibgateway-stable-standalone-linux-x64.sh"
ADD ${IBGATEWAY_PKG_URL} /tmp/ibgateway.sh
RUN chmod a+x /tmp/ibgateway.sh \
 && echo -e "\nn" | /tmp/ibgateway.sh -c \
 && rm -f /tmp/ibgateway.sh \
 && stat /usr/local/i4j_jres/**/**/bin | grep File | awk '{print "export JAVA_PATH="$2}' > /etc/profile.d/java.sh
COPY components/ibgateway/* /root/Jts/
########################################

##### Instalacion del IBController #####
#ENV IBCONTROLLER_PKG_URL="https://github.com/ib-controller/ib-controller/releases/download/3.4.0/IBController-3.4.0.zip" \
#ENV IBCONTROLLER_PKG_URL="http://cdn.quantconnect.com/interactive/IBController-QuantConnect-3.2.0.5.zip" \
ENV IBC_PKG_URL="https://github.com/IbcAlpha/IBC/releases/download/3.18.0-Update.1/IBCLinux-3.18.0.zip" \
    IBC_INI=/root/IBC/config.ini \
    IBC_PATH=/opt/IBC \
    TWS_MAJOR_VRSN=1019 \
    TWS_PATH=/root/Jts \
    TWS_CONFIG_PATH=/root/Jts \
    LOG_PATH=/root/IBC/Logs \
    TRADING_MODE=paper \
    FIXUSERID='' \
    FIXPASSWORD='' \
    TWSUSERID="<usr_change_me>" \
    TWSPASSWORD="<pwd_change_me>" \
    APP=GATEWAY

ADD ${IBC_PKG_URL} /tmp/ibc.zip
RUN mkdir -p /{root,opt}/IBC/Logs \
 && unzip /tmp/ibc.zip -d /opt/IBC/ \
 && cd /opt/IBC/ \
 && chmod o+x *.sh */*.sh \
 && sed -i 's/     >> \"\${log_file}\" 2>\&1/     2>\&1/g' scripts/displaybannerandlaunch.sh \
 && sed -i 's/light_red=.*/light_red=""/g' scripts/displaybannerandlaunch.sh \
 && sed -i 's/light_green=.*/light_green=""/g' scripts/displaybannerandlaunch.sh \
 && rm -f /tmp/ibc.zip
COPY components/ibc/* /root/IBC/
########################################

################### Don't move ###################
ARG BUILD_DATE
ARG BUILD_VCS_REF
ARG BUILD_VERSION
ARG BUILD_PROJECT_URL
ARG BUILD_COMMITER_NAME
ARG BUILD_COMMITER_MAIL
LABEL ar.com.scabb-island.ibgateway.maintainer="Manuel Andres Garcia Vazquez <mvazquez@scabb-island.com.ar>" \
      ar.com.scabb-island.ibgateway.license=GPL-3.0 \
      ar.com.scabb-island.ibgateway.build-date=${BUILD_DATE} \
      ar.com.scabb-island.ibgateway.vcs.url="${BUILD_PROJECT_URL}" \
      ar.com.scabb-island.ibgateway.vcs.ref.sha=${BUILD_VCS_REF} \
      ar.com.scabb-island.ibgateway.vcs.ref.name=${BUILD_VERSION} \
      ar.com.scabb-island.ibgateway.vcs.commiter="${BUILD_COMMITER_NAME} <${BUILD_COMMITER_MAIL}>"
##################################################
