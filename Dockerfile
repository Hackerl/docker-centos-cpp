FROM centos:7

RUN yum install -y zip unzip make autoconf gcc gcc-c++ gettext gmp-devel mpfr-devel libmpc-devel zlib-devel curl-devel && yum clean all

RUN curl -fsSL https://github.com/Kitware/CMake/releases/download/v3.23.2/cmake-3.23.2-linux-x86_64.tar.gz | tar -xz -C /opt
RUN curl -fsSL https://github.com/git/git/archive/refs/tags/v2.20.0.tar.gz | tar -xz -C /tmp && cd /tmp/git-2.20.0 && make configure && ./configure && make -j$(nproc) && make install && rm -rf /tmp/git-2.20.0
RUN curl -fsSL https://ftp.gnu.org/gnu/gcc/gcc-10.4.0/gcc-10.4.0.tar.gz | tar -xz -C /tmp && cd /tmp/gcc-10.4.0 && ./configure --prefix=/opt/gcc-10.4.0 --enable-checking=release --enable-languages=c,c++ --disable-multilib --enable-default-pie && make -j$(nproc) && make install-strip && rm -rf /tmp/gcc-10.4.0
RUN git clone https://github.com/microsoft/vcpkg /opt/vcpkg && /opt/vcpkg/bootstrap-vcpkg.sh

ENV CC=/opt/gcc-10.4.0/bin/gcc
ENV CXX=/opt/gcc-10.4.0/bin/g++
ENV LD_LIBRARY_PATH=/opt/gcc-10.4.0/lib64:$LD_LIBRARY_PATH
ENV VCPKG_INSTALLATION_ROOT=/opt/vcpkg
ENV PATH=/opt/vcpkg:/opt/cmake-3.23.2-linux-x86_64/bin:$PATH
