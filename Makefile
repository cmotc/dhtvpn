dummy:
	@echo

install-client:
	make dhtvpn-network-create; echo network created
	make build-toxcore
	make build-ratox-client
	make build-openvpn-client
	make run-ratox-client

install-server:
	@echo "Building Server Containers"
	make dhtvpn-network-create; echo network created
	make build-toxcore
	make build-ratox
	make build-openvpn; echo pass-over
	@echo "Building Containers finished"
	@echo
	@echo "Initializing OpenVPN certificates:"
	make run-openvpn; sleep 1
	make openvpn-get-ccert; docker stop alpine-openvpn-server; echo certs generated
	@echo "Initializing OpenVPN certificates Complete"
	@echo "Building Client Containers"
	make build-openvpn-client; echo openvpn
	make run-ratox; sleep 3
	make init-ratox-client; sleep 3
	make ratox-copy-saves
	make ratox-client-friend-request && sleep 3 && make ratox-accept-friends
	make ratox-clean-id
	make ratox-client-clean-id
	make check-config-exists
	docker stop alpine-ratox-client
	make build-ratox-client
	make run-ratox-client
	@echo "Building Client Containers Complete"
	make tar
	#make run-openvpn

include network.mk

#include config.mk

test:
	@echo it works

runclient:
	make run-ratox-client
	make run-openvpn-client

dhtvpn-connect-all:
	docker exec \
		-d \
		--user ratox \
		-t alpine-ratox \
		cat < /var/lib/ratox/$(ratox_client)/file_out | nc -u 192.168.5.3 1194 > /var/lib/ratox/$(ratox_client)/file_in'

dhtvpn-connect-client:
	docker exec \
		-d \
		--user ratox \
		-t alpine-ratox-client \
		nc -lv 1194 > /var/lib/ratox/$(ratox_service)/file_in < /var/lib/ratox/$(ratox_service)/file_out

ratox-server-pipecheck:
	docker exec \
		--user ratox \
		-t alpine-ratox \
		ps aux

prune:
	docker system prune -f

tar:
	rm -fv redist.tar.gz
	tar -cvzf redist.tar.gz Makefile network.mk openvpn-client config.mk openvpn/include.mk ratox/Dockerfile ratox/include.mk ratox-client/ libtoxcore/
