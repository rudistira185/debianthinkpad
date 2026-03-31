# 2026-03-31 13:03:22 by RouterOS 7.16
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
add name=pool-RT10 ranges=172.10.10.10-172.10.10.50
add name=pool-RT20 ranges=172.20.20.10-172.20.20.50
/port
set 0 name=serial0
/ppp profile
add local-address=172.10.10.1 name=pppoe-profile-rt10 remote-address=\
    pool-RT10
add local-address=172.20.20.1 name=pppoe-profile-rt20 remote-address=\
    pool-RT20
/interface pppoe-server server
add comment="== to rt10" default-profile=pppoe-profile-rt10 disabled=no \
    interface=ether2 service-name=pppoe-server-rt10
add comment="== to rt20" default-profile=pppoe-profile-rt20 disabled=no \
    interface=ether3 service-name=pppoe-server-rt20
/ip address
add address=10.10.10.10/24 comment="== to virbr1" interface=ether1 network=\
    10.10.10.0
add address=172.10.10.1/24 comment="== rt10" interface=ether2 network=\
    172.10.10.0
add address=172.20.20.1/24 comment="== rt20" interface=ether3 network=\
    172.20.20.0
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
/ip route
add disabled=no dst-address=0.0.0.0/0 gateway=10.10.10.1 routing-table=main \
    suppress-hw-offload=no
/ppp secret
add name=selena profile=pppoe-profile-rt10 service=pppoe
add name=kadita profile=pppoe-profile-rt20 service=pppoe
/system identity
set name=PPPoE-SERVER
/system note
set show-at-login=no
