build-ratox:
	cd ratox && docker build -t alpine-ratox .

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
		-t alpine-ratox ratox
	sleep 2
	make ratox-get-id | tail -n +4

ratox-clean-id:
	$(shell make docker exec \
		--user ratox \
		-t alpine-ratox \
		cat /var/lib/ratox/id)

run-ratox-client:
	docker run -id \
		--name alpine-ratox-client \
		--network dhtvpn-network \
		--ip 192.168.5.4 \
		-t alpine-ratox ratox
	sleep 2
	make ratox-get-id-client

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
