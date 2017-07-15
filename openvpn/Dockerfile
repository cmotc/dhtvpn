FROM alpine
#RUN addgroup -S openvpn
#RUN adduser -h /var/lib/openvpn -g "Account to run openvpn" -s /sbin/nologin -G openvpn -S -D -H openvpn
RUN apk update && apk search -v 'openssl*'
RUN apk --no-cache add openvpn openssl
RUN mkdir -p /etc/openvpn/keys /etc/openvpn/server /etc/openvpn/client
RUN echo 'local 127.0.0.1' | tee /etc/openvpn/server/server.conf
RUN echo 'port 1194' | tee -a /etc/openvpn/server/server.conf
RUN echo 'proto udp' | tee -a /etc/openvpn/server/server.conf
RUN echo 'dev tun' | tee -a /etc/openvpn/server/server.conf
#RUN echo 'ca openvpn_certs/server-ca.pem' | tee -a /etc/openvpn/server/server.conf
RUN echo 'cert openvpn_certs/server-cert.pem' | tee -a /etc/openvpn/server/server.conf
RUN echo 'dh openvpn_certs/dh4096.pem #to generate by hand #openssl dhparam -out dh1024.pem 1024' | tee -a /etc/openvpn/server/server.conf
RUN echo 'server 10.0.0.0 255.255.255.0' | tee -a /etc/openvpn/server/server.conf
RUN echo 'ifconfig-pool-persist ipp.txt' | tee -a /etc/openvpn/server/server.conf
RUN echo 'push "route 10.0.0.0 255.0.0.0"' | tee -a /etc/openvpn/server/server.conf
RUN echo 'push "dhcp-option DNS 10.0.0.1"' | tee -a /etc/openvpn/server/server.conf
RUN echo 'keepalive 10 120' | tee -a /etc/openvpn/server/server.conf
RUN echo 'comp-lzo' | tee -a /etc/openvpn/server/server.conf
RUN echo 'user nobody' | tee -a /etc/openvpn/server/server.conf
RUN echo 'group nobody' | tee -a /etc/openvpn/server/server.conf
RUN echo 'persist-key' | tee -a /etc/openvpn/server/server.conf
RUN echo 'persist-tun' | tee -a /etc/openvpn/server/server.conf
RUN echo 'status /var/log/openvpn-status.log' | tee -a /etc/openvpn/server/server.conf

RUN echo 'client' | tee -a /etc/openvpn/client/client.conf
RUN echo 'dev tun' | tee -a /etc/openvpn/client/client.conf
RUN echo 'proto udp' | tee -a /etc/openvpn/client/client.conf
RUN echo 'remote "127.0.0.1" 1194' | tee -a /etc/openvpn/client/client.conf
RUN echo 'resolv-retry infinite' | tee -a /etc/openvpn/client/client.conf
RUN echo 'nobind' | tee -a /etc/openvpn/client/client.conf
RUN echo 'ns-cert-type server # This means that the certificate on the openvpn server needs to have this field. Prevents MitM attacks' | tee -a /etc/openvpn/client/client.conf
RUN echo 'persist-key' | tee -a /etc/openvpn/client/client.conf
RUN echo 'persist-tun' | tee -a /etc/openvpn/client/client.conf
RUN echo 'ca client-ca.pem' | tee -a /etc/openvpn/client/client.conf
RUN echo 'cert client-cert.pem' | tee -a /etc/openvpn/client/client.conf
RUN echo 'key client-key.pem' | tee -a /etc/openvpn/client/client.conf
RUN echo 'comp-lzo' | tee -a /etc/openvpn/client/client.conf
RUN echo 'verb 3' | tee -a /etc/openvpn/client/client.conf
