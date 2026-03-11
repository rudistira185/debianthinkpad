# 2026-03-11 06:53:43 by RouterOS 7.16
# software id = 
#
/port
set 0 name=serial0
/routing ospf instance
add disabled=no name=ospf-instance-Router2 redistribute=connected router-id=\
    2.2.2.2
/routing ospf area
add disabled=no instance=ospf-instance-Router2 name=ospf-backbone
/ip address
add address=192.168.20.1/24 comment="to PC2" interface=ether1 network=\
    192.168.20.0
add address=2.2.2.2 interface=lo network=2.2.2.2
add address=10.0.0.2/30 comment="p2p to Router1" interface=ether2 network=\
    10.0.0.0
/routing ospf interface-template
add area=ospf-backbone disabled=no networks=10.0.0.0/30,192.168.20.0/24 type=\
    ptp
/system identity
set name=Router2
/system note
set show-at-login=no
/tool romon
set enabled=yes
