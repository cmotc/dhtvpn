build-openvpn:
	cd openvpn && docker build -t alpine-openvpn .

enter-openvpn:
	docker run -i --rm --name alpine-openvpn -t alpine-openvpn /bin/sh

enter-running-openvpn:
	docker exec -i -t alpine-openvpn /bin/sh

run-openvpn:
	docker run -id \
		--name alpine-openvpn-server \
		--network dhtvpn-network \
		--ip 192.168.5.3 \
		-t alpine-openvpn openvpn --config /etc/openvpn/server/server.conf

client-openvpn:
	docker run -id \
		--name alpine-openvpn-client \
		--network dhtvpn-network \
		--ip 192.168.5.3 \
		-t alpine-openvpn openvpn --config /etc/openvpn/client/client.conf

openvpn-get-ccert:
	docker cp alpine-openvpn-server:/etc/openvpn/client/dhtvpn-client.crt .
	docker cp alpine-openvpn-server:/etc/openvpn/client/dhtvpn-client.key .
	docker cp alpine-openvp-server:/etc/openvpn/client/ca.crt .
