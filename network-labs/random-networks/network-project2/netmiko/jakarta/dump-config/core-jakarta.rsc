# 2026-07-17 09:21:23 by RouterOS 7.22.1
# system id = 6Gvn9GbpC/A
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no name=eth1.to-isp1
set [ find default-name=ether2 ] disable-running-check=no name=\
    eth2.to-isp1-failover
set [ find default-name=ether3 ] disable-running-check=no name=\
    eth3.to-netmiko
set [ find default-name=ether4 ] disable-running-check=no name=\
    eth4.to-jakarta-r1
set [ find default-name=ether5 ] disable-running-check=no name=\
    eth5.to-jakarta-r2
set [ find default-name=ether8 ] disable-running-check=no name=\
    eth8.to-bridge-interconnection
set [ find default-name=ether6 ] disable-running-check=no
set [ find default-name=ether7 ] disable-running-check=no
/interface list
add name=input-remote
/routing ospf instance
add name=main-instance originate-default=always out-filter-chain=\
    out.ospf-main router-id=1.1.1.1
/routing ospf area
add disabled=no instance=main-instance name=main-area
/routing table
add fib name=isp1
add fib name=isp1-failover
/interface list member
add interface=eth1.to-isp1 list=input-remote
add interface=eth2.to-isp1-failover list=input-remote
add interface=eth3.to-netmiko list=input-remote
/ip address
add address=10.10.10.10/24 interface=eth1.to-isp1 network=10.10.10.0
add address=10.90.90.2/29 interface=eth3.to-netmiko network=10.90.90.0
add address=1.1.1.1 interface=lo network=1.1.1.1
add address=10.1.1.1/30 interface=eth4.to-jakarta-r1 network=10.1.1.0
add address=10.2.2.1/30 interface=eth5.to-jakarta-r2 network=10.2.2.0
/ip dns
set allow-remote-requests=yes servers=8.8.8.8
/ip firewall address-list
add address=10.10.10.1 list=input-remote
add address=10.80.80.1 list=input-remote
add address=10.90.90.1 list=input-api
add address=10.90.90.1 list=input-remote
add address=10.1.1.0/30 list=input-ospf
add address=10.2.2.0/30 list=input-ospf
add address=172.10.10.0/24 list=input-ebgp
/ip firewall filter
add action=accept chain=input comment="== INPUT CONNTRACK ==" \
    connection-state=established,related
add action=drop chain=input connection-state=invalid
add action=accept chain=input comment="== INPUT ICMP ==" protocol=icmp
add action=accept chain=input comment="== INPUT REMOTE ==" dst-port=2110,8110 \
    in-interface-list=input-remote protocol=tcp src-address-list=input-remote
add action=accept chain=input comment="== INPUT API ==" dst-port=8728,8729 \
    protocol=tcp src-address-list=input-api
add action=accept chain=input comment="== INPUT OSPF ==" protocol=ospf \
    src-address-list=input-ospf
add action=accept chain=input comment="== INPUT EBGP ==" dst-port=179 \
    protocol=tcp src-address-list=input-ebgp
add action=drop chain=input comment="== INPUT DROP ALL =="
/ip route
add check-gateway=ping comment="== default gateway via isp1 ==" distance=1 \
    dst-address=0.0.0.0/0 gateway=10.10.10.1 routing-table=main
add comment="== default gateway via isp1-failover" distance=2 dst-address=\
    0.0.0.0/0 gateway=10.80.80.1 routing-table=main
add check-gateway=ping comment="== route isp1 ==" distance=3 dst-address=\
    0.0.0.0/0 gateway=10.10.10.1 routing-table=isp1
add comment="== route isp1-failover" distance=4 dst-address=0.0.0.0/0 \
    gateway=10.80.80.1 routing-table=isp1-failover
/ip service
set telnet disabled=yes
set www disabled=yes
set ssh address=10.10.10.1/32,10.80.80.1/32,10.90.90.1/32 port=2110
set winbox address=10.10.10.1/32,10.80.80.1/32 port=8110
set api address=10.90.90.1/32 disabled=yes
set api-ssl disabled=yes
/routing filter rule
add chain=out.ospf-main rule="if (dst == 10.10.10.0/24) {reject}\
    \nif (dst == 10.80.80.0/24) {reject}\
    \nif (dst == 10.90.90.0/29) {reject}\
    \n accept;"
/routing ospf interface-template
add area=main-area comment="== ospf.main-to-jakarta-r1" cost=20 interfaces=\
    eth4.to-jakarta-r1 networks=10.1.1.0/30 type=ptp
add area=main-area comment="== ospf.main-to-jakarta-r2" cost=30 interfaces=\
    eth5.to-jakarta-r2 networks=10.2.2.0/30 type=ptp
/system identity
set name=core-jakarta
