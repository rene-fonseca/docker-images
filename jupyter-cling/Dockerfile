FROM jupyter/minimal-notebook as build

USER root

RUN apt-get -y update
RUN apt-get -y install git cmake make gcc g++
RUN apt-get -y install zlib1g-dev libbz2-dev libxml2-dev libxslt-dev libssl-dev libcurl4-openssl-dev

RUN mkdir /base && \
  cd /base && \
  git clone https://renefonseca@dev.azure.com/renefonseca/base/_git/base && \
  cd base && \
  mkdir build && \
  cd build && \
  cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/base/install && \
  cmake --build . --config Release --target install -- -j 6



FROM jupyter/minimal-notebook

# TAG: add labels

USER root

RUN apt-get -y update && \
  apt-get -y install zlib1g libbz2-1.0 libxml2 libxslt1.1 libssl1.1 libcurl4 && \
  rm -rf /var/lib/apt/lists/*

COPY --from=build /base/install/include/ /usr/include/
COPY --from=build /base/install/lib/release/libbase.so* /usr/lib/
COPY --from=build /base/base/testsuite/*.cpp /usr/include/base/testsuite/

USER $NB_UID

RUN conda install --quiet --yes xeus-cling -c conda-forge && \
  conda clean -ay && \
  ln -s /usr/include/base /opt/conda/include/base && \
  fix-permissions $CONDA_DIR && \
  fix-permissions /home/$NB_USER

ENV CLICOLOR=1
