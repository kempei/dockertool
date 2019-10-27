#!/bin/sh

IMAGE_NAME=$1
shift

CURDIR=$(pwd)
IMAGE_DIR=${CURDIR}/${IMAGE_NAME}

echo ${IMAGE_NAME}

if [ "${IMAGE_NAME}" = "" ]; then
    echo "Usage: dockertool/build.sh <IMAGE_NAME>"
    exit 1
fi

if [ ! -e ${IMAGE_DIR} ]; then
    echo "directory '${IMAGE_DIR}' is not exists."
    exit 1
fi

cd ${IMAGE_DIR}

echo "[dockerbuild] building..."
docker build -t ${IMAGE_NAME} .
echo "[dockerbuild] ecr login..."
$(aws ecr get-login --no-include-email --region ${AWS_REGION})
echo "[dockerbuild] ecr tagging..."
docker tag ${IMAGE_NAME}:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}:latest
echo "[dockerbuild] ecr pushing..."
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}:latest
