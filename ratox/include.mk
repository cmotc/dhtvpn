build-ratox:
	cd ratox && docker build -t alpine-ratox .

build-ratox-client:
	cd ratox-client && docker build -t alpine-ratox-client .

enter-ratox:
	docker run -i --rm --name alpine-ratox -t alpine-ratox /bin/sh

enter-running-ratox:
	docker exec -i -t alpine-ratox /bin/sh

enter-running-ratox-client:
	docker exec -i -t alpine-ratox-client /bin/sh

run-ratox:
	docker run -id --rm \
		--name alpine-ratox \
		--network dhtvpn-network \
		--ip 192.168.5.2 \
		-v ratox:/var/lib/ratox/ \
		-t alpine-ratox ratox /var/lib/ratox/server.save
	sleep 2
	make ratox-get-id

ratox-clean-id:
	@grep -v ratox_service config.mk > config.mk.tmp; \
	mv config.mk.tmp config.mk
	echo ratox_service = $(shell docker exec \
		--user ratox \
		-t alpine-ratox \
		cat /var/lib/ratox/id) >> config.mk

run-ratox-client:
	docker run -id --rm \
		--name alpine-ratox-client \
		--network dhtvpn-network \
		--ip 192.168.5.4 \
		-v ratox-client:/var/lib/ratox/ \
		-p 1194:1194 \
		-t alpine-ratox ratox /var/lib/ratox/client.save
	sleep 2
	make ratox-get-id-client

run-ratox-vpn-client:
	docker run -id --rm \
		--name alpine-ratox-client \
		--network dhtvpn-network \
		--ip 192.168.5.4 \
		-p 1194:1194 \
		-t alpine-ratox ratox /var/lib/ratox/client.save
	sleep 2
	make ratox-get-id-client

ratox-client-clean-id:
	@grep -v ratox_client config.mk > config.mk.tmp; \
	mv config.mk.tmp config.mk
	echo ratox_client = $(shell docker exec \
		--user ratox \
		-t alpine-ratox-client \
		cat /var/lib/ratox/id) >> config.mk

ratox-client-friend-request:
	docker exec -i -t alpine-ratox-client /bin/sh -c 'echo "$(ratox_service)" > /var/lib/ratox/request/in'

ratox-remove-all:
	docker exec \
		--user ratox \
		-t alpine-ratox \
		/bin/sh -c 'echo 1 | tee /var/lib/ratox/*/remove'

ratox-list-friends:
	docker exec \
		--user ratox \
		-t alpine-ratox \
		/usr/bin/ratox-list-friends

ratox-list-client-friends:
	docker exec \
		--user ratox \
		-t alpine-ratox-client \
		/usr/bin/ratox-list-friends

ratox-list-requests:
	docker exec \
		--user ratox \
		-t alpine-ratox \
		/usr/bin/ratox-list-requests

ratox-accept-friends:
	docker exec \
		--user ratox \
		-t alpine-ratox \
		/usr/bin/ratox-accept-friends

ratox-get-id:
	docker exec \
		--user ratox \
		-t alpine-ratox \
		cat /var/lib/ratox/id

ratox-get-id-client:
	docker exec \
		--user ratox \
		-t alpine-ratox-client \
		cat /var/lib/ratox/id

ratox-send-request:
	@echo $(peer)
	docker exec \
		--user ratox \
		-t alpine-ratox \
		/bin/sh -c "echo $(peer) > request/in"

ratox-pipelog:
	docker exec \
		--user ratox \
		-t alpine-ratox \
		cat *.log *.err

ratox-copy-saves:
	docker cp alpine-ratox:/var/lib/ratox/server.save server.save
	docker cp alpine-ratox-client:/var/lib/ratox/client.save client.save
	docker stop alpine-ratox
	docker stop alpine-ratox-client
	mv client.save ratox-client/client.save
	mv server.save ratox/server.save
