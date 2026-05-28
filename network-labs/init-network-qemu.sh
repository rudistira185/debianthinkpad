sudo cp -r .network-interface-systemd.service /etc/systemd/system/network-interface-systemd.service
sudo systemctl stop dnsmasq
sudo systemctl disable dnsmasq
sudo systemctl daemon-reload
sudo systemctl enable --now qemu-interfaces.service
