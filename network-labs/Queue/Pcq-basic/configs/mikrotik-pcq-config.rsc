# 2026-04-23 06:14:14 by RouterOS 7.16
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
/port
set 0 name=serial0
/queue tree
add comment="==eth2 upload" limit-at=10M max-limit=10M name=\
    eth2-upload-parrent parent=global
add comment="== eth2 download" limit-at=10M max-limit=10M name=\
    eth2-download-parrent parent=global
add comment="== eth3 upload" limit-at=5M max-limit=5M name=\
    eth3-parrent-upload parent=global
add comment="== eth3 download" limit-at=5M max-limit=5M name=\
    eth3-parrent-download parent=global
/queue type
add kind=pcq name=eth2-upload pcq-classifier=src-address,src-port
add kind=pcq name=eth2-download pcq-classifier=dst-address,dst-port
add kind=pcq name=eth3-upload pcq-classifier=src-address,src-port
add kind=pcq name=eth3-download pcq-classifier=dst-address,dst-port
/queue tree
add name=eth2-upload-child packet-mark=eth2-upload parent=eth2-upload-parrent \
    queue=eth2-upload
add name=eth2-download-child packet-mark=eth2-download parent=\
    eth2-download-parrent queue=eth2-download
add name=eth3-child-upload packet-mark=eth3-upload parent=eth3-parrent-upload \
    queue=eth3-upload
add name=eth3-child-download packet-mark=eth3-download parent=\
    eth3-parrent-download queue=eth3-download
/ip address
add address=10.10.10.10/24 comment="== to virbr0" interface=ether1 network=\
    10.10.10.0
add address=172.10.10.1/30 comment="to sw-r1" interface=ether2 network=\
    172.10.10.0
add address=172.20.20.1/30 comment="to sw-r2" interface=ether3 network=\
    172.20.20.0
/ip dns
set allow-remote-requests=yes servers=8.8.8.8
/ip firewall mangle
add action=mark-packet chain=forward comment="=== eth2 pcq" new-packet-mark=\
    eth2-upload out-interface=ether1 passthrough=no src-address=\
    172.10.10.0/30
add action=mark-packet chain=forward dst-address=172.10.10.0/30 in-interface=\
    ether1 new-packet-mark=eth2-download passthrough=no
add action=mark-packet chain=forward comment="== eth3 pcq" new-packet-mark=\
    eth3-upload out-interface=ether1 passthrough=no src-address=\
    172.20.20.0/30
add action=mark-packet chain=forward dst-address=172.20.20.0/30 in-interface=\
    ether1 new-packet-mark=eth3-download passthrough=no
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
/ip route
add distance=1 dst-address=0.0.0.0/0 gateway=10.10.10.1
/system identity
set name=mikrotik-pcq
/system note
set show-at-login=no
