#!/usr/bin/env bash

set -e

# Harus dijalankan sebagai root
if [[ $EUID -ne 0 ]]; then
    echo "Jalankan dengan sudo."
    exit 1
fi

# Pastikan libvirt berjalan
systemctl enable --now libvirtd

interfaces=(
  "isp1|10.10.10.1|255.255.255.0|52:54:00:10:10:01"
  "isp2|20.20.20.1|255.255.255.0|52:54:00:20:20:01"
  "isp3|30.30.30.1|255.255.255.0|52:54:00:30:30:01"
  "isp4|40.40.40.1|255.255.255.0|52:54:00:40:40:01"
  "isp1-failover|10.80.80.1|255.255.255.0|52:54:00:10:80:01"
  "isp2-failover|20.80.80.1|255.255.255.0|52:54:00:20:80:01"
  "isp3-failover|30.80.80.1|255.255.255.0|52:54:00:30:80:01"
  "isp4-failover|40.80.80.1|255.255.255.0|52:54:00:40:80:01"
)

echo "=== Menghapus network lama ==="

for entry in "${interfaces[@]}"; do
    IFS="|" read -r name ip mask mac <<< "$entry"

    virsh net-destroy "$name" >/dev/null 2>&1 || true
    virsh net-undefine "$name" >/dev/null 2>&1 || true
done

echo "=== Membuat network NAT ==="

for entry in "${interfaces[@]}"; do
    IFS="|" read -r name ip mask mac <<< "$entry"

    xml=$(mktemp)

cat > "$xml" <<EOF
<network>
  <name>${name}</name>

  <forward mode='nat'/>

  <bridge name='${name}' stp='on' delay='0'/>

  <mac address='${mac}'/>

  <ip address='${ip}' netmask='${mask}'/>
</network>
EOF

    echo "Creating $name..."

    virsh net-define "$xml"
    virsh net-start "$name"
    virsh net-autostart "$name"

    rm -f "$xml"
done

echo
echo "===== DONE ====="
virsh net-list --all
