# 2026-03-20 16:57:02 by RouterOS 7.16
# software id = 
#
/port
set 0 name=serial0
/routing isis instance
add afi=ip areas=49.0001 l1.redistribute=connected name=Router3-main-isis \
    system-id=0000.0000.0003
/ip address
add address=3.3.3.3 interface=lo network=3.3.3.3
add address=172.20.20.2/30 comment="== p2p to Router2" interface=ether1 \
    network=172.20.20.0
/routing isis interface-template
add comment="== p2p isis to Router2" instance=Router3-main-isis interfaces=\
    ether1 levels=l1 ptp
/system identity
set name=Router3
/system note
set show-at-login=no
/tool romon
set enabled=yes
