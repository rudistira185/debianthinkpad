# 2026-03-20 09:43:24 by RouterOS 7.16
# software id = 
#
/port
set 0 name=serial0
/routing rip instance
add disabled=no name=rip-main redistribute=connected,rip
/ip address
add address=10.10.10.10/24 comment="to virbr1" interface=ether1 network=\
    10.10.10.0
add address=172.10.10.1/30 comment="== p2p to Router1" interface=ether2 \
    network=172.10.10.0
add address=172.20.20.1/30 comment="== p2p to Router3" interface=ether3 \
    network=172.20.20.0
add address=2.2.2.2 interface=lo network=2.2.2.2
/routing filter rule
add chain=rip-main-out disabled=no rule=\
    "if (dst in 10.10.10.0/24) {reject;}\
    \naccept"
add chain=rip-main-accept-rip disabled=no rule=\
    "if (protocol rip) {accept} else {reject}"
/routing rip interface-template
add disabled=no instance=rip-main interfaces=ether2
add disabled=no instance=rip-main interfaces=ether3
/system identity
set name=Router2
/system note
set show-at-login=no
/tool romon
set enabled=yes
