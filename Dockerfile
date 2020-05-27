FROM ubuntu:bionic

ARG TARGETPLATFORM
ENV TARGETPLATFORM "$TARGETPLATFORM"

RUN apt-get update && apt-get install -y curl

RUN set -ex; \
  if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
    curl -L https://airspy.com/downloads/spyserver-linux-x64.tgz | tar xvz; \
  elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then \
    curl -L https://airspy.com/downloads/spyserver-arm32.tgz | tar xvz;\
  fi;

RUN mv spyserver spyserver_ping /usr/bin && \
    mkdir -p /etc/spyserver && \
    mv spyserver.config /etc/spyserver

RUN apt-get install -y git build-essential cmake libusb-1.0-0 libusb-1.0-0-dev pkg-config

RUN git clone https://github.com/osmocom/rtl-sdr && cd rtl-sdr && \
    mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/usr .. && \
    make && make install && cd ../.. && rm -r rtl-sdr

RUN git clone https://github.com/airspy/airspyone_host.git && cd airspyone_host && \
    mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/usr .. && \
    make && make install && cd ../.. && rm -r airspyone_host

RUN git clone https://github.com/airspy/airspyhf.git && cd airspyhf && \
    mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/usr .. && \
    make && make install && cd ../.. && rm -r airspyhf

RUN apt-get autoremove -y curl git build-essential cmake libusb-1.0-0-dev pkg-config

COPY entrypoint.sh .
ENTRYPOINT ["./entrypoint.sh"]
