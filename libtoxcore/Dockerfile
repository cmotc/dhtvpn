FROM alpine
RUN addgroup -S ratox
RUN addgroup grsec-tpe
RUN adduser -h /var/lib/ratox -g "Account to run ratox" -s /sbin/nologin -G grsec-tpe -G ratox -S -D -H ratox
RUN install -d -o ratox -g ratox -m 700 /var/lib/ratox
RUN apk --no-cache add libsodium libconfig && \
        apk --no-cache add --virtual build-dependencies \
        autoconf \
        automake \
        check-dev \
        curl \
        build-base \
        libtool \
        libconfig-dev \
        libsodium-dev \
        libvpx-dev \
        linux-headers \
        opus-dev \
        unzip
RUN mkdir -p /tmp/tox
RUN chown ratox:ratox /tmp/tox
ADD https://github.com/toktok/c-toxcore/archive/master.zip /tmp/tox/master.zip
RUN chmod 644 /tmp/tox/master.zip
WORKDIR /tmp/tox
USER root
RUN unzip -aq master.zip
WORKDIR /tmp/tox/c-toxcore-master
RUN chown root:root -R /tmp/tox/c-toxcore-master
RUN ./autogen.sh
RUN ./configure --enable-daemon --disable-ntox
RUN make
USER root
RUN make install
RUN install -o root -g root -m 644 other/bootstrap_daemon/tox-bootstrapd.conf /etc/tox-bootstrapd.conf
WORKDIR /tmp/tox/
