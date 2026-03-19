# 2026-03-19 17:16:58 by RouterOS 7.16
# software id = 
#
/port
set 0 name=serial0
/ip address
add address=3.3.3.3 interface=lo network=3.3.3.3
add address=172.20.20.2/30 comment="== p2p to Router-jakarta" interface=\
    ether1 network=172.20.20.0
/routing bgp connection
add as=65530 disabled=no local.address=172.20.20.2 .role=ebgp name=\
    "to Router-jakarta" output.redistribute=connected remote.address=\
    172.20.20.1/32 .as=65510 router-id=3.3.3.3 routing-table=main
/system identity
set name=Router-surabaya
/system note
set show-at-login=no
/tool romon
set enabled=yes
