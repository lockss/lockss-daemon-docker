FROM centos:latest

MAINTAINER "Daniel Vargas" <dlvargas@stanford.edu>

RUN yum -y -q update && yum clean all

# Add files to the container
ADD src/init.sh /
ADD src/start-lockss.sh /usr/local/bin
ADD src/lockss.repo /etc/yum.repos.d
ADD src/motd /etc/motd

# Change the execute bit on scripts
RUN chmod 755 /init.sh /usr/local/bin/start-lockss.sh

# Import the LOCKSS GPG key
RUN rpm --import http://www.lockss.org/LOCKSS-GPG-RPM-KEY
RUN yum -y -q install lockss-daemon java-1.7.0-openjdk

# Add LOCKSS configuration files
RUN ln -s /opt/lockss/config.dat /etc/lockss/config.dat

# LOCKSS LCAP and Administrative WebUI ports
EXPOSE 9729 8080-8086

# Set the default command to run 
CMD ["/init.sh"]
