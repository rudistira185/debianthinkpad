MikroTik VRF v7 Lab

Implementasi VRF (Virtual Routing and Forwarding) pada MikroTik RouterOS v7 untuk isolasi routing dalam satu perangkat.

📌 Overview

VRF memungkinkan satu router menjalankan beberapa routing table terpisah, sehingga tiap network dapat berjalan secara independen tanpa saling mengganggu.


⚠️ Notes
VRF bekerja di Layer 3 (routing isolation)
Tidak ada komunikasi antar VRF secara default
Gunakan routing rule atau route leaking jika diperlukan

🚀 Use Cases
- Multi-tenant network
- ISP segmentation
- Lab simulasi jaringan kompleks