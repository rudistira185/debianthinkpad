# 2026-03-12 07:36:25 by RouterOS 7.16
# software id = 
#
/port
set 0 name=serial0
/routing ospf instance
add disabled=no name=ospf-instance-main redistribute=connected router-id=\
    3.3.3.3
/routing ospf area
add disabled=no instance=ospf-instance-main name=ospf-area-main
/ip address
add address=192.168.30.1/24 comment="to sw-LAN-C" interface=ether1 network=\
    192.168.30.0
add address=20.0.0.2/30 comment="p2p to Router2" interface=ether7 network=\
    20.0.0.0
add address=3.3.3.3 interface=lo network=3.3.3.3
/routing ospf interface-template
add area=ospf-area-main comment="p2p to Router2" disabled=no networks=\
    20.0.0.0/30,192.168.30.0/24 type=ptp
/system identity
set name=Router3
/system note
set show-at-login=no
/tool romon
set enabled=yes
