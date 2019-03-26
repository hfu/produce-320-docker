FROM ubuntu:18.04

# common utilities
RUN apt-get update && apt-get -y upgrade \
  && apt-get -y install apt-transport-https ca-certificates \
  && apt-get -y install build-essential libsqlite3-dev zlib1g-dev \
  && apt-get -y install curl nodejs npm git
RUN npm install n -g && n lts && apt purge -y nodejs npm
RUN mkdir -p /tmp/workdir

# Tippecanoe
WORKDIR /tmp/workdir
RUN git clone https://github.com/mapbox/tippecanoe
WORKDIR /tmp/workdir/tippecanoe
RUN make -j2 && make install

# Osmium Tool
WORKDIR /tmp/workdir
RUN apt-get -y install libboost-program-options-dev libbz2-dev zlib1g-dev \
  && apt-get -y install libexpat1-dev cmake pandoc
RUN git clone https://github.com/mapbox/protozero
RUN git clone https://github.com/osmcode/libosmium
RUN git clone https://github.com/osmcode/osmium-tool
RUN mkdir -p /tmp/workdir/osmium-tool/build
WORKDIR /tmp/workdir/osmium-tool/build
RUN cmake ..
RUN make
RUN ln -s /tmp/workdir/osmium-tool/build/osmium /usr/local/bin/osmium

# produce-320
WORKDIR /tmp/workdir
RUN git clone https://github.com/un-vector-tile-toolkit/produce-320
WORKDIR /tmp/workdir/produce-320
RUN npm install
COPY ./default.hjson /tmp/workdir/produce-320/config 
WORKDIR /tmp/workdir/produce-320

