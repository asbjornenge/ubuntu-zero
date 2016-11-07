#!/bin/bash
VERSION=$1
IMAGE=asbjornenge/ubuntu-zero:16.04
docker build -t $IMAGE-$VERSION .
echo "DONE $IMAGE-$VERSION"
#docker push $IMAGE-$VERSION
