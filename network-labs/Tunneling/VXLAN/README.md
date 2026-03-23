VXLAN Lab MikroTik v7 (2 Router)
🧭 Deskripsi

Lab ini menunjukkan implementasi VXLAN sederhana menggunakan MikroTik RouterOS v7 di GNS3.

Tujuannya adalah menghubungkan dua lokasi berbeda agar berada dalam satu jaringan Layer 2 (LAN yang sama), meskipun dipisahkan oleh jaringan IP (Layer 3).

🏗️ Topologi
Router1
LAN: 192.168.10.1/24
WAN: 172.10.10.1/30

Router2
LAN: 192.168.10.2/24
WAN: 172.10.10.2/30

VXLAN
VNI: 10
Transport: UDP 8472
Network: 192.168.10.0/24


🧠 Konsep Dasar

- VXLAN memungkinkan pembuatan jaringan Layer 2 di atas jaringan Layer 3.
- Underlay → jaringan IP (WAN)
- Overlay → jaringan LAN (hasil VXLAN)

Dengan konfigurasi ini, kedua router akan bertindak seolah-olah terhubung ke satu switch yang sama.


🎯 Tujuan Lab

- Memahami konsep VXLAN (overlay network)
- Menghubungkan dua LAN menjadi satu subnet
- Memahami perbedaan Layer 2 dan Layer 3
- Simulasi jaringan skala data center secara sederhana


Materi yang Dipelajari

- VXLAN (Virtual Extensible LAN)
- Overlay & Underlay Network
- Layer 2 Extension
- Bridging pada MikroTik