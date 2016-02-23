## Introduction
This is an experimental project to run the LOCKSS daemon with a Docker container.

## Usage
1. Clone the `lockss-daemon-docker` repository:

    ```
    git clone https://github.com/lockss/lockss-daemon-docker
    ```

2. Build the lockss/lockss-daemon Docker image using the provided script:

    ```
    ./build.sh
    ```

3. Run an instance of the image in a Docker container using the provided script:

    ```
    ./start.sh
    ```

## Configuration
* `lockss/config.dat`: A an example LOCKSS configuration file is provided to allow
the LOCKSS daemon to run locally. The default username and password is `lockss` and
`lockss`, respectively. This and other parameters can be changed, either by editing
the file directly or by running `hostconfig` within the container.

* `start.sh`: This file is responsible for starting the Docker container and passing
along network and storage configuration: The `cache` and `log/lockss` directories 
are linked to `/cache` and `/var/log/lockss` within the container, respectively. If 
the path to these directories change, the mapping in `start.sh` should be updated.
Additional paths can be added, but need to be reflected in bot `start.sh` and 
`lockss/config.dat`.

    This file also contains mapping from the Docker host to ports exposed by the 
container. If there are port conflicts, ports on the host-side can be remapped by
editing `start.sh`.
