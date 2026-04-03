Berdasarkan hasil pengujian, terdapat beberapa kendala teknis (limitasi) pada arsitektur Container di MikroTik yang menyebabkan trafik Site-to-Site tidak stabil atau mengalami Request Time Out (RTO):

1. Keterbatasan Kernel & TUN Device
Tailscale bekerja optimal di level kernel Linux. Di dalam MikroTik Container, akses ke /dev/net/tun sangat terbatas. Meskipun interface tailscale0 muncul, sistem sering kali gagal menyematkan IP Address atau melakukan routing paket secara native (Kernel Space).

2. Isu Routing Loop (Redirect Host)
Karena Container menggunakan default gateway yang mengarah kembali ke MikroTik (Bridge), sering terjadi fenomena Routing Loop. Paket yang seharusnya masuk ke terowongan Tailscale justru dilempar kembali ke MikroTik oleh Container karena tabel rute di dalam Linux Container tidak ter-update secara otomatis oleh flag --accept-routes.

3. Iptables & Forwarding Caps
MikroTik Container memiliki batasan capabilities (NET_ADMIN). Perintah seperti iptables -t nat -A POSTROUTING terkadang tidak tereksekusi dengan sempurna di beberapa versi RouterOS, sehingga paket yang datang dari MikroTik (LAN) tidak bisa di-NAT/Masquerade saat keluar menuju Tailnet.


jadi project ini 1/2 berhasil, gagalkarena fitur kernel dalam container mikrotik terbatas.