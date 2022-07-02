FROM centos:6.10

ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

RUN echo '6.10' > /etc/yum/vars/releasever && \
    sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://mirror.centos.org/centos/|baseurl=https://vault.centos.org/|g' \
    -i /etc/yum.repos.d/CentOS-*.repo

RUN yum install -y m4 git gcc gcc-c++ && yum clean all

RUN curl -fsSL https://github.com/Kitware/CMake/releases/download/v3.23.2/cmake-3.23.2-linux-x86_64.tar.gz | tar -xz -C /opt
RUN curl -fsSL https://ftp.gnu.org/gnu/gmp/gmp-4.3.2.tar.gz | tar -xz -C /tmp && cd /tmp/gmp-4.3.2 && ./configure && make -j$(nproc) && make install && rm -rf /tmp/gmp-4.3.2
RUN curl -fsSL https://ftp.gnu.org/gnu/mpfr/mpfr-3.1.2.tar.gz | tar -xz -C /tmp && cd /tmp/mpfr-3.1.2 && ./configure && make -j$(nproc) && make install && rm -rf /tmp/mpfr-3.1.2
RUN curl -fsSL https://ftp.gnu.org/gnu/mpc/mpc-1.0.1.tar.gz | tar -xz -C /tmp && cd /tmp/mpc-1.0.1 && ./configure && make -j$(nproc) && make install && rm -rf /tmp/mpc-1.0.1
RUN curl -fsSL https://ftp.gnu.org/gnu/gcc/gcc-10.4.0/gcc-10.4.0.tar.gz | tar -xz -C /tmp && cd /tmp/gcc-10.4.0 && ./configure --prefix=/opt/gcc-10.4.0 --enable-checking=release --enable-languages=c,c++ --disable-multilib --enable-default-pie && make -j$(nproc) && make install-strip && rm -rf /tmp/gcc-10.4.0

ENV CC=/opt/gcc-10.4.0/bin/gcc
ENV CXX=/opt/gcc-10.4.0/bin/g++
ENV PATH=/opt/cmake-3.23.2-linux-x86_64/bin:$PATH
