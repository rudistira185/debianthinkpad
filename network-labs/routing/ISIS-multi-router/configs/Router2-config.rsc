# 2026-03-20 16:56:39 by RouterOS 7.16
# software id = 
#
/port
set 0 name=serial0
/routing isis instance
add afi=ip areas=49.0001 disabled=no l1.redistribute=connected name=main-isis \
    system-id=0000.0000.0002
/ip address
add address=2.2.2.2 interface=lo network=2.2.2.2
add address=172.10.10.2/30 comment="== p2p to Router1" interface=ether1 \
    network=172.10.10.0
add address=172.20.20.1/30 comment="== p2p to Router3" interface=ether2 \
    network=172.20.20.0
/routing isis interface-template
add comment="== isi p2p to Router1" instance=main-isis interfaces=ether1 \
    levels=l1 ptp
add comment="== p2p isis to Router3" instance=main-isis interfaces=ether2 \
    levels=l1 ptp
/system identity
set name=Router2
/system note
set show-at-login=no
/tool romon
set enabled=yes
