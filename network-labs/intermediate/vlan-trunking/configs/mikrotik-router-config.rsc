# 2026-04-04 05:27:53 by RouterOS 7.16
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
/interface vlan
add interface=ether2 name=vlan10 vlan-id=10
add interface=ether2 name=vlan20 vlan-id=20
add interface=ether2 name=vlan30 vlan-id=30
/ip pool
add name=pool-vlan10 ranges=192.168.10.10-192.168.10.50
add name=pool-vlan20 ranges=192.168.20.10-192.168.20.50
add name=pool-vlan30 ranges=192.168.30.10-192.168.30.50
/ip dhcp-server
add address-pool=pool-vlan10 interface=vlan10 name=dhcp-vlan10
add address-pool=pool-vlan20 interface=vlan20 name=dhcp-vlan20
add address-pool=pool-vlan30 interface=vlan30 name=dhcp-vlan30
/port
set 0 name=serial0
/ip address
add address=10.10.10.10/24 comment="== to virbr1" interface=ether1 network=\
    10.10.10.0
add address=192.168.10.1/24 interface=vlan10 network=192.168.10.0
add address=192.168.20.1/24 interface=vlan20 network=192.168.20.0
add address=192.168.30.1/24 interface=vlan30 network=192.168.30.0
/ip dhcp-server network
add address=192.168.10.0/24 gateway=192.168.10.1
add address=192.168.20.0/24 gateway=192.168.20.1
add address=192.168.30.0/24 gateway=192.168.30.1
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
/ip route
add disabled=no dst-address=0.0.0.0/0 gateway=10.10.10.1 routing-table=main \
    suppress-hw-offload=no
/system identity
set name=mikrotik-router
/system note
set show-at-login=no
/tool romon
set enabled=yes
