# 2026-04-01 05:37:46 by RouterOS 7.16
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
add listen-port=700 mtu=1420 name=wireguard-r1
/port
set 0 name=serial0
/interface wireguard peers
add allowed-address=20.20.20.2/32,2.2.2.2/32 endpoint-address=15.15.15.2 \
    endpoint-port=700 interface=wireguard-r1 name=to-r2 private-key=\
    "\"EBs3tyoBH2EFHEYcJp9DRzD/Hf8ESwwZuGEtK/N7I0k=\"" public-key=\
    "jr4npLFzOFXgTNp77LYw/Wu7TJ49e3jEfcKdrt+kjkU="
/ip address
add address=10.10.10.10/24 comment="== to virbr1" interface=ether1 network=\
    10.10.10.0
add address=1.1.1.1 interface=lo network=1.1.1.1
add address=15.15.15.1/30 interface=ether2 network=15.15.15.0
add address=20.20.20.1/30 interface=wireguard-r1 network=20.20.20.0
/ip route
add disabled=no distance=1 dst-address=2.2.2.2/32 gateway=\
    20.20.20.2%wireguard-r1 routing-table=main scope=30 suppress-hw-offload=\
    no target-scope=10
/system identity
set name=Router1
/system note
set show-at-login=no
/tool romon
set enabled=yes
