# 2026-03-31 15:22:38 by RouterOS 7.16
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
add allow-fast-path=no local-address=172.10.10.2 name=ipi-to-r2 \
    remote-address=172.10.10.1
/port
set 0 name=serial0
/ip address
add address=172.10.10.2/30 comment="== p2p to Router1" interface=ether1 \
    network=172.10.10.0
add address=2.2.2.2 interface=lo network=2.2.2.2
/ip route
add dst-address=1.1.1.1/32 gateway=172.10.10.1
/system identity
set name=Router2
/system note
set show-at-login=no
/tool romon
set enabled=yes
