# 2026-03-11 04:24:34 by RouterOS 7.16
# software id = 
#
/port
set 0 name=serial0
/ip address
add address=10.0.0.1/30 comment="to Router2" interface=ether2 network=\
    10.0.0.0
add address=192.168.10.1/24 comment="to PC1" interface=ether1 network=\
    192.168.10.0
add address=10.10.10.10/24 comment="remote from virbr1" interface=ether8 \
    network=10.10.10.0
/ip route
add comment="to PC2" dst-address=192.168.20.0/24 gateway=10.0.0.2
add comment="route to Pc3" dst-address=192.168.30.0/24 gateway=10.0.0.2
/system identity
set name=Router1
/system note
set show-at-login=no
/tool romon
set enabled=yes
