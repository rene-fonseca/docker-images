# Jupyter with xeus/cling and BASE framework

This image Jupyter with xeus/cling and BASE framework.

The image is hosted at https://hub.docker.com/repository/docker/renefonseca/jupyter-cling. Use tag *latest* to get the latest release.

```
docker pull renefonseca/jupyter-cling:latest
```

## Usage

Start Jupyter:
```shell
docker run -it -e JUPYTER_ENABLE_LAB=1 --rm -p 8888:8888 jupyter-cling:latest
```

Start shell:
```shell
docker run -it --rm -p 8888:8888 jupyter-cling:latest start.sh bash
```
