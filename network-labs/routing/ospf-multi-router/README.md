#OSPF Multi Router Lab
Overview

Lab ini mendemonstrasikan dynamic routing menggunakan OSPF pada beberapa router.
Semua router berada pada backbone area (Area 0) dan bertukar informasi routing secara otomatis.

Lab dijalankan menggunakan GNS3 dan router MikroTik.


#Topology

PC1 --- R1 --- R2 --- R3 --- R4 --- PC2

LAN A berada di sisi Router1, LAN B berada di tengah Router2, dan LAN C berada di sisi Router3.
Semua network dipelajari secara otomatis melalui OSPF.


#IP Address Plan
LAN Networks

LAN A
192.168.10.0/24
LAN B
192.168.20.0/24
LAN C 
192.168.30.0/24


#Inter Router Links

R1 - R2
10.0.0.0/30
R2 - R3
20.0.0.0/30


#OSPF Configuration Concept

Setiap router:
- Membuat OSPF instance
- Menggunakan backbone area (0.0.0.0)
- Mengiklankan network masing-masing