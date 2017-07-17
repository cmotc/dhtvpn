build-openvpn-client:
	cd openvpn-client && docker build -t alpine-openvpn-client .

enter-openvpn-client:
	docker run -i --rm --name alpine-openvpn -t alpine-openvpn-client /bin/sh

enter-running-openvpn-client:
	docker exec -i -t alpine-openvpn-client /bin/sh

run-openvpn-client:
	make grsoften; \
	docker run -id --rm \
		--cap-drop=all \
		--name alpine-openvpn-client \
		--network dhtvpn-network \
		--ip 192.168.5.3 \
		-p 1194:1194/udp \
		--cap-add=NET_ADMIN \
		--cap-add=SETGID \
		--cap-add=SETUID \
		--cap-add=AUDIT_WRITE \
		--cap-add=MKNOD \
		-t alpine-openvpn-client start-vpn-client
	make grharden

client-openvpn:
	docker run -i --rm \
		--name alpine-openvpn-client \
		--network dhtvpn-network \
		--ip 192.168.5.3 \
		-t alpine-openvpn openvpn --config /etc/openvpn/client/client.conf
