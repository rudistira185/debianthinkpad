# 2026-03-11 04:25:22 by RouterOS 7.16
# software id = 
#
/port
set 0 name=serial0
/ip address
add address=192.168.20.1/24 comment="to PC2" interface=ether1 network=\
    192.168.20.0
add address=10.0.0.2/30 comment="to Router1" interface=ether2 network=\
    10.0.0.0
add address=20.0.0.1/30 comment="to Router3" interface=ether3 network=\
    20.0.0.0
/ip route
add comment="Route to PC1" dst-address=192.168.10.0/24 gateway=10.0.0.1
add comment="route to PC3" dst-address=192.168.30.0/24 gateway=20.0.0.2
/system identity
set name=Router2
/system note
set show-at-login=no
/tool romon
set enabled=yes
