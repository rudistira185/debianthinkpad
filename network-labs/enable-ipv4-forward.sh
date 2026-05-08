# Cek status (0 berarti mati, 1 berarti aktif)
cat /proc/sys/net/ipv4/ip_forward

# Jika 0, aktifkan sementara dengan:
sudo sysctl -w net.ipv4.ip_forward=1
