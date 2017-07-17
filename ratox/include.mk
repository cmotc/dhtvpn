build-ratox:
	cd ratox && docker build -t alpine-ratox .

enter-ratox:
	docker run -i --rm --name alpine-ratox -t alpine-ratox /bin/sh

enter-running-ratox:
	docker exec -i -t alpine-ratox /bin/sh

run-ratox:
	docker run -id --rm \
		--name alpine-ratox \
		--network dhtvpn-network \
		--ip 192.168.5.2 \
		-t alpine-ratox ratox

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
