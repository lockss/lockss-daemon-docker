FROM rockylinux:9

LABEL maintainer="Daniel Vargas <dlvargas@stanford.edu>"

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

# Setup Adoptium repository (Temurin Java 8 — EL9 no longer ships java-1.8.0-openjdk)
ADD src/adoptium.repo /etc/yum.repos.d
RUN rpm --import https://packages.adoptium.net/artifactory/api/gpg/key/public

# Install java and various debugging/networking tools
RUN yum -y install lockss-daemon temurin-8-jdk \
    iproute procps bind-utils iputils nmap-ncat lsof libtirpc

# Install PostgreSQL 14 client tools (psql, pg_dump) matching the postgres:14 sidecar.
# Uses the PGDG repo; only the client package is installed (server stays out).
RUN yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm \
 && yum -qy module disable postgresql \
 && yum -y install postgresql14 \
 && yum clean all

# Install LOCKSS using rpm
RUN rpm -U http://props.lockss.org:8001/tal/lockss-daemon-latest.noarch.rpm

# Add files
ADD src/bin/start-lockss.sh /
ADD src/bin/docker-entrypoint.sh /

# Ensure the execute bit is set
RUN chmod 755 /docker-entrypoint.sh /start-lockss.sh

# Set the default entry point for the container
CMD ["/docker-entrypoint.sh"]
