# GCC Cross Compiler Tool Chain for FreeBSD

This image provides a GCC cross compiler for FreeBSD.

The image is hosted at https://hub.docker.com/repository/docker/renefonseca/freebsd12. Use tag *latest* to get the latest release. Or use the FreeBSD release as tag.

```
docker pull renefonseca/freebsd12:12.1
```

## Usage

If you use *cmake* you can build your project with a command like below:

```
mkir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=install -DCMAKE_CXX_COMPILER=/freebsd/bin/x86_64-pc-freebsd12-g++ -DCMAKE_C_COMPILER=/freebsd/bin/x86_64-pc-freebsd12-gcc
cmake --build . --target install
```

## Azure DevOps Pipeline

Azure DevOps job snippet:

```
resources:
  containers:
  - container: freebsd12
    image: renefonseca/base-freebsd12:12.1

- job: freebsd_x64
  pool:
    vmImage: 'ubuntu-18.04'
  container: freebsd12
  steps:
  - script: cmake $(Build.SourcesDirectory) -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=install -DCMAKE_CXX_COMPILER=/freebsd/bin/x86_64-pc-freebsd12-g++ -DCMAKE_C_COMPILER=/freebsd/bin/x86_64-pc-freebsd12-gcc
    displayName: 'Config'
    workingDirectory: $(Build.BinariesDirectory)

  - script: cmake --build . --config Debug --target install -- -j 4
    displayName: 'Build'
    workingDirectory: $(Build.BinariesDirectory)
```
