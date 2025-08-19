FROM rockylinux:9

LABEL org.opencontainers.image.authors="lockss-support@lockss.org"

# Linux user "lockss" - should match UID and GID on Docker host for "lockss"
ARG USER_ID=<configure>
ARG GROUP_ID=<configure>

# Set up "lockss" user
RUN groupadd -g ${GROUP_ID} lockss &&\
    useradd -l -u ${USER_ID} -g lockss lockss &&\
    install -d -m 0755 -o lockss -g lockss /home/lockss

# LOCKSS LCAP and Administrative Web UI ports
EXPOSE 9729/tcp
EXPOSE 8081/tcp

# Setup LOCKSS RPM repository
ADD src/lockss.repo /etc/yum.repos.d
RUN rpm --import https://assets.lockss.org/rpm/LOCKSS-GPG-RPM-KEY
RUN yum -y -q update && yum clean all

# Install LOCKSS and supporting software via RPM
#   lockss-daemon: LOCKSS 1.0 Daemon
#   java-1-8.0.openjdk-headless: Java 8 Runtime
#   iproute: Networking tools
#   procps: Process management tools
#   cronie: cron daemon
#   logrotate: logrotate daemon
#   initscripts: SYSV startup script support
#   bind-utils: nslookup for network diagnostics
#   iputils:  ping for network diagnostics
#   nmap-ncat: "nc" for network diagnostics
RUN yum -y install lockss-daemon java-1.8.0-openjdk-headless iproute \
    procps cronie logrotate initscripts bind-utils iputils nmap-ncat

# Add files
#   docker-entrypoint.sh: Container start script
#   start-lockss.sh: LOCKSS start script
#   stop-lockss.sh: LOCKSS stop script
#   root:  root's crontab that invokes logrotate daily
ADD src/bin/docker-entrypoint.sh /
ADD src/bin/start-lockss.sh /
ADD src/bin/stop-lockss.sh /
ADD src/crontab/root /var/spool/cron/root
RUN chmod 600 /var/spool/cron/root

# Ensure the execute bit is set
RUN chmod 755 /docker-entrypoint.sh /start-lockss.sh /stop-lockss.sh

# Set the default entry point for the container
ENTRYPOINT ["/docker-entrypoint.sh"]
