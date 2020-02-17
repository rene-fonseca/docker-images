#!/bin/bash

echo Building image for Jupyter with xeus/cling and BASE framework

# --no-cache
docker build -t renefonseca/jupyter-cling:latest .
