# to jakarta-r1 via core-jakarta
sudo ip route add 172.10.10.0/30 via 10.10.10.10

# to jakarta-r2 via core-jakarta
sudo ip route add 172.15.15.0/30 via 10.10.10.10

#to jakarta-r3 via core-jakarta
sudo ip route add 10.0.0.0/30 via 10.10.10.10
