FROM debian:9

# Copy bootstrap File
COPY bootstrap-salt.sh /bootstrap-salt.sh

# Execute bootstrap file
RUN sh /bootstrap-salt.sh -M -N -X

# CLEANUP
RUN apt-get autoclean --yes \
  && rm -rf /var/lib/apt/lists/*

# Copy entry point and make it executable 
COPY entry-point.sh /entry-point.sh
RUN chmod +x /entry-point.sh

ENTRYPOINT ["/entry-point.sh"]
