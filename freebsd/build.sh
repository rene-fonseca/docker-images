#!/bin/bash

echo Building image for FreeBSD cross compiler

# --no-cache
docker build -t renefonseca/freebsd12:12.1 -t renefonseca/freebsd12:latest .
