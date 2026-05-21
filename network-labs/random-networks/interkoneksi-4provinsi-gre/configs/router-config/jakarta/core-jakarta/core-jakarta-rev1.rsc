# 2026-05-21 16:08:17 by RouterOS 7.16
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
/interface gre
add allow-fast-path=no local-address=192.168.10.1 name=to-aceh \
    remote-address=192.168.10.4
add allow-fast-path=no local-address=192.168.10.1 name=to-bandung \
    remote-address=192.168.10.2
add allow-fast-path=no local-address=192.168.10.1 name=to-surabaya \
    remote-address=192.168.10.3
/port
set 0 name=serial0
/routing ospf instance
add disabled=no name=main-instance originate-default=always redistribute=\
    connected router-id=1.1.1.1
/routing ospf area
add disabled=no instance=main-instance name=main-area
/system logging action
set 3 remote=10.10.10.1 remote-port=10500 src-address=10.10.10.10
/ip address
add address=10.10.10.10/24 comment="== to isp1" interface=ether1 network=\
    10.10.10.0
add address=1.1.1.1 interface=lo network=1.1.1.1
add address=172.10.10.1/30 comment="== to jakarta-r1" interface=ether2 \
    network=172.10.10.0
add address=10.10.20.1/24 comment="== to sw-nocj" interface=ether7 network=\
    10.10.20.0
add address=172.15.15.1/30 comment="== to jakarta-r2" interface=ether3 \
    network=172.15.15.0
add address=192.168.10.1/24 comment="== to local-isp" interface=ether8 \
    network=192.168.10.0
add address=192.168.20.1 comment="== gre jakarta to bandung" interface=\
    to-bandung network=192.168.20.2
add address=192.168.20.1 comment="== gre jakarta to surabaya" interface=\
    to-surabaya network=192.168.20.3
add address=192.168.20.1 comment="== gre jakarta to aceh" interface=to-aceh \
    network=192.168.20.4
/ip dns
set allow-remote-requests=yes servers=8.8.8.8
/ip firewall address-list
add address=10.10.10.1 list=input-remote-accept
add address=172.10.10.0/30 list=input-ospf-accept
add address=10.10.20.0/24 list=input-dns-accept
add address=10.10.20.0/24 list=input-remote-accept
add address=172.15.15.0/30 list=input-ospf-accept
add address=172.10.10.0/30 list=input-dns-accept
add address=192.168.10.0/24 list=input-ipsec-accept
add address=192.168.20.0/24 list=input-ipsec-accept
/ip firewall filter
add action=accept chain=input comment="== router connection state" \
    connection-state=established,related
add action=drop chain=input connection-state=invalid
add action=accept chain=forward connection-state=established,related
add action=drop chain=forward connection-state=invalid
add action=accept chain=output connection-state=established,related
add action=drop chain=output connection-state=invalid
add action=accept chain=input comment="== input remote accept" dst-port=\
    1100,8110 in-interface=ether1 protocol=tcp src-address-list=\
    input-remote-accept
add action=accept chain=input comment="== input icmp accept" protocol=icmp
add action=accept chain=input comment="== input ospf" protocol=ospf \
    src-address-list=input-ospf-accept
add action=accept chain=input comment="== input dns" dst-port=53 protocol=tcp \
    src-address-list=input-dns-accept
add action=accept chain=input dst-port=53 protocol=udp src-address-list=\
    input-dns-accept
add action=accept chain=input comment="== input ntp" dst-port=123 \
    in-interface=ether1 protocol=udp
add action=accept chain=input comment="== input ipsec-gre" dst-port=500,4500 \
    in-interface=ether8 protocol=udp src-address-list=input-ipsec-accept
add action=accept chain=input in-interface=ether8 protocol=gre \
    src-address-list=input-ipsec-accept
add action=accept chain=input in-interface=ether8 protocol=ipsec-esp \
    src-address-list=input-ipsec-accept
add action=drop chain=input comment="-- drop all input"
add action=accept chain=forward comment="== forward access nocj" dst-address=\
    10.10.20.0/24 src-address=10.10.10.1
add action=drop chain=forward dst-address=10.10.20.0/24
add action=accept chain=forward comment="== allow all forward"
/ip firewall nat
add action=accept chain=srcnat comment="== accept core-jakarta to isp1 log" \
    dst-address=10.10.10.1 dst-port=10500 protocol=udp src-address=\
    172.10.10.0/30
add action=accept chain=srcnat comment="== accept jakarta-r2 to isp1 log" \
    dst-address=10.10.10.1 dst-port=10500 protocol=udp src-address=\
    172.15.15.0/30
add action=dst-nat chain=dstnat comment="== dstnat ssh/winbox to jakarta-r1" \
    dst-port=1200 in-interface=ether1 protocol=tcp src-address=10.10.10.1 \
    to-addresses=172.10.10.2 to-ports=1200
add action=dst-nat chain=dstnat dst-port=8120 protocol=tcp src-address=\
    10.10.10.1 to-addresses=172.10.10.2 to-ports=8120
add action=dst-nat chain=dstnat comment="== dstnat ssh/winbox to jakarta-r2" \
    dst-port=1300 in-interface=ether1 protocol=tcp src-address=10.10.10.1 \
    to-addresses=172.15.15.2 to-ports=1300
add action=dst-nat chain=dstnat dst-port=8130 protocol=tcp src-address=\
    10.10.10.1 to-addresses=172.15.15.2 to-ports=8130
add action=dst-nat chain=dstnat comment="== dstnat ssh/winbox to jakarta-r3" \
    dst-port=1400 in-interface=ether1 protocol=tcp src-address=10.10.10.1 \
    to-addresses=1.4.4.4 to-ports=1400
add action=dst-nat chain=dstnat dst-port=8140 protocol=tcp src-address=\
    10.10.10.1 to-addresses=1.4.4.4 to-ports=8140
add action=masquerade chain=srcnat comment="== srcnat all" out-interface=\
    ether1
/ip route
add comment="== to internet" dst-address=0.0.0.0/0 gateway=10.10.10.1
/ip service
set telnet disabled=yes
set ftp disabled=yes
set www disabled=yes
set ssh address=10.10.10.1/32,10.10.20.0/24 port=1100
set api disabled=yes
set winbox address=10.10.10.1/32 port=8110
set api-ssl disabled=yes
/ip ssh
set strong-crypto=yes
/routing ospf interface-template
add area=main-area comment="== to jakarta-r1" cost=20 disabled=no networks=\
    172.10.10.0/30 type=ptp
add area=main-area comment="== tyyo jakarta-r2" cost=30 disabled=no networks=\
    172.15.15.0/30 type=ptp
/system clock
set time-zone-autodetect=no time-zone-name=Asia/Jakarta
/system identity
set name=core-jakarta
/system logging
add action=remote topics=info
add action=remote topics=critical
add action=remote topics=warning
add action=remote topics=system
add action=remote topics=firewall
add action=remote topics=interface
add action=remote topics=system
add action=remote topics=error
add action=remote topics=account
add action=remote topics=write
/system note
set show-at-login=no
/system ntp client
set enabled=yes
/system ntp client servers
add address=0.id.pool.ntp.org
