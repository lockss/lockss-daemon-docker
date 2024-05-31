## Introduction
This is project is the containerization of the 1.x LOCKSS daemon.

## Usage
1. Clone the `lockss-daemon-docker` repository:

    ```
    git clone https://github.com/lockss/lockss-daemon-docker
    ```

2. Build the `lockss/lockss-daemon` Docker image using the provided script:

    ```
    bin/build-image.sh
    ```

3. Start the container using Docker Compose:

    ```
    docker compose up -d
    ```

## Configuration
There are three files that control the configuration of the LOCKSS daemon:

1. `/etc/lockss/config.dat`: The LOCKSS daemon configuration: This file 
   should already exist at this location, if you had a previous installation
   of the LOCKSS daemon. If this is the first time installing LOCKSS on this
   host, use `bin/hostconfig` and follow its prompts to generate a `config.dat`.

2. `compose.yaml`: The Docker Compose file defining the `lockss` service: This
   file makes many assumptions about the running environment, such as ports
   and filesystems mapped into the container. See it for details.

3. `lockss.env`: Environment variables mapped into the LOCKSS container: Not
   supported yet.
