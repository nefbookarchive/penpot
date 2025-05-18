#!/usr/bin/env bash
set -x

DOCKER_CLI_EXPERIMENTAL=enabled
ORG=${XENPOT_DOCKER_NAMESPACE:-xenpotapp};
PLATFORM=${XENPOT_BUILD_PLATFORM:-linux/amd64};

IMAGE=${XENPOT_BUILD_IMAGE:-backend}
PLATFORM=${XENPOT_BUILD_PLATFORM:-linux/amd64};
VERSION=${XENPOT_BUILD_VERSION:-latest}

DOCKER_IMAGE="$ORG/$IMAGE";
OPTIONS="-t $DOCKER_IMAGE:$VERSION";

IFS=", "
read -a TAGS <<< $XENPOT_BUILD_TAGS;

for element in "${TAGS[@]}"; do
    OPTIONS="$OPTIONS -t $DOCKER_IMAGE:$element";
done

docker buildx inspect xenpot > /dev/null 2>&1;
docker run --privileged --rm tonistiigi/binfmt --install all

if [ $? -eq 1 ]; then
    docker buildx create --name=xenpot --use
    docker buildx inspect --bootstrap > /dev/null 2>&1;
else
    docker buildx use xenpot;
    docker buildx inspect --bootstrap  > /dev/null 2>&1;
fi

unset IFS;

docker buildx build --platform ${PLATFORM// /,} $OPTIONS -f Dockerfile.$IMAGE "$@" .;
