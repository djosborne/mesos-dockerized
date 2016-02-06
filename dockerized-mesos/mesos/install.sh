#!/usr/bin/env bash
set -e
source /build/mesos/buildconfig
set -x

apt-get update -qq

# Install temporary packages required for installing Mesos.
apt-get -qy install software-properties-common # (for add-apt-repository)
add-apt-repository ppa:george-edison55/cmake-3.x
apt-get update -qq
apt-cache policy cmake
apt-get -qy install \
  build-essential                         \
  autoconf                                \
  automake                                \
  cmake=3.2.2-2ubuntu2~ubuntu14.04.1~ppa1 \
  ca-certificates                         \
  gdb                                     \
  wget                                    \
  git-core                                \
  protobuf-compiler                       \
  make                                    \
  libpython-dev                           \
  python-dev                              \
  python-setuptools                       \
  heimdal-clients                         \
  unzip                                   \
  python                           \
  python2.7                        \
  python-protobuf                  \
  libsasl2-modules-gssapi-heimdal  \
  libcurl4-nss-dev                 \
  libtool                          \
  libapr1-dev                      \
  libsvn-dev                       \
  libsasl2-dev                     \
  libgoogle-glog-dev               \
  libboost-dev                     \
  libprotobuf-dev                  \
  wget                             \
  libevent-dev                     \
  libevent-openssl-2.0             \
  libevent-pthreads-2.0            \
  openssl                          \
  --no-install-recommends


# Install the picojson headers
wget https://raw.githubusercontent.com/kazuho/picojson/v1.3.0/picojson.h -O /usr/local/include/picojson.h

# Prepare to build Mesos
mkdir -p /mesos
mkdir -p /tmp
mkdir -p /usr/share/java/
wget http://search.maven.org/remotecontent?filepath=com/google/protobuf/protobuf-java/2.5.0/protobuf-java-2.5.0.jar -O protobuf.jar
mv protobuf.jar /usr/share/java/

# Clone Mesos (master branch)
git clone https://github.com/apache/mesos.git /mesos
cd /mesos
git checkout $MESOS_BRANCH
git log -n 1

# Bootstrap
./bootstrap

# Configure
mkdir build
cd build
../configure --disable-java --disable-optimize --without-included-zookeeper --with-glog=/usr/local --with-protobuf=/usr --with-boost=/usr/local --enable-libevent --enable-ssl

# Build Mesos
make -j 2 install

# Install python eggs (needed for sample framework)
easy_install /mesos/build/src/python/dist/mesos.interface-*.egg
easy_install /mesos/build/src/python/dist/mesos.native-*.egg

# Copy start up scripts
cp /mesos/build/bin/*.sh /root

mv /build/mesos/runagent /root
