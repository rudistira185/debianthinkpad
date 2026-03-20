# 2026-03-20 16:56:14 by RouterOS 7.16
# software id = 
#
/port
set 0 name=serial0
/routing isis instance
add afi=ip areas=49.0001 disabled=no l1.originate-default=always \
    .redistribute=connected,static name=main-isis system-id=0000.0000.0001
/ip address
add address=10.10.10.10/24 comment="to virbr1" interface=ether1 network=\
    10.10.10.0
add address=1.1.1.1 interface=lo network=1.1.1.1
add address=172.10.10.1/30 comment="== p2p to Router2" interface=ether2 \
    network=172.10.10.0
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
/ip route
add comment="default rout internet" dst-address=0.0.0.0/0 gateway=10.10.10.1
/routing isis interface-template
add comment="== isi p2p to Router2" instance=main-isis interfaces=ether2 \
    levels=l1 ptp
/system identity
set name=Router1
/system note
set show-at-login=no
/tool romon
set enabled=yes
