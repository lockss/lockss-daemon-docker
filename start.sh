#!/bin/sh
docker run \
    -it \
    --rm \
    -v `pwd`/cache:/cache \
    -v `pwd`/log/lockss:/var/log/lockss \
    -v `pwd`/lockss:/opt/lockss \
    -p 9729:9729 \
    -p 8080-8086:8080-8086 \
    lockss/lockss-daemon
