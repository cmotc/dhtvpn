FROM alpine
RUN addgroup -S ratox
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
USER ratox
RUN unzip -aq master.zip
WORKDIR /tmp/tox/c-toxcore-master
RUN /bin/sh ./autogen.sh
RUN /bin/sh ./configure --prefix=/usr --enable-daemon --disable-ntox
RUN make
USER root
RUN make install
RUN install -o root -g root -m 644 other/bootstrap_daemon/tox-bootstrapd.conf /etc/tox-bootstrapd.conf
WORKDIR /tmp/tox/
ADD https://github.com/pranomostro/ratox/archive/master.zip /tmp/tox/ratox.zip
RUN chmod 644 /tmp/tox/ratox.zip
USER ratox
RUN unzip -aq ratox.zip
WORKDIR /tmp/tox/ratox-master
RUN make
USER root
RUN make install
RUN echo '#! /bin/sh' | tee /usr/bin/ratox-list-friends
RUN echo 'find /var/lib/ratox/ -type d ! -name name ! -name request ! -name 'out' ! -name state ! -name status ! -name nospam ! -name conf' | tee -a /usr/bin/ratox-list-friends
RUN chmod 755 /usr/bin/ratox-list-friends

RUN echo '#! /bin/sh' | tee /usr/bin/ratox-list-requests
RUN echo 'find /var/lib/ratox/request/out/' | tee -a /usr/bin/ratox-list-requests
RUN chmod 755 /usr/bin/ratox-list-requests

RUN echo '#! /bin/sh' | tee /usr/bin/ratox-accept-friends
RUN echo 'for friend_request in $(ratox-list-requests); do' | tee -a /usr/bin/ratox-accept-friends
RUN echo '   echo 1 > $friend_request' | tee -a /usr/bin/ratox-accept-friends
RUN echo 'done ' | tee -a /usr/bin/ratox-accept-friends
RUN chmod 755 /usr/bin/ratox-accept-friends

RUN echo '#!/bin/sh' | tee /usr/bin/dhtvpn-connect-all
RUN echo 'for tox_friend in $(ratox-list-friends); do' | tee -a /usr/bin/dhtvpn-connect-all
RUN echo '   cat < $tox_friend/file_out | nc -u 192.168.3.101 1194 > $tox_friend/file_in' | tee -a /usr/bin/dhtvpn-connect-all
RUN echo 'done' | tee -a /usr/bin/dhtvpn-connect-all
RUN chmod 755 /usr/bin/dhtvpn-connect-all

RUN sed -i 's/^root::/root:!:/' /etc/shadow
RUN rm -rf /tmp/tox
RUN delgroup ratox grsec-tpe
USER ratox
WORKDIR /var/lib/ratox
CMD ["/usr/local/bin/ratox"]

