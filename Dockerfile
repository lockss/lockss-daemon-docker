FROM rockylinux:9

MAINTAINER "Daniel Vargas" <dlvargas@stanford.edu>

ARG USER_ID=504
ARG GROUP_ID=504

RUN groupadd -g ${GROUP_ID} lockss &&\
    useradd -l -u ${USER_ID} -g lockss lockss &&\
    install -d -m 0755 -o lockss -g lockss /home/lockss

# LOCKSS LCAP and Administrative Web UI ports
EXPOSE 9729/tcp
EXPOSE 9749/tcp
EXPOSE 8081/tcp

# Setup LOCKSS RPM repository
ADD src/lockss.repo /etc/yum.repos.d
RUN rpm --import https://assets.lockss.org/rpm/LOCKSS-GPG-RPM-KEY
RUN yum -y -q update && yum clean all

# Install java and various debugging/networking tools
RUN yum -y install lockss-daemon java-1.8.0-openjdk-headless.x86_64 \
    iproute procps bind-utils iputils nmap-ncat lsof libtirpc

# Install LOCKSS using rpm
RUN rpm -i http://props.lockss.org:8001/tal/lockss-daemon-latest.noarch.rpm

# Add files
ADD src/bin/start-lockss.sh /
ADD src/bin/docker-entrypoint.sh /

# Ensure the execute bit is set
RUN chmod 755 /docker-entrypoint.sh /start-lockss.sh

# Set the default entry point for the container
CMD ["/docker-entrypoint.sh"]
