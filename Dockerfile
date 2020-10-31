FROM netsyos/nginx:latest
ARG DEBIAN_FRONTEND="noninteractive"
ARG LIDARR_BRANCH="develop"
ENV XDG_CONFIG_HOME="/config/xdg"

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN apt-get update
RUN apt install apt-transport-https sudo
RUN apt-get -y install python git jq
RUN apt-get -y install transmission-daemon
RUN apt-get -y install libcurl4-openssl-dev bzip2 mediainfo sqlite3


RUN apt-get install -y libunwind8

COPY config/default/* /etc/default/

RUN mkdir /etc/service/transmission
ADD service/transmission.sh /etc/service/transmission/run
RUN chmod +x /etc/service/transmission/run

RUN mkdir /etc/service/logs
ADD service/logs.sh /etc/service/logs/run
RUN chmod +x /etc/service/logs/run

# Clean up APT when done.
RUN \ 
    echo "**** cleanup ****" && \
    apt-get clean && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/*
