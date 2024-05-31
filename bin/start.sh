#!/bin/sh
docker run \
    -it \
    --rm \
    -n lockss \
    -p 9729:9729 \
    -p 8081:8081 \
    -v /etc/lockss/config.dat:/etc/lockss/config.dat \
    -v /lockss:/lockss \
    -v /var/log/lockss:/var/log/lockss \
    -v /etc/localtime:/etc/localtime:ro \
    lockss/lockss-daemon
