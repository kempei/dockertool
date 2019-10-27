#!/bin/sh

IMAGE_NAME=$1
shift

CURDIR=$(pwd)
cd `dirname $0`

IMAGEDIR=$(pwd)/${IMAGE_NAME}

if [ "${IMAGE_NAME}" = "" ]; then
    echo "Usage: dockertool/build.sh <IMAGE_NAME>"
    exit 1
fi

if [ ! -e ${IMAGEDIR} ]; then
    echo "directory '${CURDIR}/${IMAGE_NAME}' is not exists."
    exit 1
fi

cd ${IMAGEDIR}

echo "[dockerbuild] building..."
docker build -t ${IMAGE_NAME} .
echo "[dockerbuild] ecr login..."
$(aws ecr get-login --no-include-email --region ${AWS_REGION})
echo "[dockerbuild] ecr tagging..."
docker tag ${IMAGE_NAME}:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}:latest
echo "[dockerbuild] ecr pushing..."
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}:latest