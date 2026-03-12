# 2026-03-12 15:07:10 by RouterOS 7.16
# software id = 
#
/port
set 0 name=serial0
/routing ospf instance
add disabled=no name=ospf-instance-main redistribute=connected router-id=\
    2.2.2.2
/routing ospf area
add disabled=no instance=ospf-instance-main name=ospf-area-main
/ip address
add address=10.0.0.2/30 comment="p2p to Router1" interface=ether1 network=\
    10.0.0.0
add address=2.2.2.2 interface=lo network=2.2.2.2
add address=30.0.0.1/30 comment="p2p to Router4" interface=ether2 network=\
    30.0.0.0
/routing ospf interface-template
add area=ospf-area-main disabled=no networks=10.0.0.0/30,30.0.0.0/30 type=ptp
/system identity
set name=Router2
/system note
set show-at-login=no
/tool romon
set enabled=yes
