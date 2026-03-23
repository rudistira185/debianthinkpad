# 2026-03-23 16:04:22 by RouterOS 7.16
# software id = 
#
/interface bridge
add name=bridge-vxlan1
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
set [ find default-name=ether5 ] disable-running-check=no
set [ find default-name=ether6 ] disable-running-check=no
set [ find default-name=ether7 ] disable-running-check=no
set [ find default-name=ether8 ] disable-running-check=no
/interface vxlan
add local-address=172.10.10.1 mac-address=7E:FF:1F:04:96:CB name=vxlan1 port=\
    8472 vni=10 vrf=main vteps-ip-version=ipv4
/port
set 0 name=serial0
/interface bridge port
add bridge=bridge-vxlan1 interface=ether2
add bridge=bridge-vxlan1 interface=vxlan1
/interface vxlan vteps
add comment="== to router2" interface=vxlan1 remote-ip=172.10.10.2
/ip address
add address=10.10.10.10/24 comment="to virbr1" interface=ether8 network=\
    10.10.10.0
add address=1.1.1.1 interface=lo network=1.1.1.1
add address=172.10.10.1/30 comment="== p2p to Router2" interface=ether1 \
    network=172.10.10.0
add address=192.168.10.1/24 comment="== to sw-LAN" interface=ether2 network=\
    192.168.10.0
/system identity
set name=Router1
/system note
set show-at-login=no
/tool romon
set enabled=yes
