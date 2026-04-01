#WireGuard MikroTik v7

Dokumen ini menjelaskan konsep dan arsitektur penggunaan WireGuard pada MikroTik RouterOS v7 tanpa membahas langkah konfigurasi.

📌 Apa itu WireGuard

WireGuard adalah protokol VPN modern berbasis UDP yang beroperasi pada layer 3 (network layer). Di MikroTik v7, WireGuard diimplementasikan sebagai interface virtual yang memungkinkan routing terenkripsi antar node.


Karakteristik utama:
- Menggunakan kriptografi modern (Curve25519, ChaCha20, Poly1305)
- Berbasis public/private key (tanpa username/password)
- Stateless dan ringan
- Overhead rendah → performa tinggi


🧠 Arsitektur di MikroTik

WireGuard di MikroTik terdiri dari:

1. Interface
Interface virtual yang bertindak sebagai tunnel endpoint.

2. Peer
Representasi node remote yang berkomunikasi melalui tunnel.

3. Allowed Address
Komponen penting yang berfungsi sebagai:
- Routing selector (menentukan trafik mana yang masuk tunnel)
- Access control (membatasi trafik dari peer)


🔄 Cara Kerja
- Paket dari jaringan lokal masuk ke routing table
- Jika cocok dengan allowed-address peer → diarahkan ke interface WireGuard
- Paket dienkripsi
- Dikirim melalui UDP ke endpoint peer
- Peer menerima, decrypt, lalu forward ke tujuan

WireGuard tidak memiliki sesi seperti VPN tradisional—trafik akan langsung diproses ketika ada paket.


⚙️ Model Topologi

WireGuard fleksibel dan dapat digunakan dalam berbagai topologi:
- Site-to-Site
- Menghubungkan dua jaringan LAN secara langsung.
- Satu node pusat (server) dengan banyak client.


🚀 Kelebihan
- Performa tinggi (lebih cepat dibanding IPsec/OpenVPN)
- Konfigurasi sederhana secara konsep
- Codebase kecil → lebih mudah diaudit
- Stabil untuk mobile dan jaringan tidak stabil


⚠️ Keterbatasan
- Tidak ada dynamic peer discovery
- Tidak ada manajemen user bawaan
- Routing harus didefinisikan eksplisit


🧪 Use Case Umum
- VPN antar cabang (site-to-site)
- Akses remote ke jaringan internal
- Backbone jaringan antar server


📌 Kesimpulan

WireGuard pada MikroTik v7 adalah solusi VPN modern yang mengedepankan performa, kesederhanaan, dan keamanan. Dengan pendekatan berbasis key dan routing eksplisit, WireGuard sangat cocok untuk berbagai skenario jaringan skala kecil hingga besar.