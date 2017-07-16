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

client-openvpn:
	docker run -i --rm \
		--name alpine-openvpn-client \
		--network dhtvpn-network \
		--ip 192.168.5.3 \
		-t alpine-openvpn openvpn --config /etc/openvpn/client/client.conf

openvpn-get-ccert:
	docker cp alpine-openvpn-server:/etc/openvpn/client/dhtvpn-client.crt ../
	docker cp alpine-openvpn-server:/etc/openvpn/client/dhtvpn-client.key ../
	docker cp alpine-openvpn-server:/etc/openvpn/client/ca.crt ../

grsoften:
	@echo "** Root is only required on hardened kernels. ctrl-c to continue"
	sudo sysctl -w kernel.grsecurity.chroot_deny_mknod=0
	sudo sysctl -p

grharden:
	@echo "** If you canceled before, you can cancel now. If you didn't, this probably just worked."
	sudo sysctl -w kernel.grsecurity.chroot_deny_mknod=1
	sudo sysctl -p
	sudo sysctl kernel.grsecurity.chroot_deny_mknod

