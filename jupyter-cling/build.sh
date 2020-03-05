#!/bin/bash

echo Building image for Jupyter with xeus/cling and BASE framework

# --no-cache
docker build --build-arg VCS_REF=`git rev-parse --short HEAD` \
  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
  --build-arg VERSION=1.0 \
  -t renefonseca/jupyter-cling:latest .
