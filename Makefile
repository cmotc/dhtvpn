all:
	make dhtvpn-network-create; \
	make build-ratox; \
	make build-openvpn; \
	#make run-ratox
	#make run-openvpn

include ratox/include.mk
include openvpn/include.mk
include network.mk

dhtvpn-connect-ratox:
	docker exec \
		--user ratox \
		-t alpine-ratox \
		/usr/bin/dhtvpn-connect-all

#dhtvpn-connect-openvpn:

prune:
	docker system prune -f
