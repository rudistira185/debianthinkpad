# 2026-04-01 16:07:27 by RouterOS 7.22.1
# system id = TS32ZGl5ILI
#
/interface bridge
add name=bridge-container
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
set [ find default-name=ether5 ] disable-running-check=no
set [ find default-name=ether6 ] disable-running-check=no
set [ find default-name=ether7 ] disable-running-check=no
set [ find default-name=ether8 ] disable-running-check=no
/interface veth
add address=50.50.50.20/24 container-mac-address=04:77:10:39:E0:6B dhcp=no \
    gateway=50.50.50.1 gateway6="" mac-address=04:77:10:39:E0:6A name=\
    veth-alpine
add address=50.50.50.10/24 container-mac-address=6E:BF:D2:08:BF:C6 dhcp=no \
    gateway=50.50.50.1 gateway6="" mac-address=6E:BF:D2:08:BF:C5 name=\
    veth-ubuntu
/container
add check-certificate=no cmd="tail -f /dev/null" dns=50.50.50.1 hostname=\
    ubuntu interface=veth-ubuntu layer-dir="" logging=yes mountlists=\
    "mount /dev/net/tun" name=ubuntu:22.04 remote-image=ubuntu:22.04 \
    root-dir=/pcie1/container/ubuntu
add check-certificate=no cmd="tail -f /dev/null" dns=50.50.50.1 hostname=\
    alpine interface=veth-alpine layer-dir="" logging=yes name=alpine \
    remote-image=alpine:latest root-dir=/pcie1/container/alpine workdir=/
/container config
set registry-url=https://registry-1.docker.io
/container mounts
add dst=/dev/net/tun list="mount /dev/net/tun" src=/dev/net/tun
/interface bridge port
add bridge=bridge-container interface=veth-ubuntu
add bridge=bridge-container interface=veth-alpine
/ip address
add address=10.10.10.10/24 comment="== to vvirbr1" interface=ether1 network=\
    10.10.10.0
add address=50.50.50.1/24 comment="== for container" interface=\
    bridge-container network=50.50.50.0
add address=2.2.2.2 interface=lo network=2.2.2.2
/ip dns
set allow-remote-requests=yes servers=8.8.8.8
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
/ip route
add comment="default gateway via virbr1" disabled=no distance=1 dst-address=\
    0.0.0.0/0 gateway=10.10.10.1 routing-table=main scope=30 target-scope=10
add comment="== route to router2 via zerotier-router2" disabled=yes distance=\
    1 dst-address=3.3.3.3/32 gateway=10.209.70.60 routing-table=main scope=30 \
    target-scope=10
add disabled=no dst-address=10.209.70.0/24 gateway=10.10.10.1 routing-table=\
    main
/system identity
set name=Router1
/tool romon
set enabled=yes
