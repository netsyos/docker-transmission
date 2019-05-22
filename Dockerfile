FROM netsyos/nginx:latest
ARG DEBIAN_FRONTEND="noninteractive"
ARG LIDARR_BRANCH="develop"
ENV XDG_CONFIG_HOME="/config/xdg"

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN apt install apt-transport-https
RUN echo "deb https://download.mono-project.com/repo/ubuntu stable-xenial/snapshots/5.16.0 main" | tee /etc/apt/sources.list.d/mono-official-stable.list
RUN apt-get update
RUN apt-get -y install python git jq
RUN apt-get -y install mono-devel libmono-cil-dev
RUN mono --version

RUN apt-get -y install transmission-daemon
RUN apt-get -y install libcurl4-openssl-dev bzip2 mediainfo sqlite3

RUN \
 echo "**** install packages for lidarr****" && \
 apt-get install --no-install-recommends -y \
	libchromaprint-tools

RUN \
 echo "**** install lidarr ****" && \
 mkdir -p /var/lidarr && \
 mkdir -p /app/lidarr && \
 if [ -z ${LIDARR_RELEASE+x} ]; then \
	LIDARR_RELEASE=$(curl -sL "https://services.lidarr.audio/v1/update/${LIDARR_BRANCH}/changes?os=linux" \
	| jq -r '.[0].version'); \
 fi && \
 lidarr_url=$(curl -sL "https://services.lidarr.audio/v1/update/${LIDARR_BRANCH}/changes?os=linux" \
	| jq -r "first(.[] | select(.version == \"${LIDARR_RELEASE}\")) | .url") && \
 curl -o \
 /tmp/lidarr.tar.gz -L \
	"${lidarr_url}" && \
 tar ixzf \
    /tmp/lidarr.tar.gz -C \
	/app/lidarr --strip-components=1



RUN \
 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC && \
 echo "deb http://apt.sonarr.tv/ master main" > /etc/apt/sources.list.d/sonarr.list

RUN apt-get update && apt-get install -y nzbdrone
RUN mkdir -p /var/sonarr


RUN cd /opt && \
file="" && \
while [ -z "$file" ]; do sleep 1 && file=$( curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d '"' -f 4 ); done  && \
echo Radarr File $file && \
wget $file && \
tar -xvzf Radarr.*.linux.tar.gz
RUN mkdir -p /var/radarr

RUN \
file="" && \
while [ -z "$file" ]; do sleep 1 && file=$( curl -s https://api.github.com/repos/Jackett/Jackett/releases | grep Binaries.Mono.tar.gz | grep browser_download_url | head -1 | cut -d '"' -f 4 ); done  && \
echo Jackett file $file && \
wget $file && \
tar -xvf Jackett* && \
mkdir /opt/jackett && \
mv Jackett/* /opt/jackett



RUN apt-get install -y libunwind8
COPY config/default/* /etc/default/

RUN mkdir /etc/service/transmission
ADD service/transmission.sh /etc/service/transmission/run
RUN chmod +x /etc/service/transmission/run

RUN mkdir /etc/service/sonarr
ADD service/sonarr.sh /etc/service/sonarr/run
RUN chmod +x /etc/service/sonarr/run

RUN mkdir /etc/service/radarr
ADD service/radarr.sh /etc/service/radarr/run
RUN chmod +x /etc/service/radarr/run

RUN mkdir /etc/service/lidarr
ADD service/lidarr.sh /etc/service/lidarr/run
RUN chmod +x /etc/service/lidarr/run

RUN mkdir /etc/service/jackett
ADD service/jackett.sh /etc/service/jackett/run
RUN chmod +x /etc/service/jackett/run

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