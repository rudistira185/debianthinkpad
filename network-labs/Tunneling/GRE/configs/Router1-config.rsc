# 2026-03-31 17:34:55 by RouterOS 7.16
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
add allow-fast-path=no local-address=172.10.10.1 name=to-r2 remote-address=\
    172.10.10.2
/port
set 0 name=serial0
/routing ospf instance
add disabled=no name=main redistribute=connected router-id=1.1.1.1
/routing ospf area
add disabled=no instance=main name=ospf-backbone
/ip address
add address=10.10.10.10/24 comment="== to virbr1" interface=ether1 network=\
    10.10.10.0
add address=1.1.1.1 interface=lo network=1.1.1.1
add address=172.10.10.1/30 comment="== p2p to Router2" interface=ether2 \
    network=172.10.10.0
add address=50.50.50.1/30 interface=to-r2 network=50.50.50.0
/routing ospf interface-template
add area=ospf-backbone comment="== to r2" disabled=no interfaces=to-r2 type=\
    ptp
/system identity
set name=Router1
/system note
set show-at-login=no
/tool romon
set enabled=yes
