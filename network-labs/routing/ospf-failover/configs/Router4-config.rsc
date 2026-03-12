# 2026-03-12 15:07:56 by RouterOS 7.16
# software id = 
#
/port
set 0 name=serial0
/routing ospf instance
add disabled=no name=ospf-instance-main redistribute=connected router-id=\
    4.4.4.4
/routing ospf area
add disabled=no instance=ospf-instance-main name=ospf-area-backbone
/ip address
add address=40.0.0.2/30 comment="p2p to Router3" interface=ether3 network=\
    40.0.0.0
add address=4.4.4.4 interface=lo network=4.4.4.4
add address=30.0.0.2/30 comment="p2p to Router2" interface=ether2 network=\
    30.0.0.0
/routing ospf interface-template
add area=ospf-area-backbone cost=10 disabled=no networks=40.0.0.0/30 type=ptp
add area=ospf-area-backbone cost=20 disabled=no networks=30.0.0.0/30 type=ptp
/system identity
set name=Router4
/system note
set show-at-login=no
/tool romon
set enabled=yes
