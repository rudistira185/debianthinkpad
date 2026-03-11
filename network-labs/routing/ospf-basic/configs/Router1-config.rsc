# 2026-03-11 06:52:56 by RouterOS 7.16
# software id = 
#
/port
set 0 name=serial0
/routing ospf instance
add disabled=no mpls-te-address="" name=ospf-instance-Router1 redistribute=\
    connected router-id=1.1.1.1
/routing ospf area
add disabled=no instance=ospf-instance-Router1 name=backbone
/ip address
add address=192.168.10.1/24 comment="to PC1" interface=ether1 network=\
    192.168.10.0
add address=10.10.10.10/24 comment="remote from virbr1" interface=ether8 \
    network=10.10.10.0
add address=1.1.1.1 interface=lo network=1.1.1.1
add address=10.0.0.1/30 comment="p2p to Router2" interface=ether2 network=\
    10.0.0.0
/routing ospf interface-template
add area=backbone comment="== p2p ospf to Router2" disabled=no networks=\
    10.0.0.0/30,192.168.10.0/24 type=ptp
/system identity
set name=Router1
/system note
set show-at-login=no
/tool romon
set enabled=yes
