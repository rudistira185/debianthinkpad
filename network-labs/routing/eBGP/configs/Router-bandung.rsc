# 2026-03-19 17:16:34 by RouterOS 7.16
# software id = 
#
/port
set 0 name=serial0
/routing bgp template
set default disabled=yes routing-table=main
add as=65520 disabled=no name=bandung-main output.redistribute=connected \
    router-id=2.2.2.2
/ip address
add address=172.10.10.2/30 comment="== p2p to Router-jakarta" interface=\
    ether1 network=172.10.10.0
add address=2.2.2.2 interface=lo network=2.2.2.2
/routing bgp connection
add as=65520 disabled=no local.address=172.10.10.2 .role=ebgp name=\
    "to Router-jakarta" output.redistribute=connected remote.address=\
    172.10.10.1/32 .as=65510 router-id=2.2.2.2 routing-table=main templates=\
    bandung-main
/system identity
set name=Router-bandung
/system note
set show-at-login=no
/tool romon
set enabled=yes
