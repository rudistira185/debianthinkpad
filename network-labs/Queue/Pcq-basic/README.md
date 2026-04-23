# PCQ Tree on MikroTik RouterOS v7
Overview

PCQ Tree adalah metode pengaturan bandwidth pada MikroTik RouterOS v7 yang mengombinasikan algoritma Per Connection Queue (PCQ) dengan struktur Queue Tree berbasis hirarki. Pendekatan ini memungkinkan distribusi bandwidth yang adil sekaligus terstruktur berdasarkan parent-child queue.

Core Concepts
1. Per Connection Queue (PCQ)
- PCQ adalah algoritma queueing yang secara otomatis membagi bandwidth secara merata ke setiap koneksi atau IP address berdasarkan classifier tertentu.


Karakteristik:
- Fair usage (setiap client mendapat porsi setara)
- Tidak perlu definisi manual per user
- Mendukung classifier seperti src-address atau dst-address


2. Queue Tree
- Queue Tree adalah mekanisme hierarchical queueing berbasis HTB (Hierarchical Token Bucket) yang memungkinkan pembagian bandwidth secara bertingkat.

Karakteristik:
- Mendukung parent-child relationship
- Dapat diterapkan pada interface tertentu atau global
- Lebih fleksibel dibanding Simple Queue untuk topologi kompleks


3. PCQ Tree
- PCQ Tree adalah implementasi Queue Tree yang menggunakan PCQ sebagai queue type pada leaf queue.


Struktur umum:
Global/Interface
└── Parent Queue (limit total bandwidth)
    ├── Child Queue (download - PCQ)
    └── Child Queue (upload - PCQ)


Functional Behavior
- Parent queue menentukan total bandwidth limit
- Child queue menggunakan PCQ untuk membagi bandwidth secara otomatis
- Trafik diklasifikasikan menggunakan firewall mangle
- Setiap client mendapatkan bandwidth yang proporsional tanpa konfigurasi manual per IP


Limitations
- Membutuhkan pemahaman mangle dan packet flow
- Debugging lebih kompleks dibanding simple queue
- Overhead CPU lebih tinggi pada trafik besar


Typical Use Cases
- ISP skala kecil hingga menengah
- Hotspot publik
- Jaringan kampus atau kantor
- Network dengan banyak client dinamis