FROM alpine
#RUN addgroup -S openvpn
#RUN adduser -h /var/lib/openvpn -g "Account to run openvpn" -s /sbin/nologin -G openvpn -S -D -H openvpn
RUN apk update
RUN apk --no-cache add openvpn easy-rsa
RUN mkdir -p /etc/openvpn/keys \
        /etc/openvpn/server \
        /etc/openvpn/client \
        /etc/openvpn/easyrsa/ca

WORKDIR /usr/share/easy-rsa
RUN find . && sleep 10
RUN cp /usr/share/easy-rsa/vars.example /etc/openvpn/keys/vars

RUN openvpn --genkey --secret ta.key
RUN ./easyrsa init-pki
RUN ./easyrsa --batch build-ca nopass

RUN ./easyrsa --batch build-server-full dhtvpn-server nopass

RUN ./easyrsa --batch build-client-full dhtvpn-client nopass
RUN ./easyrsa gen-dh

RUN echo 'local 127.0.0.1' | tee /etc/openvpn/server/server.conf
RUN echo 'port 1194' | tee -a /etc/openvpn/server/server.conf
RUN echo 'proto udp' | tee -a /etc/openvpn/server/server.conf
RUN echo 'dev tun' | tee -a /etc/openvpn/server/server.conf
RUN echo 'ca /etc/openvpn/server/ca.cert' | tee -a /etc/openvpn/server/server.conf
RUN echo 'cert /etc/openvpn/server/dhtvpn-server.crt' | tee -a /etc/openvpn/server/server.conf
RUN echo 'key /etc/openvpn/server/dhtvpn-server.key' | tee -a /etc/openvpn/server/server.conf
RUN echo 'tls-auth /etc/openvpn/easyrsa/ca/ta.key 0' | tee -a /etc/openvpn/server/server.conf
RUN echo 'dh /etc/openvpn/easyrsa/ca/dh2048.pem' | tee -a /etc/openvpn/server/server.conf
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
RUN echo 'ns-cert-type server' | tee -a /etc/openvpn/client/client.conf
RUN echo 'persist-key' | tee -a /etc/openvpn/client/client.conf
RUN echo 'persist-tun' | tee -a /etc/openvpn/client/client.conf
RUN echo 'cert /etc/openvpn/client/dhtvpn-client.crt' | tee -a /etc/openvpn/client/client.conf
RUN echo 'key /etc/openvpn/client/dhtvpn-client.key' | tee -a /etc/openvpn/client/client.conf
RUN echo 'ca /etc/openvpn/client/ca.cert' | tee -a /etc/openvpn/client/client.conf
RUN echo 'comp-lzo' | tee -a /etc/openvpn/client/client.conf
RUN echo 'verb 3' | tee -a /etc/openvpn/client/client.conf

RUN cp ta.key /etc/openvpn/easyrsa/ca
RUN cp pki/ca.crt /etc/openvpn/easyrsa/ca
RUN cp pki/dh.pem /etc/openvpn/easyrsa/ca

RUN cp pki/ca.crt /etc/openvpn/server/
RUN cp pki/issued/dhtvpn-server.crt /etc/openvpn/server
RUN cp pki/private/dhtvpn-server.key /etc/openvpn/server

RUN cp pki/ca.crt /etc/openvpn/client/
RUN cp pki/issued/dhtvpn-client.crt /etc/openvpn/client
RUN cp pki/private/dhtvpn-client.key /etc/openvpn/client

