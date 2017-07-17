all:
	make dhtvpn-network-create; \
	make build-ratox; \
	make build-openvpn; \
	make run-openvpn; \
	make openvpn-get-ccert && docker stop alpine-openvpn-server && \
	make build-openvpn-client; \
	#make run-ratox
	#make run-openvpn

include ratox/include.mk
include openvpn/include.mk
include openvpn-client/include.mk
include network.mk
#include config.mk

dhtvpn-connect-all:
	docker exec \
		-d \
		--user ratox \
		-t alpine-ratox \
		/usr/bin/dhtvpn-connect-all

ratox-server-pipecheck:
	docker exec \
		--user ratox \
		-t alpine-ratox \
		ps aux

prune:
	docker system prune -f

