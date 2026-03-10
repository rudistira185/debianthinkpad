# Static Routing Basic Lab

## Topology
Dua MikroTik terkoneksi melalui Static Routing.

## IP Plan

Router1
- ether1: 192.168.10.1/24
- ether2: 10.0.0.1/30

Router2
- ether1: 192.168.20.1/24
- ether2: 10.0.0.2/30

## Static Route

Router1

/ip route
add dst-address=192.168.20.0/24 gateway=10.0.0.2

Router2

/ip route
add dst-address=192.168.10.0/24 gateway=10.0.0.1

## Result

Antar client berhasil saling ping.
