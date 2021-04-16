#!/bin/bash

set -e

if [[ $(pwd) == *"/deploy" ]]; then
  cd ..
fi

rm -rf tmp/build
mkdir -p tmp/build
git archive --format=tar main | tar x -C tmp/build/
cd tmp/build

export DOCKER_BUILDKIT=0
docker build -f Dockerfile.releaser -t stein_example:releaser .

DOCKER_UUID=$(uuidgen)
docker run --name stein_example_releaser_${DOCKER_UUID} stein_example:releaser /bin/true
docker cp stein_example_releaser_${DOCKER_UUID}:/opt/stein_example.tar.gz ../../deploy/tmp
docker rm stein_example_releaser_${DOCKER_UUID}
