# 2026-04-04 05:28:14 by RouterOS 7.16
# software id = 
#
/interface bridge
add name=bridge-router vlan-filtering=yes
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
/interface bridge port
add bridge=bridge-router interface=ether1
add bridge=bridge-router interface=ether2 pvid=10
add bridge=bridge-router interface=ether3 pvid=20
add bridge=bridge-router interface=ether4 pvid=30
/interface bridge vlan
add bridge=bridge-router comment="== to vlan10" tagged=ether1 untagged=ether2 \
    vlan-ids=10
add bridge=bridge-router comment="== to vlan20" tagged=ether1 untagged=ether3 \
    vlan-ids=20
add bridge=bridge-router comment="== to valn30" tagged=ether1 untagged=ether4 \
    vlan-ids=30
/system identity
set name=mikrotik-sw-managed
/system note
set show-at-login=no
/tool romon
set enabled=yes
