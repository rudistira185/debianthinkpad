# 2026-04-03 09:12:23 by RouterOS 7.22.1
# system id = 6Sd5fo8rSjH
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
add address=192.168.50.10/24 container-mac-address=70:DF:0D:B0:A5:EE dhcp=no \
    gateway=192.168.50.1 gateway6="" mac-address=70:DF:0D:B0:A5:ED name=\
    veth-ubuntu
/container
add check-certificate=no cmd="tail -f /dev/null" dns=192.168.50.1 envlists=\
    env_tailscale-jakarta interface=veth-ubuntu layer-dir="" logging=yes \
    name=tailscale-jakarta remote-image=tailscale/tailscale:latest root-dir=\
    /pcie1/container/ubuntu-tailscale workdir=/
/container config
set registry-url=https://registry-1.docker.io
/container envs
add key=TS_AUTHKEY list=env_tailscale-jakarta value=\
    tskey-auth-kxt4wbLbZW11CNTRL-cFTrZSAukm9cqSTUPA7Em92zWL2qQJ4N
add key=TS_EXTRA_ARGS list=env_tailscale-jakarta value=\
    "--hostname=mikrotik-jakarta --advertise-routes=2.2.2.2/32"
add key=TS_STATE_DIR list=env_tailscale-jakarta value=/var/lib/tailscale
add key=TS_USERSPACE list=env_tailscale-jakarta value=true
/interface bridge port
add bridge=bridge-container interface=veth-ubuntu
/ip address
add address=10.10.10.10/24 comment="== to virbr1" interface=ether1 network=\
    10.10.10.0
add address=2.2.2.2 interface=lo network=2.2.2.2
add address=192.168.50.1/24 comment="== for container" interface=\
    bridge-container network=192.168.50.0
/ip dns
set allow-remote-requests=yes servers=8.8.8.8
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
add action=masquerade chain=srcnat disabled=yes out-interface=\
    bridge-container src-address=192.168.50.0/24
/ip route
add comment="== default gateway for internet" dst-address=0.0.0.0/0 gateway=\
    10.10.10.1
/system identity
set name=tailscale-jakarta
/tool romon
set enabled=yes
