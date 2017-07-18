all:
	@echo "Building Server Containers"
	make dhtvpn-network-create; echo network created
	make build-toxcore
	make build-ratox
	make build-openvpn; echo pass-over
	@echo "Building Containers finished"
	@echo
	@echo "Initializing OpenVPN certificates:"
	make run-openvpn; sleep 1
	make openvpn-get-ccert; docker stop alpine-openvpn-server; echo pass-over
	@echo "Initializing OpenVPN certificates Complete"
	@echo "Building Client Containers"
	make build-openvpn-client; \
	make run-ratox; \
	make ratox-clean-id
	make check-config-exists
	make run-ratox-client; sleep 1
	make ratox-client-friend-request && sleep 3
	make ratox-client-clean-id
	make ratox-accept-friends
	docker stop alpine-ratox
	docker stop alpine-ratox-client
	make ratox-copy-saves
	mv client.save ratox-client/client.save
	mv server.save ratox/server.save
	@echo "Building Client Containers Complete"
	make tar
	#make run-openvpn

include network.mk

#include config.mk

test:
	@echo it works

push:
	sed -i 's|#include config.mk|#include config.mk|' Makefile
	git add .
	git commit -am "fine-tuning"
	git push

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
		nc -lv 1194 > /var/lib/ratox/$(ratox_server)/file_in < /var/lib/ratox/$(ratox_server)/file_out

ratox-server-pipecheck:
	docker exec \
		--user ratox \
		-t alpine-ratox \
		ps aux

prune:
	docker system prune -f

tar:
	rm -f redist.tar.gz
	tar -cvzf redist.tar.gz Makefile network.mk openvpn-client config.mk openvpn/include.mk ratox/Dockerfile ratox/include.mk ratox-client/client.save libtoxcore/
