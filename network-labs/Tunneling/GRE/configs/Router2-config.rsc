# 2026-03-31 17:35:41 by RouterOS 7.16
# software id = 
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
set [ find default-name=ether5 ] disable-running-check=no
set [ find default-name=ether6 ] disable-running-check=no
set [ find default-name=ether7 ] disable-running-check=no
set [ find default-name=ether8 ] disable-running-check=no
/interface gre
add allow-fast-path=no local-address=172.10.10.2 name=to-r1 remote-address=\
    172.10.10.1
/port
set 0 name=serial0
/routing ospf instance
add disabled=no name=ospf-main redistribute=connected router-id=2.2.2.2
/routing ospf area
add disabled=no instance=ospf-main name=ospf-backbone
/ip address
add address=172.10.10.2/30 comment="== p2p to Router1" interface=ether1 \
    network=172.10.10.0
add address=2.2.2.2 interface=lo network=2.2.2.2
add address=50.50.50.2/30 interface=to-r1 network=50.50.50.0
/routing ospf interface-template
add area=ospf-backbone comment="== to r1" disabled=no interfaces=to-r1 type=\
    ptp
/system identity
set name=Router2
/system note
set show-at-login=no
/tool romon
set enabled=yes
