FROM netsyos/nginx:latest

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN apt install apt-transport-https
RUN echo "deb https://download.mono-project.com/repo/ubuntu stable-xenial/snapshots/5.16.0 main" | tee /etc/apt/sources.list.d/mono-official-stable.list
RUN apt-get update
RUN apt-get -y install python git
RUN apt-get -y install mono-devel libmono-cil-dev
RUN mono --version

RUN apt-get -y install transmission-daemon
RUN apt-get -y install libcurl4-openssl-dev bzip2 mediainfo sqlite3


RUN git clone --depth 1 https://github.com/RuudBurger/CouchPotatoServer.git /opt/couchpotato
RUN mkdir /etc/couchpotato
RUN mkdir /var/couchpotato
RUN useradd --system --user-group --no-create-home couchpotato
RUN chown -R couchpotato:couchpotato /opt/couchpotato
RUN chown -R couchpotato:couchpotato /etc/couchpotato
RUN chown -R couchpotato:couchpotato /var/couchpotato


RUN \
 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC && \
 echo "deb http://apt.sonarr.tv/ master main" > /etc/apt/sources.list.d/sonarr.list

RUN apt-get update && apt-get install -y nzbdrone
RUN mkdir -p /var/sonarr


RUN \
 echo "**** install jq ****" && \
 apt-get install -y \
	jq

RUN \
 echo "**** install radarr ****" && \
 if [ -z ${RADARR_RELEASE+x} ]; then \
	RADARR_RELEASE=$(curl -sX GET "https://api.github.com/repos/Radarr/Radarr/releases" \
	| jq -r '.[0] | .tag_name'); \
 fi && \
 radarr_url=$(curl -s https://api.github.com/repos/Radarr/Radarr/releases/tags/"${RADARR_RELEASE}" \
	|jq -r '.assets[].browser_download_url' |grep linux) && \
 mkdir -p \
	/opt/radarr && \
 curl -o \
 /tmp/radar.tar.gz -L \
	"${radarr_url}" && \
 tar ixzf \
 /tmp/radar.tar.gz -C \
	/opt/radarr --strip-components=1


# RUN cd /opt && \
# file=$( curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 ) && \
# echo Radarr File $file && \
# wget $file && \
# tar -xvzf Radarr.*.linux.tar.gz
RUN mkdir -p /var/radarr

RUN file=$( curl -s https://api.github.com/repos/Jackett/Jackett/releases | grep Binaries.Mono.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 ) && \
echo Jackett File $file && \
wget $file && \
tar -xvf Jackett* && \
mkdir /opt/jackett && \
mv Jackett/* /opt/jackett



RUN apt-get install -y libunwind8

#RUN useradd -u 9001 -U -d /var/ombi -s /bin/false ombi && usermod -G users ombi

#RUN \
# mkdir -p \
#	/opt && \
# ombi_tag=$(curl -sX GET "https://api.github.com/repos/tidusjar/Ombi/releases/latest" \
#	| awk '/tag_name/{print $4;exit}' FS='[""]') && \
# curl -o \
# /tmp/ombi-src.zip -L \
#	"https://github.com/tidusjar/Ombi/releases/download/${ombi_tag}/Ombi.zip" && \
# unzip -q /tmp/ombi-src.zip -d /tmp && \
# mv /tmp/Release /opt/ombi
#RUN mkdir -p /var/ombi

#RUN echo 'net.core.rmem_max = 16777216' >> /etc/sysctl.conf
#RUN echo 'net.core.wmem_max = 4194304' >> /etc/sysctl.conf
COPY config/default/* /etc/default/

RUN mkdir /etc/service/transmission
ADD service/transmission.sh /etc/service/transmission/run
RUN chmod +x /etc/service/transmission/run

RUN mkdir /etc/service/couchpotato
ADD service/couchpotato.sh /etc/service/couchpotato/run
RUN chmod +x /etc/service/couchpotato/run

RUN mkdir /etc/service/sonarr
ADD service/sonarr.sh /etc/service/sonarr/run
RUN chmod +x /etc/service/sonarr/run

RUN mkdir /etc/service/radarr
ADD service/radarr.sh /etc/service/radarr/run
RUN chmod +x /etc/service/radarr/run

RUN mkdir /etc/service/jackett
ADD service/jackett.sh /etc/service/jackett/run
RUN chmod +x /etc/service/jackett/run


#RUN mkdir /etc/service/ombi
#ADD service/ombi.sh /etc/service/ombi/run
#RUN chmod +x /etc/service/ombi/run

RUN mkdir /etc/service/logs
ADD service/logs.sh /etc/service/logs/run
RUN chmod +x /etc/service/logs/run

# Clean up APT when done.

RUN \
 echo "**** clean up ****" && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
    /var/tmp/*