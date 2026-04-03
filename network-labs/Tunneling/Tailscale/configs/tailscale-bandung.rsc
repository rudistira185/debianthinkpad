# 2026-04-03 09:13:23 by RouterOS 7.22.1
# system id = yBDzm/WPo/O
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
add address=192.168.60.10/24 container-mac-address=10:17:6C:73:D3:54 dhcp=no \
    gateway=192.168.60.1 gateway6="" mac-address=10:17:6C:73:D3:53 name=\
    veth-tailscale-bandung
/container
add check-certificate=no cmd="tail -f /dev/null" dns=192.168.60.1 envlists=\
    tailscale-bandung interface=veth-tailscale-bandung layer-dir="" logging=\
    yes name=ubuntu-tailscale-bandung remote-image=tailscale/tailscale:latest \
    root-dir=/pcie1/container/ubuntu-tailscale-bandung workdir=/
/container config
set registry-url=https://registry-1.docker.io
/container envs
add key=TS_AUTHKEY list=tailscale-bandung value=\
    tskey-auth-kxt4wbLbZW11CNTRL-cFTrZSAukm9cqSTUPA7Em92zWL2qQJ4N
add key=TS_EXTRA_ARGS list=tailscale-bandung value=\
    "--hostname=mikrotik-jakarta --advertise-routes=3.3.3.3/32"
add key=TS_STATE_DIR list=tailscale-bandung value=/var/lib/tailscale
add key=TS_USERSPACE list=tailscale-bandung value=true
/interface bridge port
add bridge=bridge-container interface=veth-tailscale-bandung
/ip address
add address=20.20.20.20/24 comment="== to virbr2" interface=ether1 network=\
    20.20.20.0
add address=3.3.3.3 interface=lo network=3.3.3.3
add address=192.168.60.1/24 comment="== for container" interface=\
    bridge-container network=192.168.60.0
/ip dns
set allow-remote-requests=yes servers=8.8.8.8
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
add action=masquerade chain=srcnat out-interface=bridge-container \
    src-address=192.168.60.0/24
/ip route
add comment="== default route to internet" dst-address=0.0.0.0/0 gateway=\
    20.20.20.1
/system identity
set name=tailscale-bandung
/tool romon
set enabled=yes
