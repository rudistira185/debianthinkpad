📡 IPIP Tunneling di MikroTik RouterOS v7
🧠 Apa itu IPIP Tunneling?

IPIP (IP over IP) adalah metode tunneling Layer 3 (L3) yang digunakan untuk membungkus (encapsulate) paket IP ke dalam paket IP lainnya.

Dengan IPIP, dua jaringan yang terpisah secara geografis dapat terhubung seolah-olah berada dalam satu jaringan yang sama melalui internet.

🔍 Cara Kerja
- Paket dari jaringan lokal dikirim ke router.
- Router melakukan encapsulation (membungkus paket IP ke dalam IP baru).
- Paket dikirim melalui jaringan publik (internet).
- Router tujuan melakukan decapsulation (membuka paket).
- Paket diteruskan ke jaringan lokal tujuan.


Fungsi Utama
🔗 Menghubungkan dua jaringan berbeda (site-to-site)
🌐 Membuat tunnel antar router melalui internet
🧭 Mendukung routing statis maupun dinamis (OSPF, BGP)


⚠️ Kelebihan & Kekurangan

✅ Kelebihan
- Konfigurasi sederhana
- Overhead rendah
- Cocok untuk routing antar site

❌ Kekurangan
- Tidak ada enkripsi (tidak aman)
- Tidak ada autentikasi
- Rentan terhadap sniffing