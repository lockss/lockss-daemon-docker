FROM rockylinux:9

MAINTAINER "Daniel Vargas" <dlvargas@stanford.edu>

ARG USER_ID=503
ARG GROUP_ID=503

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

# Install LOCKSS via RPM
RUN yum -y install lockss-daemon java-1.8.0-openjdk-headless.x86_64 iproute procps

# Grant lockss ownership of daemon
RUN chown lockss:lockss /etc/init.d/lockss /etc/logrotate.d/lockss
RUN chown --recursive lockss:lockss /etc/lockss /usr/share/lockss

# Add files
ADD src/bin/start-lockss.sh /
ADD src/bin/docker-entrypoint.sh /

# Ensure the execute bit is set
RUN chmod 755 /docker-entrypoint.sh /start-lockss.sh

# Set the default entry point for the container
CMD ["/docker-entrypoint.sh"]

USER lockss