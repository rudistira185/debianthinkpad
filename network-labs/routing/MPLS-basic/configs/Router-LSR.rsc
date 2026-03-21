# 2026-03-21 14:16:20 by RouterOS 7.16
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
add disabled=no name=main-ospf out-filter-chain=ospf-main-out redistribute=\
    connected router-id=2.2.2.2
/routing ospf area
add disabled=no instance=main-ospf name=ospf-backbone
/ip address
add address=10.10.10.10/24 comment="to virbr1" interface=ether1 network=\
    10.10.10.0
add address=2.2.2.2 interface=lo network=2.2.2.2
add address=172.10.10.1/30 comment="== p2p to Router-LER-L" interface=ether2 \
    network=172.10.10.0
add address=172.20.20.1/30 comment="== p2p ro Router-LER-R" interface=ether3 \
    network=172.20.20.0
/mpls ldp
add comment="== mian ldp" disabled=no lsr-id=2.2.2.2 transport-addresses=\
    2.2.2.2 use-explicit-null=yes
/mpls ldp interface
add comment="== p2p to Router-LER-L" disabled=no interface=ether2
add comment="== p2p to Router-LER-R" disabled=no interface=ether3
/routing filter rule
add chain=ospf-main-out disabled=no rule=\
    "if (dst in 10.10.10.0/24) {reject;}\
    \naccept"
/routing ospf interface-template
add area=ospf-backbone comment="== p2p to Router-LER-L" disabled=no networks=\
    172.10.10.0/30 type=ptp
add area=ospf-backbone comment="== p2p to Router-LER-R" disabled=no networks=\
    172.20.20.0/30 type=ptp
/system identity
set name=Router-LSR
/system note
set show-at-login=no
/tool romon
set enabled=yes
