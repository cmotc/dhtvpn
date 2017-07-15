build-openvpn:
	cd openvpn && docker build -t alpine-openvpn .

enter-openvpn:
	docker run -i --rm --name alpine-openvpn -t alpine-openvpn /bin/sh

enter-running-openvpn:
	docker exec -i -t alpine-openvpn /bin/sh

run-openvpn:
	docker run -id \
		--name alpine-openvpn \
		--network dhtvpn-network \
		--ip 192.168.5.3 \
		-t alpine-openvpn openvpn
