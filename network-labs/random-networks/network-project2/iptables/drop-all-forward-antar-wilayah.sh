#jakarta
sudo iptables -I FORWARD -s 10.10.10.0/24 -d 20.20.20.0/24 -j DROP
sudo iptables -I FORWARD -s 10.80.80.0/24 -d 20.20.20.0/24 -j DROP
sudo iptables -I INPUT -s 10.10.10.0/24 -d 20.20.20.1 -j DROP
sudo iptables -I INPUT -s 10.80.80.0/24 -d 20.20.20.1 -j DROP

#bandung
sudo iptables -I FORWARD -s 20.20.20.0/24 -d 10.10.10.0/24 -j DROP
sudo iptables -I FORWARD -s 20.80.80.0/24 -d 10.10.10.0/24 -j DROP
sudo iptables -I INPUT -s 20.20.20.0/24 -d 10.10.10.1 -j DROP
sudo iptables -I INPUT -s 20.80.80.0/24 -d 10.10.10.1 -j DROP
