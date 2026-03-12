# 2026-03-12 15:06:46 by RouterOS 7.16
# software id = 
#
/port
set 0 name=serial0
/routing ospf instance
add disabled=no name=ospf-instance-main redistribute=connected router-id=\
    1.1.1.1
/routing ospf area
add disabled=no instance=ospf-instance-main name=ospf-area-backbone
/ip address
add address=10.0.0.1/30 comment="p2p to Router2" interface=ether1 network=\
    10.0.0.0
add address=20.0.0.1/30 comment="p2p to Router3" interface=ether2 network=\
    20.0.0.0
add address=10.10.10.10/24 comment="remote from virbr1" interface=ether8 \
    network=10.10.10.0
add address=1.1.1.1 interface=lo network=1.1.1.1
/routing ospf interface-template
add area=ospf-area-backbone comment="== main" disabled=no networks=\
    10.0.0.0/30,20.0.0.0/30 type=ptp
/system identity
set name=Router1
/system note
set show-at-login=no
/tool romon
set enabled=yes
