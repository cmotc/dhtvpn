FROM alpine
#RUN addgroup -S openvpn
#RUN adduser -h /var/lib/openvpn -g "Account to run openvpn" -s /sbin/nologin -G openvpn -S -D -H openvpn
RUN apk update && apk search -v 'openvpn*'
RUN apk --no-cache add openvpn
