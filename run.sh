#!/bin/bash

LOCAL_IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
echo Expecting an X server running at $LOCAL_IP

docker build . -t casperjs
docker run -d \
    -v $(pwd):/test \
    --name casperjs \
    casperjs \
    tail -f /dev/null
docker cp test.js casperjs:/test.js
docker exec casperjs \
    casperjs test --engine=slimerjs --xunit=/results.xml /test.js
docker cp casperjs:/results.xml results.xml
docker rm -f casperjs
