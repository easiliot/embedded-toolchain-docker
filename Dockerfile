# [Choice] Debian / Ubuntu version: debian-10, debian-9, ubuntu-20.04, ubuntu-18.04
ARG VARIANT=ubuntu-20.04
FROM mcr.microsoft.com/vscode/devcontainers/cpp:0-${VARIANT}

# Install any needed packages specified in requirements.txt
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update && \
    apt-get upgrade -y -q && \
    apt-get install -y -q \
      clang-tidy \
      clang-format \
      openocd \
      ncurses-dev \
      libudev-dev \
      python3 && \
    apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
    
# Install the last GCC from ARM
ENV ARM_GCC_VERSION 10-2020-q4-major
ENV ARM_GCC_PATH 10-2020q4
ENV ARCH x86_64
ENV OS linux

ENV ARM_GCC_INSTALL_FOLDER /arm_gcc/gcc-arm-none-eabi-${ARM_GCC_VERSION}
ENV ARM_GCC_FILENAME gcc-arm-none-eabi-${ARM_GCC_VERSION}-${ARCH}-${OS}.tar.bz2
ENV ARM_GCC_BASE_URL https://developer.arm.com/-/media/Files/downloads/gnu-rm
ENV ARM_GCC_URL ${ARM_GCC_BASE_URL}/${ARM_GCC_PATH}/${ARM_GCC_FILENAME}

RUN mkdir /arm_gcc && \
    cd /arm_gcc && \
    wget ${ARM_GCC_URL} -O ${ARM_GCC_FILENAME} && \
    tar xjf ${ARM_GCC_FILENAME} && \
    rm ${ARM_GCC_FILENAME}

ENV PATH="${ARM_GCC_INSTALL_FOLDER}/bin:${PATH}"

# make some useful symlinks that are expected to exist
RUN cd /usr/bin                                                                          && \
    ln -s idle3 idle                                                                     && \
    ln -s pydoc3 pydoc                                                                   && \
    ln -s python3 python                                                                 && \
    ln -s python3-config python-config                                                   && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-addr2line        && \            
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-ar               && \            
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-as               && \            
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-c++              && \            
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-c++filt          && \            
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-cpp              && \            
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-elfedit          && \            
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-g++              && \            
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gcc              && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gcc-10.2.1       && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gcc-ar           && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gcc-nm           && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gcc-ranlib       && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gcov             && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gcov-dump        && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gcov-tool        && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gdb              && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gdb-add-index    && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gdb-add-index-py && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gdb-py           && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gprof            && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-ld               && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-ld.bfd           && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-lto-dump         && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-nm               && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-objcopy          && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-objdump          && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-ranlib           && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-readelf          && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-size             && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-strings          && \
    ln -s /arm_gcc/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-strip

# This is required to get arm-none-eabi-gdb working
RUN  cd /usr/lib/x86_64-linux-gnu && \
    ln -s libncurses.so.6.2 libncurses.so.5 && \
    ln -s libtinfo.so.6.2 libtinfo.so.5
