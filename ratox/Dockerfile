FROM alpine-toxcore
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
RUN echo '  if [ "$friend_request" != "/var/lib/ratox/request/out/" ]; then' | tee -a /usr/bin/ratox-accept-friends
RUN echo '    echo 1 > $friend_request' | tee -a /usr/bin/ratox-accept-friends
RUN echo '  fi' | tee -a /usr/bin/ratox-accept-friends
RUN echo 'done' | tee -a /usr/bin/ratox-accept-friends
RUN chmod 755 /usr/bin/ratox-accept-friends

#RUN echo '#!/bin/sh' | tee /usr/bin/dhtvpn-connect-all
#RUN echo 'for tox_friend in $(ratox-list-friends); do' | tee -a /usr/bin/dhtvpn-connect-all
#RUN echo '  if [ -p "$tox_friend/file_out" ]; then' | tee -a /usr/bin/dhtvpn-connect-all
#RUN echo '    echo "connecting $tox_friend to openVPN" >> connect.log' | tee -a /usr/bin/dhtvpn-connect-all
#RUN echo '  fi' | tee -a /usr/bin/dhtvpn-connect-all
#RUN echo '  if [ -p "$tox_friend/file_out" ]; then' | tee -a /usr/bin/dhtvpn-connect-all
#RUN echo '    cat < $tox_friend/file_out | nc -u 192.168.5.3 1194 > $tox_friend/file_in' | tee -a /usr/bin/dhtvpn-connect-all
#RUN echo '  else' | tee -a /usr/bin/dhtvpn-connect-all
#RUN echo '    echo "$tox_friend/file_out not found" >> connect.err' | tee -a /usr/bin/dhtvpn-connect-all
#RUN echo '  fi' | tee -a /usr/bin/dhtvpn-connect-all
#RUN echo 'done' | tee -a /usr/bin/dhtvpn-connect-all
#RUN chmod 755 /usr/bin/dhtvpn-connect-all

RUN sed -i 's/^root::/root:!:/' /etc/shadow
RUN rm -rf /tmp/tox
RUN delgroup grsec-tpe
USER ratox
WORKDIR /var/lib/ratox
EXPOSE 1194/udp
CMD ["/usr/local/bin/ratox"]

