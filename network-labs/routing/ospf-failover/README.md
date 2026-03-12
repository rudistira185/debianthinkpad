Failover-OSPF (4 Router)
Overview

Project ini mendemonstrasikan implementasi dynamic routing menggunakan OSPF pada empat router.

Semua router berada pada backbone area (Area 0) dan saling bertukar informasi routing secara otomatis.

Tujuan utama lab:

memahami neighbor discovery pada OSPF
memahami pertukaran routing table
memahami jalur routing alternatif (failover)
memahami desain jaringan point-to-point antar router


#Network Design

Setiap link antar router menggunakan network point-to-point (/30).
Inter-Router Links

R1 - R2 : 10.0.0.0/30
R1 - R3 : 20.0.0.0/30
R2 - R4 : 30.0.0.0/30
R3 - R4 : 40.0.0.0/30


#Router Addressing

R1: eth1 - 10.0.0.1/30
    eth2 - 20.0.0.1/30

R2: eth1 - 10.0.0.2/30
    eth2 - 30.0.0.1/30

R3: eth2 - 20.0.0.2/30
    eth3 - 40.0.0.1/30

R4: eth3 - 40.0.0.2/30
    eth2 - 30.0.0.2/30