sudo iptables -I INPUT -i isp1 ! -d 10.10.10.1 -j DROP
sudo iptables -I INPUT -i isp2 ! -d 20.20.20.1 -j DROP
sudo iptables -I INPUT -i isp3 ! -d 30.30.30.1 -j DROP
sudo iptables -I INPUT -i isp4 ! -d 40.40.40.1 -j DROP

sudo iptables -I INPUT -i isp1-failover ! -d 10.80.80.1 -j DROP
sudo iptables -I INPUT -i isp2-failover ! -d 20.80.80.1 -j DROP
sudo iptables -I INPUT -i isp3-failover ! -d 30.80.80.1 -j DROP
sudo iptables -I INPUT -i isp4-failover ! -d 40.80.80.1 -j DROP
sudo iptables -I INPUT -i isp5-failover ! -d 50.80.80.1 -j DROP
