FROM netsyos/nginx:latest

RUN apt-get update
RUN apt-get -y install transmission-daemon
RUN apt-get -y install python git
RUN apt-get -y install libcurl4-openssl-dev bzip2 mono-devel libmono-cil-dev mediainfo sqlite3


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


#RUN wget $( curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 )
#RUN tar -xvzf Radarr.develop.*.linux.tar.gz
#RUN mkdir -p /var/radarr


#jackettver=$(wget -q https://github.com/Jackett/Jackett/releases/latest -O - | grep -E \/tag\/ | awk -F "[><]" '{print $3}')
#wget -q https://github.com/Jackett/Jackett/releases/download/$jackettver/Jackett.Binaries.Mono.tar.gz
#tar -xvf Jackett*
#sudo mkdir /opt/jackett
#sudo mv Jackett/* /opt/jackett
#mono /opt/jackett/JackettConsole.exe
#mono --debug /opt/jackett/JackettConsole.exe --NoRestart

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

RUN mkdir /etc/service/logs
ADD service/logs.sh /etc/service/logs/run
RUN chmod +x /etc/service/logs/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
