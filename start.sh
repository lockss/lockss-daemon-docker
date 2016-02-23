#!/bin/sh
docker run \
    -itP \
    --rm \
    -v `pwd`/cache:/cache \
    -v `pwd`/log/lockss:/var/log/lockss \
    -v `pwd`/lockss:/opt/lockss \
    lockss/lockss-daemon
