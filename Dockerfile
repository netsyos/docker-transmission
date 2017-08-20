FROM netsyos/docker-base:latest

RUN apt-get -y install transmission-deamon

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*