# 2026-03-12 07:36:03 by RouterOS 7.16
# software id = 
#
/port
set 0 name=serial0
/routing ospf instance
add disabled=no name=ospf-instance-main redistribute=connected router-id=\
    2.2.2.2
/routing ospf area
add disabled=no instance=ospf-instance-main name=backbone
/ip address
add address=192.168.20.1/24 comment="to sw-LAN-B" interface=ether1 network=\
    192.168.20.0
add address=10.0.0.2/30 comment="p2p to Router1" interface=ether8 network=\
    10.0.0.0
add address=20.0.0.1/30 comment="p2p to Router3" interface=ether7 network=\
    20.0.0.0
add address=2.2.2.2 interface=lo network=2.2.2.2
/routing ospf interface-template
add area=backbone disabled=no networks=\
    10.0.0.0/30,192.168.20.0/30,20.0.0.0/30 type=ptp
/system identity
set name=Router2
/system note
set show-at-login=no
/tool romon
set enabled=yes
