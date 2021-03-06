build-openvpn:
	cd openvpn && docker build -t alpine-openvpn .

enter-openvpn:
	docker run -i --rm --name alpine-openvpn -t alpine-openvpn /bin/sh

enter-running-openvpn:
	docker exec -i -t alpine-openvpn /bin/sh

run-openvpn:
	make grsoften; \
	docker run -id --rm \
		--cap-drop=all \
		--name alpine-openvpn-server \
		--network dhtvpn-network \
		--ip 192.168.5.3 \
		-p 1194:1194/udp \
		--cap-add=NET_ADMIN \
		--cap-add=SETGID \
		--cap-add=SETUID \
		--cap-add=AUDIT_WRITE \
		--cap-add=MKNOD \
		-t alpine-openvpn start-vpn-server
	make grharden

openvpn-get-ccert:
	mkdir -p openvpn-client/pki/issued/ openvpn-client/pki/private
	docker cp alpine-openvpn-server:/etc/openvpn/client/dhtvpn-client.crt \
		openvpn-client/pki/issued/
	docker cp alpine-openvpn-server:/etc/openvpn/client/dhtvpn-client.key \
		openvpn-client/pki/private/
	docker cp alpine-openvpn-server:/etc/openvpn/client/ca.crt \
		openvpn-client/pki/

