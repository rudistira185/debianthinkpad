# 2026-03-20 09:44:10 by RouterOS 7.16
# software id = 
#
/port
set 0 name=serial0
/routing rip instance
add disabled=no name=rip-main redistribute=connected
/ip address
add address=172.20.20.2/30 comment="== p2p to Router2" interface=ether1 \
    network=172.20.20.0
add address=3.3.3.3 interface=lo network=3.3.3.3
/ip dhcp-client
add interface=ether1
/routing rip interface-template
add disabled=no instance=rip-main interfaces=ether1
/system identity
set name=Router3
/system note
set show-at-login=no
/tool romon
set enabled=yes
