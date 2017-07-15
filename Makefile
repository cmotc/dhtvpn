
build-ratox:
	cd ratox && docker build -t alpine-ratox .

enter-ratox:
	docker run -i --rm --name alpine-ratox -t alpine-ratox /bin/sh

enter-running-ratox:
	docker exec -i -t alpine-ratox /bin/sh

run-ratox:
	docker run -id \
		--name alpine-ratox \
		-t alpine-ratox ratox

ratox-connect-openvpn:
	docker exec \
		-d \
		--user ratox \
		-t plex-squid-cache-ratox \
		/bin/sh -c 'cat < $tox_friend/file_out | nc -u 192.168.3.133 1194 > $tox_friend/file_in' &
