FROM netsyos/nginx:latest

RUN apt-get update
RUN apt-get -y install transmission-daemon

#RUN echo 'net.core.rmem_max = 16777216' >> /etc/sysctl.conf
#RUN echo 'net.core.wmem_max = 4194304' >> /etc/sysctl.conf
COPY config/default/* /etc/default/

RUN mkdir /etc/service/transmission
ADD service/transmission.sh /etc/service/transmission/run
RUN chmod +x /etc/service/transmission/run
#
#RUN mkdir /etc/service/logs
#ADD service/logs.sh /etc/service/logs/run
#RUN chmod +x /etc/service/logs/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
