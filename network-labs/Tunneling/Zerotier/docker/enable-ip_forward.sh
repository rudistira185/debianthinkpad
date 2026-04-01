sudo sysctl -w net.ipv4.ip_forward=1

# ganti wlp4s0 menjadi interface yang mengarah ke internet
sudo iptables -t nat -A POSTROUTING -s 172.20.20.0/24 -o wlp4s0 -j MASQUERADE