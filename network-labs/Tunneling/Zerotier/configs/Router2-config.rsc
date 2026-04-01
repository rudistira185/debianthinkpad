# 2026-04-01 16:07:48 by RouterOS 7.16
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
/ip address
add address=10.10.10.20/24 comment="== to virbr1" interface=ether1 network=\
    10.10.10.0
add address=3.3.3.3 interface=lo network=3.3.3.3
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
/ip route
add comment="== default route to internet" disabled=no distance=1 \
    dst-address=0.0.0.0/0 gateway=10.10.10.1 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
add comment="== route to router1 via zerotier-router1" disabled=yes distance=\
    1 dst-address=2.2.2.2/32 gateway=10.209.70.20 routing-table=main scope=30 \
    suppress-hw-offload=no target-scope=10
add disabled=no dst-address=10.209.70.0/24 gateway=10.10.10.1 routing-table=\
    main suppress-hw-offload=no
/system identity
set name=Router2
/system note
set show-at-login=no
/tool romon
set enabled=yes
