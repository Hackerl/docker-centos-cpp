FROM centos:6.10

ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

ADD https://ftp.gnu.org/gnu/gmp/gmp-4.3.2.tar.gz /tmp/gmp-4.3.2.tar.gz
ADD https://ftp.gnu.org/gnu/mpfr/mpfr-3.1.2.tar.gz /tmp/mpfr-3.1.2.tar.gz
ADD https://ftp.gnu.org/gnu/mpc/mpc-1.0.1.tar.gz /tmp/mpc-1.0.1.tar.gz
ADD https://ftp.gnu.org/gnu/gcc/gcc-10.2.0/gcc-10.2.0.tar.gz /tmp/gcc-10.2.0.tar.gz
ADD https://github.com/Kitware/CMake/releases/download/v3.23.2/cmake-3.23.2-linux-x86_64.tar.gz /tmp/cmake-3.23.2-linux-x86_64.tar.gz

RUN echo '6.10' > /etc/yum/vars/releasever
RUN sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://mirror.centos.org/centos/|baseurl=https://vault.centos.org/|g' \
    -i /etc/yum.repos.d/CentOS-*.repo

RUN yum install -y m4 git gcc gcc-c++

RUN tar -xzf /tmp/gmp-4.3.2.tar.gz -C /tmp
RUN cd /tmp/gmp-4.3.2 && ./configure && make -j$(nproc) && make install

RUN tar -xzf /tmp/mpfr-3.1.2.tar.gz -C /tmp
RUN cd /tmp/mpfr-3.1.2 && ./configure && make -j$(nproc) && make install

RUN tar -xzf /tmp/mpc-1.0.1.tar.gz -C /tmp
RUN cd /tmp/mpc-1.0.1 && ./configure && make -j$(nproc) && make install

RUN tar -xzf /tmp/gcc-10.2.0.tar.gz -C /tmp
RUN cd /tmp/gcc-10.2.0 && ./configure --prefix=/opt/gcc-10.2.0 --enable-checking=release --enable-languages=c,c++ --disable-multilib --enable-default-pie && make -j$(nproc) && make install-strip

RUN tar -xzf /tmp/cmake-3.23.2-linux-x86_64.tar.gz -C /opt
RUN rm -rf /tmp/gmp-* /tmp/mpfr-* /tmp/mpc-* /tmp/gcc-* /tmp/cmake-*

ENV CC=/opt/gcc-10.2.0/bin/gcc
ENV CXX=/opt/gcc-10.2.0/bin/g++
ENV PATH=/opt/cmake-3.23.2-linux-x86_64/bin:$PATH
