# 2026-05-21 16:26:08 by RouterOS 7.16
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
/interface list
add name=input-ospf
/port
set 0 name=serial0
/routing ospf instance
add disabled=no name=main-instance redistribute=connected,ospf router-id=\
    1.2.2.2
/routing ospf area
add disabled=no instance=main-instance name=main-area
/system logging action
set 3 remote=10.10.10.1 remote-port=10500 src-address=172.10.10.2
/interface list member
add interface=ether1 list=input-ospf
add interface=ether2 list=input-ospf
/ip address
add address=1.2.2.2 interface=lo network=1.2.2.2
add address=172.10.10.2/30 comment="== to core-jakarta" interface=ether1 \
    network=172.10.10.0
add address=10.0.0.1/30 comment="== to jakarta-r3" interface=ether2 network=\
    10.0.0.0
/ip dns
set allow-remote-requests=yes servers=172.10.10.1
/ip firewall address-list
add address=10.10.10.1 list=input-router-accept
add address=172.10.10.0/30 list=input-ospf-accept
add address=10.0.0.0/30 list=input-ospf-accept
/ip firewall filter
add action=accept chain=input comment="== input connection state" \
    connection-state=established,related
add action=drop chain=input connection-state=invalid
add action=accept chain=forward connection-state=established,related
add action=drop chain=forward connection-state=invalid
add action=accept chain=output connection-state=established,related
add action=drop chain=output connection-state=invalid
add action=accept chain=input comment="== input router access" dst-port=\
    1200,8120 in-interface=ether1 protocol=tcp src-address-list=\
    input-router-accept
add action=accept chain=input comment="== icmp input" protocol=icmp
add action=accept chain=input comment="== input ospf " in-interface-list=\
    input-ospf protocol=ospf src-address-list=input-ospf-accept
add action=accept chain=input comment="== input ntp" dst-port=123 protocol=\
    udp
add action=drop chain=input comment="== drop all input"
/ip service
set telnet disabled=yes
set ftp disabled=yes
set www disabled=yes
set ssh address=10.10.10.1/32 port=1200
set api disabled=yes
set winbox address=10.10.10.1/32 port=8120
set api-ssl disabled=yes
/ip ssh
set strong-crypto=yes
/routing ospf interface-template
add area=main-area comment="== to core-jakarta" cost=20 disabled=no networks=\
    172.10.10.0/30 type=ptp
add area=main-area comment="== to jakarta-r3" cost=20 disabled=no networks=\
    10.0.0.0/30 type=ptp
/system clock
set time-zone-autodetect=no time-zone-name=Asia/Jakarta
/system identity
set name=jakarta-r1
/system logging
add action=remote topics=info
add action=remote topics=critical
add action=remote topics=account
add action=remote topics=interface
add action=remote topics=system
add action=remote topics=firewall
add action=remote topics=warning
add action=remote topics=write
add action=remote topics=script
add action=remote topics=error
add action=remote topics=ipsec
/system note
set show-at-login=no
/system ntp client
set enabled=yes
/system ntp client servers
add address=0.id.pool.ntp.org
