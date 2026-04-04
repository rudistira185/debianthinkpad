#PCC Load Balancing MikroTik v7
📌 Deskripsi

PCC (Per Connection Classifier) adalah metode load balancing pada MikroTik RouterOS v7 yang bekerja dengan cara membagi trafik berdasarkan koneksi (connection-based), bukan per-packet.

Teknik ini memungkinkan distribusi trafik ke beberapa gateway (multi-WAN) tanpa merusak sesi koneksi (session persistence), sehingga cocok untuk kebutuhan jaringan produksi.

🧠 Konsep Dasar

PCC menggunakan mekanisme hashing terhadap parameter koneksi seperti:

- Source Address (src-address)
- Destination Address (dst-address)
- Source Port (src-port)
- Destination Port (dst-port)

Hasil hashing digunakan untuk menentukan jalur (gateway) yang akan digunakan oleh suatu koneksi.


Mode PCC:

1. both-addresses

Menggunakan kombinasi:
- src-ip + dst-ip

Karakteristik:
- Stabil (1 koneksi ke 1 tujuan selalu lewat ISP yang sama)
- Cocok untuk aplikasi sensitif (banking, login, game)
- Distribusi trafik kurang merata

2. both-addresses-and-ports

Menggunakan kombinasi:
- src-ip + dst-ip + src-port + dst-port

Karakteristik:
- Lebih granular (per koneksi/flow)
- Distribusi trafik lebih merata
- Potensi masalah pada aplikasi tertentu yang sensitif terhadap perubahan IP


🔄 Alur Kerja PCC
- Packet masuk ke router
- Connection tracking mendeteksi koneksi baru
- Mangle rule melakukan klasifikasi (PCC)
- Router memberi connection-mark
- Routing decision berdasarkan routing-mark
- Packet dikirim ke gateway yang sesuai


🧪 Contoh Skema

Misal terdapat 2 ISP:

ISP1 → Gateway 10.10.10.1
ISP2 → Gateway 20.20.20.1

PCC akan membagi koneksi menjadi 2 bagian:

Bucket 0 → ISP1
Bucket 1 → ISP2