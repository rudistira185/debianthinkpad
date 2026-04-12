sudo apt update
sudo apt install -y pkg-config libgtk-3-dev build-essential qrencode ibgtk-3-dev build-essential gcc g++ pkg-config make hostapd libqrencode-dev libpng-dev
sudo apt install -y libqrencode-dev

sudo apt install hostapd dnsmasq iptables dnsmasq-base
git clone https://github.com/lakinduakash/linux-wifi-hotspot
cd linux-wifi-hotspot
make
sudo make install
