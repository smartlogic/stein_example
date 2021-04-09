#!/bin/bash
set -e

rm -rf tmp/build
mkdir -p tmp/build
git archive --format=tar main | tar x -C tmp/build/
cd tmp/build

docker build -f Dockerfile.releaser -t stein_example:releaser .

DOCKER_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
docker run -ti --name stein_example_releaser_${DOCKER_UUID} stein_example:releaser /bin/true
docker cp stein_example_releaser_${DOCKER_UUID}:/opt/stein_example.tar.gz ../
docker rm stein_example_releaser_${DOCKER_UUID}
