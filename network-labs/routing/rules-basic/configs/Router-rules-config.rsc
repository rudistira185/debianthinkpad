# 2026-03-22 18:45:35 by RouterOS 7.16
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
/routing table
add disabled=no fib name=isp1
add disabled=no fib name=isp2
/ip address
add address=10.10.10.10/24 comment="to virbr1" interface=ether1 network=\
    10.10.10.0
add address=20.20.20.20/24 comment="to virbr2" interface=ether2 network=\
    20.20.20.0
add address=192.168.10.1/24 comment="== to sw-LAN1" interface=ether3 network=\
    192.168.10.0
add address=192.168.20.1/24 comment="== to sw-LAN2" interface=ether4 network=\
    192.168.20.0
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
add action=masquerade chain=srcnat out-interface=ether2
/ip route
add disabled=no dst-address=0.0.0.0/0 gateway=10.10.10.1 routing-table=isp1 \
    suppress-hw-offload=no
add disabled=no distance=2 dst-address=0.0.0.0/0 gateway=20.20.20.1 \
    routing-table=isp2 suppress-hw-offload=no
/routing rule
add action=lookup-only-in-table comment="== LAN1 out to isp1" disabled=no \
    interface=ether3 src-address=192.168.10.0/24 table=isp1
add action=lookup-only-in-table comment="== LAN2 out to isp2" disabled=no \
    interface=ether4 src-address=192.168.20.0/24 table=isp2
/system identity
set name=Router-rules
/system note
set show-at-login=no
