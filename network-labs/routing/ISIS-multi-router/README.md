#MikroTik IS-IS L1 Lab (3 Routers)

Overview

Proyek ini merupakan implementasi IS-IS (Intermediate System to Intermediate System) pada MikroTik RouterOS v7 dengan konfigurasi Level 1 (L1 only).

Semua router berada dalam satu area, sehingga seluruh router berbagi Link State Database (LSDB) yang sama dan dapat saling bertukar informasi routing secara penuh.


#Topology
R1 -------- R2 -------- R3


#IS-IS Design

Mode: Level 1 (L1 only)
Area: 49.0001
Semua router berada dalam area yang sama
Tidak menggunakan Level 2 (L2)