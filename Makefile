include ratox/include.mk
include openvpn/include.mk

all:
	make build-ratox
	make build-openvpn

dhtvpn-connect-ratox:
	docker exec \
		--user ratox \
		-t alpine-ratox \
		/usr/bin/dhtvpn-connect-all

#dhtvpn-connect-openvpn:
