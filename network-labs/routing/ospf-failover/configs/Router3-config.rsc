# 2026-03-12 15:07:34 by RouterOS 7.16
# software id = 
#
/port
set 0 name=serial0
/routing ospf instance
add disabled=no name=ospf-instance-main redistribute=connected router-id=\
    3.3.3.3
/routing ospf area
add disabled=no instance=ospf-instance-main name=ospf-area-backbone
/ip address
add address=3.3.3.3 interface=lo network=3.3.3.3
add address=20.0.0.2/30 comment="p2p to Router1" interface=ether2 network=\
    20.0.0.0
add address=40.0.0.1/30 comment="p2p to Router4" interface=ether3 network=\
    40.0.0.0
/routing ospf interface-template
add area=ospf-area-backbone disabled=no networks=20.0.0.0/30,40.0.0.0/30 \
    type=ptp
/system identity
set name=Router3
/system note
set show-at-login=no
/tool romon
set enabled=yes
