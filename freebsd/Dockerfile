FROM ubuntu:18.04 as build

RUN apt-get -y update \
  && apt-get -y install build-essential m4 bison flex libtool automake autoconf autogen pkg-config curl xz-utils \
       libgmp-dev libmpfr-dev libmpc-dev libelf-dev

WORKDIR /tmp


# Get sysroot
RUN curl -OL 'ftp://ftp.dk.freebsd.org/pub/FreeBSD/releases/amd64/amd64/12.1-RELEASE/base.txz'
RUN mkdir base && tar -C base -xf base.txz
RUN mkdir /freebsd /freebsd/x86_64-pc-freebsd12 /freebsd/x86_64-pc-freebsd12/sysroot /freebsd/x86_64-pc-freebsd12/sysroot/usr \
  && mv base/usr/include /freebsd/x86_64-pc-freebsd12/sysroot/usr \
  && mv base/lib /freebsd/x86_64-pc-freebsd12/sysroot \
  && mv base/usr/lib /freebsd/x86_64-pc-freebsd12/sysroot/usr


# Build binutils
RUN curl -OL 'https://mirrors.dotsrc.org/gnu/binutils/binutils-2.33.1.tar.xz'
RUN tar -xf binutils-2.33.1.tar.xz
RUN cd /tmp/binutils-2.33.1 \
  && ./configure --prefix=/freebsd --with-sysroot=/freebsd/x86_64-pc-freebsd12/sysroot --enable-libssp --enable-ld --target=x86_64-pc-freebsd12 \
  && make -j 8 \
  && make install


# Build GCC
RUN curl -OL 'ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-9.2.0/gcc-9.2.0.tar.xz'
RUN tar -xf gcc-9.2.0.tar.xz

#RUN curl -OL 'ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-8.3.0/gcc-8.3.0.tar.xz'
#RUN tar -xf gcc-8.3.0.tar.xz

#RUN curl -OL 'ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-7.5.0/gcc-7.5.0.tar.xz'
#RUN tar -xf gcc-7.5.0.tar.xz

# see https://gcc.gnu.org/install/configure.html
RUN cd /tmp/gcc-9.2.0 \
  && mkdir -p build \
  && cd build \
  && ../configure \
       --with-sysroot=/freebsd/x86_64-pc-freebsd12/sysroot \
       --without-headers \
       --with-gnu-as \
       --with-gnu-ld \
       --disable-nls \
       --enable-languages=c,c++ \
       --enable-libssp \
       --enable-ld \
       --disable-libitm \
       --disable-libquadmath \
       --target=x86_64-pc-freebsd12 \
       --prefix=/freebsd \
       --disable-libgomp \
  && make -j 8 \
  && make install


# Now build the actual image
FROM ubuntu:18.04

LABEL version="1.0"
LABEL description="FreeBSD 12.1 GCC cross compiler tool chain."

COPY --from=build /freebsd /freebsd

ENV LD_LIBRARY_PATH /freebsd/lib
ENV PATH /freebsd/bin/:$PATH
ENV CC x86_64-pc-freebsd12-gcc
ENV CPP x86_64-pc-freebsd12-cpp
ENV AS x86_64-pc-freebsd12-as
ENV LD x86_64-pc-freebsd12-ld
ENV AR x86_64-pc-freebsd12-ar
ENV RANLIB x86_64-pc-freebsd12-ranlib
ENV HOST x86_64-pc-freebsd12
