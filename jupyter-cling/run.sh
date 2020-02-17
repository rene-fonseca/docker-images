#!/bin/bash

docker run -it -e JUPYTER_ENABLE_LAB=1 --rm -p 8888:8888 renefonseca/jupyter-cling:latest
