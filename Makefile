all:
	make dhtvpn-network-create; \
	make build-ratox; \
	make build-openvpn; \
	#make run-ratox
	#make run-openvpn

include ratox/include.mk
include openvpn/include.mk
include network.mk

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

