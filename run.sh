#!/bin/sh

IMAGE_NAME=$1
shift

CURDIR=$(pwd)
IMAGEDIR=$(pwd)/${IMAGE_NAME}

if [ "${IMAGE_NAME}" = "" ]; then
    echo "Usage: dockertool/run.sh <IMAGE_NAME>"
    exit 1
fi

if [ ! -e ${CURDIR}/${IMAGEDIR} ]; then
    echo "directory '${CURDIR}/${IMAGE_NAME}' is not exists."
    exit 1
fi

if [ ! -f ${CURDIR}/setenv_${IMAGE_NAME} ]; then
    echo "missing ${CURDIR}/setenv_${IMAGE_NAME} file for environment variables"
    exit 1
fi

if [ "${AWS_ACCOUNT_ID}" = "" ]; then
    echo "missing AWS_ACCOUNT_ID"
    exit 1
fi

if [ "${AWS_REGION}" = "" ]; then
    echo "missing AWS_REGION"
    exit 1
fi

export DOCKERENV="
-e AWS_ACCESS_KEY_ID=$(    aws configure get aws_access_key_id) \
-e AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key) \
-e AWS_SESSION_TOKEN=$(    aws configure get aws_session_token) \
-e LOG_LEVEL=10 \
"

cd ${CURDIR}/${IMAGEDIR}

echo "[dockerrun] setting env..."
. ${CURDIR}/setenv_from_aws

echo "[dockerrun] running..."
docker run --rm -it \
    ${DOCKERENV} \
    -v ${CURDIR}:${IMAGEDIR} \
    -w ${IMAGEDIR} \
    ${IMAGE_NAME} "$@"