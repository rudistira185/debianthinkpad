🌐 GRE Tunnel MikroTik v7 (Generic Routing Encapsulation)

📖 Deskripsi
Proyek ini menjelaskan implementasi GRE (Generic Routing Encapsulation) pada MikroTik RouterOS v7 untuk menghubungkan dua jaringan berbeda melalui internet (site-to-site tunneling).

GRE memungkinkan berbagai jenis trafik (termasuk routing protocol seperti OSPF/BGP) untuk ditransmisikan melalui jaringan publik seolah-olah berada dalam satu jaringan lokal.

🎯 Tujuan
- Membuat tunnel antar dua router MikroTik
- Menghubungkan dua LAN melalui internet
- Mendukung routing dinamis (OSPF/BGP) di atas tunnel
- Simulasi jaringan point-to-point virtual
- 🧠 Konsep Dasar

GRE bekerja dengan cara:

- Encapsulation (membungkus paket asli)
- Pengiriman melalui jaringan publik (internet)
- Decapsulation di sisi tujuan

Sehingga koneksi terlihat seperti direct link (point-to-point).


📊 Kelebihan & Kekurangan

✅ Kelebihan
- Konfigurasi sederhana
- Mendukung routing dinamis
- Fleksibel untuk berbagai skenario jaringan
❌ Kekurangan
- Tidak terenkripsi
- Bergantung pada koneksi internet stabil
- Bisa diblokir oleh jaringan tertentu