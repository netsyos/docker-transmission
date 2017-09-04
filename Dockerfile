FROM netsyos/base:latest

RUN apt-get -y install transmission-deamon

RUN mkdir /etc/service/transmission
ADD service/transmission.sh /etc/service/transmission/run
RUN chmod +x /etc/service/transmission/run

RUN mkdir /etc/service/logs
ADD service/logs.sh /etc/service/logs/run
RUN chmod +x /etc/service/logs/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*