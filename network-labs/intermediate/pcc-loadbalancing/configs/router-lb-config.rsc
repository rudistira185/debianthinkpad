# 2026-04-04 08:15:31 by RouterOS 7.16
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
add name=lan
/port
set 0 name=serial0
/queue simple
add disabled=yes max-limit=10M/10M name=limit-sip1 target=ether1
add disabled=yes max-limit=10M/10M name=limit-sip2 target=ether2
/routing table
add disabled=no fib name=isp1
add disabled=no fib name=isp2
/interface list member
add interface=ether3 list=lan
add interface=ether4 list=lan
/ip address
add address=10.10.10.10/24 comment="== to isp1" interface=ether1 network=\
    10.10.10.0
add address=20.20.20.20/24 comment="== to isp2" interface=ether2 network=\
    20.20.20.0
add address=192.168.10.1/24 comment="== to sw1" interface=ether3 network=\
    192.168.10.0
add address=192.168.20.1/24 comment="== to sw2" interface=ether4 network=\
    192.168.20.0
/ip dns
set allow-remote-requests=yes servers=8.8.8.8
/ip firewall mangle
add action=mark-connection chain=prerouting comment="== mark_conn_lan" \
    connection-mark=no-mark dst-address-type=!local in-interface-list=lan \
    new-connection-mark=mark_conn_to-isp1 passthrough=yes \
    per-connection-classifier=both-addresses-and-ports:2/0
add action=mark-connection chain=prerouting connection-mark=no-mark \
    dst-address-type=!local in-interface-list=lan new-connection-mark=\
    mark_conn_to-sip2 passthrough=yes per-connection-classifier=\
    both-addresses-and-ports:2/1
add action=mark-routing chain=prerouting connection-mark=mark_conn_to-isp1 \
    in-interface-list=lan new-routing-mark=isp1 passthrough=no
add action=mark-routing chain=prerouting connection-mark=mark_conn_to-sip2 \
    in-interface-list=lan new-routing-mark=isp2 passthrough=no
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
add action=masquerade chain=srcnat out-interface=ether2
/ip route
add disabled=no dst-address=0.0.0.0/0 gateway=10.10.10.1 routing-table=isp1 \
    suppress-hw-offload=no
add disabled=no distance=2 dst-address=0.0.0.0/0 gateway=20.20.20.1 \
    routing-table=isp2 scope=30 suppress-hw-offload=no target-scope=10
add disabled=no dst-address=192.168.10.0/24 gateway=192.168.10.1 \
    routing-table=isp1 suppress-hw-offload=no
add disabled=no distance=1 dst-address=192.168.20.0/24 gateway=192.168.20.1 \
    routing-table=isp2 scope=30 suppress-hw-offload=no target-scope=10
/routing rule
add action=lookup disabled=no routing-mark=isp1 table=isp1
add action=lookup disabled=no routing-mark=isp2 table=isp2
/system identity
set name=router-lb
/system note
set show-at-login=no
