#!/usr/bin/env bash

set -e

# Harus dijalankan sebagai root
if [[ $EUID -ne 0 ]]; then
    echo "Jalankan dengan sudo."
    exit 1
fi

# Pastikan libvirt berjalan
systemctl enable --now libvirtd

# FORMAT SEKARANG: "nama|IP_Gateway|Prefix_CIDR|MAC"
interfaces=(
  "isp1|10.10.10.1|24|52:54:00:10:10:01"
  "isp2|20.20.20.1|24|52:54:00:20:20:01"
  "isp3|30.30.30.1|24|52:54:00:30:30:01"
  "isp4|40.40.40.1|24|52:54:00:40:40:01"
  "isp1-failover|10.80.80.1|24|52:54:00:10:80:01"
  "isp2-failover|20.80.80.1|24|52:54:00:20:80:01"
  "isp3-failover|30.80.80.1|24|52:54:00:30:80:01"
  "isp4-failover|40.80.80.1|24|52:54:00:40:80:01"
  
  # Contoh selipin subnet /29 (Netmask 255.255.255.248 | Total 8 IP, 6 Usable)
  #"isp5-custom|50.50.50.1|29|52:54:00:50:50:01"
  "isp1-ansible|10.90.90.1|29|52:54:00:10:90:01"  
  # Contoh kalau butuh point-to-point /30
  #"isp6-p2p|60.60.60.1|30|52:54:00:60:60:01"
)

echo "=== Memeriksa dan Membuat Network NAT ==="

for entry in "${interfaces[@]}"; do
    # Mengubah variabel 'mask' menjadi 'prefix'
    IFS="|" read -r name ip prefix mac <<< "$entry"

    # Cek apakah network sudah ada dan aktif
    if virsh net-info "$name" >/dev/null 2>&1; then
        if virsh net-info "$name" | grep -i "Active:" | grep -qw "yes"; then
            echo "Network '$name' sudah ada dan aktif. Skip..."
            continue
        else
            echo "Network '$name' ada tapi tidak aktif. Mengaktifkan..."
            virsh net-start "$name" || true
            virsh net-autostart "$name" || true
            continue
        fi
    fi

    xml=$(mktemp)

# Perhatikan bagian <ip>, kita ganti netmask='' menjadi prefix=''
cat > "$xml" <<EOF
<network>
  <name>${name}</name>

  <forward mode='nat'/>

  <bridge name='${name}' stp='on' delay='0'/>

  <mac address='${mac}'/>

  <ip address='${ip}' prefix='${prefix}'/>
</network>
EOF

    echo "Creating $name (Subnet /$prefix)..."

    virsh net-define "$xml"
    virsh net-start "$name"
    virsh net-autostart "$name"

    rm -f "$xml"
done

echo
echo "===== DONE ====="
virsh net-list --all
