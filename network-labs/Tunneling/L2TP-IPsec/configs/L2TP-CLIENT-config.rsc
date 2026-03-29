# 2026-03-29 09:04:15 by RouterOS 7.16
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
/interface l2tp-client
add connect-to=172.10.10.1 disabled=no name=l2tp-out1 use-ipsec=yes user=\
    client1
/port
set 0 name=serial0
/ip address
add address=172.10.10.2/29 interface=ether1 network=172.10.10.0
/system identity
set name=L2TP-CLIENT
/system note
set show-at-login=no
/tool romon
set enabled=yes
