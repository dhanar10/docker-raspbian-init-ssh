#!/usr/bin/env bash

timeout 1 echo > /dev/tcp/172.17.0.1/3142 \
    && echo "http://172.17.0.1:3142" \
    || echo "DIRECT"
