# dhtvpn

ratox and openVPN configurations, talking to eachother, expressed as
Dockerfiles.

#What's the point?

Because it's kind of hard to establish a VPN between mobile peers behind
unpredictable NAT configurations. Tox is great at dealing with this, and using
the ratox client we can set it up to provide us with addressing between peers
that don't have constant IP addresses. Also, the VPN traffic just looks like
Tox traffic, albeit maybe a recognizable/unique pattern.

