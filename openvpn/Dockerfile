FROM alpine
#RUN addgroup -S openvpn
#RUN adduser -h /var/lib/openvpn -g "Account to run openvpn" -s /sbin/nologin -G openvpn -S -D -H openvpn
RUN apk update
RUN apk --no-cache add openvpn easy-rsa #sudo
#RUN echo "openvpn:openvpn" | chpasswd
#RUN adduser openvpn wheel
#RUN sed -ri 's/(wheel:x:10:root)/\1,openvpn/' /etc/group
#RUN sed -ri 's/# %wheel\tALL=\(ALL\) ALL/%wheel\tALL=\(ALL\) ALL/' /etc/sudoers
RUN echo '#! /bin/sh' | tee -a /sbin/tun1_set
RUN echo 'mkdir -p /dev/net/ && mknod /dev/net/tun c 10 200' | tee -a /sbin/tun1_set
RUN chmod +x /sbin/tun1_set
#RUN echo 'openvpn ALL=(ALL) NOPASSWD: /sbin/tun1_set' | tee -a /etc/sudoers
RUN mkdir -p /etc/openvpn/keys \
        /etc/openvpn/server \
        /etc/openvpn/client \
        /etc/openvpn/easyrsa/ca

WORKDIR /usr/share/easy-rsa

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
RUN echo 'ca pki/ca.crt' | tee -a /etc/openvpn/server/server.conf
RUN echo 'cert pki/issued/dhtvpn-server.crt' | tee -a /etc/openvpn/server/server.conf
RUN echo 'key pki/private/dhtvpn-server.key' | tee -a /etc/openvpn/server/server.conf
RUN echo 'tls-auth ta.key 0' | tee -a /etc/openvpn/server/server.conf
RUN echo 'dh pki/dh.pem' | tee -a /etc/openvpn/server/server.conf
RUN echo 'cipher AES-256-CBC' | tee -a /etc/openvpn/server/server.conf
RUN echo 'server 10.0.0.0 255.255.255.0' | tee -a /etc/openvpn/server/server.conf
RUN echo 'ifconfig-pool-persist ipp.txt' | tee -a /etc/openvpn/server/server.conf
RUN echo 'push "route 10.0.0.0 255.0.0.0"' | tee -a /etc/openvpn/server/server.conf
RUN echo 'push "dhcp-option DNS 87.98.175.85"' | tee -a /etc/openvpn/server/server.conf
RUN echo 'push "dhcp-option DNS 23.94.5.133"' | tee -a /etc/openvpn/server/server.conf
RUN echo 'keepalive 10 120' | tee -a /etc/openvpn/server/server.conf
RUN echo 'comp-lzo' | tee -a /etc/openvpn/server/server.conf
RUN echo 'push "redirect-gateway def1"' | tee -a /etc/openvpn/server/server.conf
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
RUN echo 'cert pki/issued/dhtvpn-client.crt' | tee -a /etc/openvpn/client/client.conf
RUN echo 'key pki/private/dhtvpn-client.key' | tee -a /etc/openvpn/client/client.conf
RUN echo 'ca pki/ca.cert' | tee -a /etc/openvpn/client/client.conf
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
RUN echo '#! /bin/sh' | tee /bin/start-vpn-server
RUN echo '/sbin/tun1_set && openvpn --config /etc/openvpn/server/server.conf' | tee -a /bin/start-vpn-server
RUN chmod 755 /bin/start-vpn-server
EXPOSE 1194/udp
