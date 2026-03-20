# 2026-03-20 09:42:57 by RouterOS 7.16
# software id = 
#
/port
set 0 name=serial0
/routing rip instance
add disabled=no name=rip-main redistribute=connected
/ip address
add address=172.10.10.2/30 comment="== p2p to Router2" interface=ether1 \
    network=172.10.10.0
add address=1.1.1.1 interface=lo network=1.1.1.1
/ip dhcp-client
add interface=ether1
/routing rip interface-template
add disabled=no instance=rip-main interfaces=ether1
/system identity
set name=Router1
/system note
set show-at-login=no
/tool romon
set enabled=yes
