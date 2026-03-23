# 2026-03-23 13:24:31 by RouterOS 7.16
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
/ip vrf
add comment="== for LAN2" interfaces=ether3 name=vrf-b
add comment="== for LAN1" interfaces=ether2 name=vrf-a
/port
set 0 name=serial0
/ip address
add address=10.10.10.10/24 comment="== to virbr1" interface=ether1 network=\
    10.10.10.0
add address=192.168.10.1/24 comment="== to sw-LAN1" interface=ether2 network=\
    192.168.10.0
add address=192.168.20.1/24 comment="== to sw-LAN2" interface=ether3 network=\
    192.168.20.0
/ip firewall mangle
add action=mark-connection chain=prerouting comment=\
    "== mark connection vrf-a" disabled=yes in-interface=ether2 \
    new-connection-mark=conn_vrf-a passthrough=yes
add action=mark-routing chain=prerouting connection-mark=conn_vrf-a disabled=\
    yes new-routing-mark=vrf-a passthrough=no
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
/ip route
add disabled=no distance=1 dst-address=0.0.0.0/0 gateway=10.10.10.1 \
    routing-table=main scope=30 suppress-hw-offload=no target-scope=10
/system identity
set name=Router-vrf
/system note
set show-at-login=no
