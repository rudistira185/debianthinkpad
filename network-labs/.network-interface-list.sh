#!/bin/bash

# Pastikan script dijalankan dengan hak akses root/sudo
if [ "$EUID" -ne 0 ]; then
  echo "Error: Harap jalankan script ini menggunakan sudo atau sebagai root."
  exit 1
fi

# Daftar interface dan IP dalam format "NAMA_INTERFACE|IP_ADDRESS/SUBNET"
INTERFACES=(
    "isp1|10.10.10.1/24"
    "isp2|20.20.20.1/24"
    "isp3|30.30.30.1/24"
    "isp4|40.40.40.1/24"
    "isp5|50.50.50.1/24"
    "isp1-failover|10.80.80.1/24"
    "isp2-failover|20.80.80.1/24"
    "isp3-failover|30.80.80.1/24"
    "isp4-failover|40.80.80.1/24"
    "isp5-failover|50.80.80.1/24"
)

echo "=== Pengecekan Awal Interface ==="

# PRE-FLIGHT CHECK: Mengecek seluruh daftar interface
# Jika ada SATU saja yang sudah eksis, script langsung dibatalkan.
for entry in "${INTERFACES[@]}"; do
    IFACE="${entry%%|*}"
    if ip link show "$IFACE" > /dev/null 2>&1; then
        echo "[ABORT] Interface '$IFACE' terdeteksi sudah ada di sistem."
        echo "Script dihentikan, tidak ada eksekusi konfigurasi jaringan."
        exit 0
    fi
done

echo "=== Memulai Konfigurasi Jaringan QEMU (CachyOS) ==="

# Mengaktifkan IP Forwarding kernel
echo "[*] Memastikan IP Forwarding kernel aktif..."
sysctl -w net.ipv4.ip_forward=1 > /dev/null

# Pastikan direktori bridge.conf untuk QEMU/KVM tersedia
mkdir -p /etc/qemu
touch /etc/qemu/bridge.conf

# Eksekusi pembuatan interface karena sudah lolos pengecekan
for entry in "${INTERFACES[@]}"; do
    IFACE="${entry%%|*}"
    IP_CIDR="${entry##*|}"
    NETWORK=$(echo "$IP_CIDR" | sed 's/\.[0-9]*\//.0\//')

    # Membuat MAC Address statis menggunakan md5sum
    HASH=$(echo -n "$IFACE" | md5sum)
    MAC_ADDR=$(echo "52:54:00:${HASH:0:2}:${HASH:2:2}:${HASH:4:2}")

    echo "[CREATE] Membuat interface '$IFACE' ($MAC_ADDR) dengan IP $IP_CIDR..."

    # 1. Buat bridge baru dengan MAC Address statis
    ip link add name "$IFACE" address "$MAC_ADDR" type bridge

    # 2. Pasang IP Address
    ip addr add "$IP_CIDR" dev "$IFACE"

    # 3. Aktifkan interface
    ip link set dev "$IFACE" up

    # 4. Terapkan aturan iptables (NAT/Masquerade & Forwarding)
    # CachyOS biasanya menggunakan iptables-nft, perintahnya tetap sama
    iptables -t nat -C POSTROUTING -s "$NETWORK" ! -d "$NETWORK" -j MASQUERADE >/dev/null 2>&1 || \
    iptables -t nat -A POSTROUTING -s "$NETWORK" ! -d "$NETWORK" -j MASQUERADE

    iptables -C FORWARD -i "$IFACE" -j ACCEPT >/dev/null 2>&1 || \
    iptables -A FORWARD -i "$IFACE" -j ACCEPT

    iptables -C FORWARD -o "$IFACE" -m state --state RELATED,ESTABLISHED -j ACCEPT >/dev/null 2>&1 || \
    iptables -A FORWARD -o "$IFACE" -m state --state RELATED,ESTABLISHED -j ACCEPT

    # 5. Daftarkan ke whitelist QEMU
    if ! grep -q "allow $IFACE" /etc/qemu/bridge.conf 2>/dev/null; then
        echo "allow $IFACE" >> /etc/qemu/bridge.conf
    fi

    echo "    -> Berhasil membuat '$IFACE'."
done

echo "=== Semua proses selesai! ==="
