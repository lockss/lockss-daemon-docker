## Introduction
This is a template for the containerization of the 1.x LOCKSS daemon.  The
example below is for an Ubuntu 22.04 Docker host, it can be extrapolated to
other Linux Docker hosts.  It presumes that Docker has been deployed on the
Docker host.


## Configure Docker Host
The Docker host is prepared with a lockss user ID, a LOCKSS configuration
file in /etc/lockss, a set of one or more LOCKSS storage area directories, and
a LOCKSS log directory.

1. Create lockss userid

```
useradd -r -m -d /opt/app/lockss -s /bin/bash lockss

usermod -a -G docker lockss
usermod -a -G users lockss
```

2. Make directory /etc/lockss and install config.dat.  If this is your first
time installing LOCKSS, seek help from lockss-support@lockss.org by email.

```
mkdir /etc/lockss
chmod 755 /etc/lockss

install /etc/lockss/config.dat
chmod 644 /etc/lockss/config.dat
```

3. Make the storage area directory(s).  For this example, we make one:

```
mkdir -p /cache0/gamma
chown lockss:lockss /cache0/gamma
```

4. Make the LOCKSS daemon log directory.

```
mkdir /var/log/lockss
chown lockss:lockss /var/log/lockss
```

## Container Setup
1. Clone the `lockss-daemon-docker` repository:

    ```
    git clone https://github.com/lockss/lockss-daemon-docker

    git checkout user-template
    ```

2. Edit Dockerfile

   - set USER_ID to the UID of the lockss user on the Docker host
   - set GROUP_ID to the GID of the lockss user on the Docker host

3. Edit compose.yaml

   - set hostname to the value of LOCKSS_HOSTNAME in /etc/lockss/config.dat
   - set the storage area directory(s)
   
4. Edit lockss.env

   - set UID to the UID of the lockss user on the Docker host
   - set GID to the GID of the lockss user on the Docker host

5. Build the `lockss/lockss-daemon` Docker image using the provided script:

    ```
    bin/build-image.sh
    ```

6. Start the container using Docker Compose:

    ```
    docker compose up -d
    ```

