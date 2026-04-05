# 2026-04-05 07:52:13 by RouterOS 7.16
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
add address=172.10.10.2/30 comment="== p2p to dude-server" interface=ether1 \
    network=172.10.10.0
/snmp
set enabled=yes trap-version=2
/system identity
set name=router-left
/system note
set show-at-login=no
/tool romon
set enabled=yes
