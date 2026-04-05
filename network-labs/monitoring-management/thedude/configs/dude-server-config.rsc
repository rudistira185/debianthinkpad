# 2026-04-05 07:49:54 by RouterOS 7.22.1
# system id = ScamLfgh6BH
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
/dude
set enabled=yes
/ip address
add address=10.10.10.10/24 comment="== to virbr1" interface=ether1 network=\
    10.10.10.0
add address=172.10.10.1/30 comment="== p2p to router-left" interface=ether2 \
    network=172.10.10.0
add address=172.20.20.1/30 comment="== p2p to router-right" interface=ether3 \
    network=172.20.20.0
/ip dns
set allow-remote-requests=yes servers=8.8.8.8
/ip route
add disabled=no dst-address=0.0.0.0/0 gateway=10.10.10.1 routing-table=main
/snmp
set enabled=yes trap-version=2
/system identity
set name=dude-server
/tool romon
set enabled=yes
