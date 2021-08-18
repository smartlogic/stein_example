#!/bin/bash

set -e

if [[ $(pwd) == *"/deploy" ]]; then
  cd ..
fi

rm -f deploy/tmp/REVISION deploy/tmp/stein_example.tar.gz

GIT_SHA=$(git rev-parse main)

rm -rf tmp/build
mkdir -p tmp/build
git archive --format=tar main | tar x -C tmp/build/
cd tmp/build

export DOCKER_BUILDKIT=0
docker build --build-arg GIT_SHA=${GIT_SHA} -f Dockerfile.releaser -t stein_example:releaser .

mkdir -p ../../deploy/tmp

DOCKER_UUID=$(uuidgen)
docker run --name stein_example_releaser_${DOCKER_UUID} stein_example:releaser /bin/true
docker cp stein_example_releaser_${DOCKER_UUID}:/opt/stein_example.tar.gz ../../deploy/tmp
docker cp stein_example_releaser_${DOCKER_UUID}:/opt/REVISION ../../deploy/tmp
docker rm stein_example_releaser_${DOCKER_UUID}
