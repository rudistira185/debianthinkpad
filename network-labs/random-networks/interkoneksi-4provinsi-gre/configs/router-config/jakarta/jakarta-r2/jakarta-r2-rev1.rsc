# 2026-05-21 09:29:13 by RouterOS 7.16
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
/routing ospf instance
add disabled=no name=main-instance redistribute=connected,ospf router-id=\
    1.3.3.3
/routing ospf area
add disabled=no instance=main-instance name=main-area
/system logging action
set 3 remote=10.10.10.1 remote-port=10500 src-address=172.15.15.2
/ip address
add address=172.15.15.2/30 comment="== to core-jakarta" interface=ether1 \
    network=172.15.15.0
add address=1.3.3.3 interface=lo network=1.3.3.3
add address=15.0.0.1/30 comment="== to jakarta-r3" interface=ether2 network=\
    15.0.0.0
/ip firewall address-list
add address=172.15.15.0/30 list=input-ospf-accept
add address=10.10.10.1 list=input-router-accept
add address=15.0.0.0/30 list=input-ospf-accept
/ip firewall filter
add action=accept chain=input comment="== router connection state" \
    connection-state=established,related
add action=drop chain=input connection-state=invalid
add action=accept chain=forward connection-state=established,related
add action=drop chain=forward connection-state=invalid
add action=accept chain=output connection-state=established,related
add action=drop chain=output connection-state=invalid
add action=accept chain=input comment="== input router remote" dst-port=\
    1300,8130 in-interface=ether1 protocol=tcp src-address-list=\
    input-router-accept
add action=accept chain=input comment="== input icmp" protocol=icmp
add action=accept chain=input comment="== input ospf" protocol=ospf \
    src-address-list=input-ospf-accept
add action=drop chain=input comment="== input drop all"
/ip service
set telnet disabled=yes
set ftp disabled=yes
set www disabled=yes
set ssh address=10.10.10.1/32 port=1300
set api disabled=yes
set winbox address=10.10.10.1/32 port=8130
set api-ssl disabled=yes
/ip ssh
set strong-crypto=yes
/routing ospf interface-template
add area=main-area comment="== to core-jakarta" cost=30 disabled=no networks=\
    172.15.15.0/30 type=ptp
add area=main-area comment="== to jakarta-r3" cost=30 disabled=no networks=\
    15.0.0.0/30 type=ptp
/system identity
set name=jakarta-r2
/system logging
add action=remote topics=system
add action=remote topics=error
add action=remote topics=warning
add action=remote topics=critical
/system note
set show-at-login=no
