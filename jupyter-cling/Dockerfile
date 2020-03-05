FROM jupyter/minimal-notebook as build

USER root

RUN apt-get -y update
RUN apt-get -y install git cmake make gcc g++ curl
RUN apt-get -y install zlib1g-dev libbz2-dev libxml2-dev libxslt-dev libssl-dev libcurl4-openssl-dev


# build wasmtime shared library
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/jovyan/.cargo/bin:$PATH"

RUN mkdir /wasmtime && \
  cd /wasmtime && \
  git clone --recurse-submodules https://github.com/bytecodealliance/wasmtime.git && \
  cd wasmtime && \
  git checkout && \
  git submodule update --init --recursive && \
  cargo build --release --manifest-path crates/c-api/Cargo.toml

RUN mkdir -p /install/usr/lib/ /install/usr/include/wasmtime/ && \
  cp /wasmtime/wasmtime/target/release/libwasmtime.so /install/usr/lib/ && \
  cp /wasmtime/wasmtime/crates/c-api/include/wasi.h /install/usr/include/wasmtime/ && \
  sed 's/#include <wasm.h>/#include "wasm.h"/g' /wasmtime/wasmtime/crates/c-api/include/wasmtime.h | \
    sed 's/own wasm_byte_vec_t \*error_message,/own wasm_byte_vec_t \*error_message/g' > /install/usr/include/wasmtime/wasmtime.h && \
  cp /wasmtime/wasmtime/crates/c-api/examples/wasm-c-api/include/wasm.h /install/usr/include/wasmtime/



# build base shared library
RUN mkdir /base && \
  cd /base && \
  git clone https://dev.azure.com/renefonseca/base/_git/base && \
  cd base && \
  mkdir build && \
  cd build && \
  cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/base/install \
    -DCMAKE_WASMTIME_DIR=/install/usr/ && \
  cmake --build . --config Release --target install -- -j 6

RUN cp -R /base/install/include/ /install/usr/ && \
    cp /base/install/lib/release/libbase.so* /install/usr/lib/ && \
    mkdir -p /install/usr/include/base/testsuite/ && \
    cp /base/base/testsuite/*.cpp /install/usr/include/base/testsuite/



FROM jupyter/minimal-notebook

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Jupyter xeus/cling" \
      org.label-schema.description="Jupyter with xeus/cling and BASE framework" \
      org.label-schema.url="https://github.com/rene-fonseca/docker-images" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/rene-fonseca/docker-images" \
      org.label-schema.vendor="René Fonseca" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

USER root

RUN apt-get -y update && \
  apt-get -y install zlib1g libbz2-1.0 libxml2 libxslt1.1 libssl1.1 libcurl4 && \
  rm -rf /var/lib/apt/lists/*

COPY --from=build /install/ /

USER $NB_UID

RUN conda install --quiet --yes xeus-cling -c conda-forge && \
  conda clean -ay && \
  ln -s /usr/include/wasmtime /opt/conda/include/wasmtime && \
  ln -s /usr/include/base /opt/conda/include/base && \
  fix-permissions $CONDA_DIR && \
  fix-permissions /home/$NB_USER

ENV CLICOLOR=1
