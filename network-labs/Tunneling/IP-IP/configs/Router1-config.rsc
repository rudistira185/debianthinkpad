# 2026-03-31 15:22:29 by RouterOS 7.16
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
/interface ipip
add allow-fast-path=no local-address=172.10.10.1 name=ipip-to-r2 \
    remote-address=172.10.10.2
/port
set 0 name=serial0
/ip address
add address=10.10.10.10/24 comment="==to virbr1" interface=ether1 network=\
    10.10.10.0
add address=172.10.10.1/30 comment="== p2p to Router2" interface=ether2 \
    network=172.10.10.0
add address=1.1.1.1 interface=lo network=1.1.1.1
/ip route
add dst-address=2.2.2.2/32 gateway=172.10.10.2
/system identity
set name=Router1
/system note
set show-at-login=no
/tool romon
set enabled=yes
