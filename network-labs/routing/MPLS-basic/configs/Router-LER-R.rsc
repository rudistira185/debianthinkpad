# 2026-03-21 14:17:20 by RouterOS 7.16
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
/port
set 0 name=serial0
/routing ospf instance
add disabled=no name=main-ospf redistribute=connected router-id=3.3.3.3
/routing ospf area
add disabled=no instance=main-ospf name=ospf-backbone
/ip address
add address=3.3.3.3 interface=lo network=3.3.3.3
add address=172.20.20.2/30 comment="== p2p to Router-LSR" interface=ether1 \
    network=172.20.20.0
/mpls ldp
add disabled=no lsr-id=3.3.3.3 transport-addresses=3.3.3.3 use-explicit-null=\
    yes
/mpls ldp interface
add comment="== p2p to Router-LSR" disabled=no interface=ether1
/routing ospf interface-template
add area=ospf-backbone comment="== p2p to Router-LSR" disabled=no networks=\
    172.20.20.0/30 type=ptp
/system identity
set name=Router-LER-R
/system note
set show-at-login=no
/tool romon
set enabled=yes
