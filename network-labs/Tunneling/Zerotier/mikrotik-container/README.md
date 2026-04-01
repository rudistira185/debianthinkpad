container ini dijalankan pada mikrotik, karena keterbatasan kernel pada mikrotik (tidak ada driver /dev/net/tun)

jadi implemetasi zerotier pada mikrotik menggunakan container tidak berhasil, maka dari itu saya menjalankan zerotier pada host linux dengan menggunakan docker compose (ini sebagai gateway)