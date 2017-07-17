dhtvpn-network-create:
	docker network create --subnet=192.168.0.0/16 \
		--ip-range=192.168.5.0/24 \
		dhtvpn-network

grsoften:
	@echo "** Root is only required on hardened kernels. ctrl-c to continue"
	sudo sysctl -w kernel.grsecurity.chroot_deny_mknod=0
	sudo sysctl -p

grharden:
	@echo "** If you canceled before, you can cancel now. If you didn't, this probably just worked."
	sudo sysctl -w kernel.grsecurity.chroot_deny_mknod=1
	sudo sysctl -p
	sudo sysctl kernel.grsecurity.chroot_deny_mknod
