FROM netsyos/base:latest

RUN apt-get -y install transmission-daemon

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
