# 2026-04-01 05:38:12 by RouterOS 7.16
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
/interface wireguard
add listen-port=700 mtu=1420 name=wireguard-r2
/port
set 0 name=serial0
/interface wireguard peers
add allowed-address=20.20.20.1/32,1.1.1.1/32 endpoint-address=15.15.15.1 \
    endpoint-port=700 interface=wireguard-r2 name=to-r1 private-key=\
    "\"AHz2qdAUVg/UgsmvXbaLbHskudqyC6Hd+qgupjPuJkE=\"" public-key=\
    "BBAEtkL7PW9wZYn+UKklhPbN9YygpvCjyyZnUBxD1SI="
/ip address
add address=15.15.15.2/30 comment="=- p2p to Router1" interface=ether1 \
    network=15.15.15.0
add address=2.2.2.2 interface=lo network=2.2.2.2
add address=20.20.20.2/30 interface=wireguard-r2 network=20.20.20.0
/ip route
add disabled=no dst-address=1.1.1.1/32 gateway=20.20.20.1%wireguard-r2 \
    routing-table=main suppress-hw-offload=no
/system identity
set name=Router2
/system note
set show-at-login=no
/tool romon
set enabled=yes
