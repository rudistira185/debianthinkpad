# 2026-03-29 09:03:45 by RouterOS 7.16
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
/ip pool
add name=pool-l2tp ranges=192.168.10.0/24
/port
set 0 name=serial0
/ppp profile
add local-address=172.10.10.1 name=l2tp-profile-main remote-address=pool-l2tp
/interface l2tp-server server
set default-profile=l2tp-profile-main enabled=yes use-ipsec=yes
/ip address
add address=10.10.10.10/24 comment="to virbr1" interface=ether1 network=\
    10.10.10.0
add address=172.10.10.1/29 interface=ether2 network=172.10.10.0
/ppp secret
add name=client1 profile=l2tp-profile-main service=l2tp
/system identity
set name=L2TP-SERVER
/system note
set show-at-login=no
/tool romon
set enabled=yes
