# 2026-03-19 17:15:57 by RouterOS 7.16
# software id = 
#
/port
set 0 name=serial0
/routing bgp template
set default disabled=yes routing-table=main
add as=65510 disabled=yes name=main-jakarta output.redistribute=connected,bgp \
    router-id=1.1.1.1 routing-table=main
/ip address
add address=10.10.10.10/24 comment="to virbr1" interface=ether1 network=\
    10.10.10.0
add address=1.1.1.1 interface=lo network=1.1.1.1
add address=172.10.10.1/30 comment="== p2p to Router-bandung" interface=\
    ether2 network=172.10.10.0
add address=172.20.20.1/30 comment="== p2p to Router-surabaya" interface=\
    ether3 network=172.20.20.0
/routing bgp connection
add as=65510 disabled=no local.address=172.10.10.1 .role=ebgp name=\
    "to Router-bandung" output.filter-chain=ebgp-main-output .redistribute=\
    connected,bgp remote.address=172.10.10.2/32 .as=65520 router-id=1.1.1.1
add as=65510 disabled=no local.address=172.20.20.1 .role=ebgp name=\
    "to Router-surabaya" output.filter-chain=ebgp-main-output .redistribute=\
    connected,bgp remote.address=172.20.20.2/32 .as=65530 router-id=1.1.1.1 \
    routing-table=main
/routing filter rule
add chain=ebgp-main-output disabled=no rule=\
    "if (dst in 10.10.10.0/24) {reject;}\
    \naccept"
/system identity
set name=Router-jakarta
/system note
set show-at-login=no
/tool romon
set enabled=yes
