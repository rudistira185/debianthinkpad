# 2026-03-18 15:52:48 by RouterOS 7.16
# software id = 
#
/port
set 0 name=serial0
/routing table
add disabled=no fib name=isp2
add disabled=no fib name=isp1
/ip address
add address=10.10.10.10/24 comment="to ISP1" interface=ether1 network=\
    10.10.10.0
add address=20.20.20.20/24 comment="to ISP2" interface=ether2 network=\
    20.20.20.0
add address=192.168.10.1/24 comment="== to sw-LAN-A" interface=ether3 \
    network=192.168.10.0
add address=192.168.20.1/24 comment="== to sw-LAN-B" interface=ether4 \
    network=192.168.20.0
/ip firewall mangle
add action=mark-connection chain=prerouting comment="== mark conn_isp1" \
    new-connection-mark=conn_isp1 passthrough=yes src-address=192.168.10.0/24
add action=mark-connection chain=prerouting comment="== mark  conn_isp2" \
    new-connection-mark=conn_isp2 passthrough=yes src-address=192.168.20.0/24
add action=mark-routing chain=prerouting connection-mark=conn_isp1 \
    new-routing-mark=isp1 passthrough=no
add action=mark-routing chain=prerouting connection-mark=conn_isp2 \
    new-routing-mark=isp2 passthrough=no
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
add action=masquerade chain=srcnat out-interface=ether2
/ip route
add check-gateway=ping comment="== route isp1" disabled=no distance=2 \
    dst-address=0.0.0.0/0 gateway=10.10.10.1 routing-table=isp1 scope=30 \
    suppress-hw-offload=no target-scope=10
add check-gateway=ping comment="== route isp2" disabled=no distance=3 \
    dst-address=0.0.0.0/0 gateway=20.20.20.1 routing-table=isp2 scope=30 \
    suppress-hw-offload=no target-scope=10
add comment="== default route" disabled=no distance=1 dst-address=0.0.0.0/0 \
    gateway=10.10.10.1 routing-table=main suppress-hw-offload=no
add disabled=no dst-address=192.168.10.0/24 gateway=ether3 routing-table=isp1 \
    suppress-hw-offload=no
add disabled=no dst-address=192.168.20.0/24 gateway=ether4 routing-table=isp2 \
    suppress-hw-offload=no
/system note
set show-at-login=no
