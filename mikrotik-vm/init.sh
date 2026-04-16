#!/bin/bash

# Pastikan script dijalankan dengan sudo
if [ "$EUID" -ne 0 ]; then
  echo "Error: Tolong jalankan script ini menggunakan sudo."
  exit 1
fi

# ==========================================
# VARIABEL KONFIGURASI
# ==========================================
WIFI_IF="wlp4s0"
MIKROTIK_WAN_SUBNET="172.90.90.10/24" # Sesuai IP rule kamu
MIKROTIK_LAN_IP="172.95.95.10"
HOST_LAN_IF="mikrotik2"

echo "Memulai konfigurasi routing..."

# ==========================================
# 1. AMBIL GATEWAY WI-FI DINAMIS
# ==========================================
GW_WIFI=$(ip route show default dev $WIFI_IF | awk '{print $3}')

if [ -z "$GW_WIFI" ]; then
  echo "Error: Default gateway di $WIFI_IF tidak ditemukan. Pastikan Wi-Fi konek."
  exit 1
fi
echo "[OK] Gateway Wi-Fi ditemukan: $GW_WIFI"

# ==========================================
# 2. AKTIFKAN FORWARDING & NAT
# ==========================================
sysctl -w net.ipv4.ip_forward=1 > /dev/null

# Cek agar rule MASQUERADE tidak ganda jika script di-run berulang
iptables -t nat -C POSTROUTING -o $WIFI_IF -j MASQUERADE 2>/dev/null || iptables -t nat -A POSTROUTING -o $WIFI_IF -j MASQUERADE
echo "[OK] IP Forwarding & NAT diaktifkan."

# ==========================================
# 3. SETUP POLICY-BASED ROUTING (TABLE 100)
# ==========================================
# Bersihkan rule & route lama di table 100 untuk mencegah error "File exists"
ip route flush table 100
ip rule del from $MIKROTIK_WAN_SUBNET table 100 2>/dev/null

# Tambahkan route dinamis dan rule baru
ip route add default via $GW_WIFI dev $WIFI_IF table 100
ip rule add from $MIKROTIK_WAN_SUBNET table 100
echo "[OK] PBR Table 100 dikonfigurasi ke gateway $GW_WIFI."

# ==========================================
# 4. ALIHKAN TRAFIK HOST KE MIKROTIK
# ==========================================
# Hapus default route lama
ip route del default 2>/dev/null

# Tambahkan default route baru ke MikroTik
ip route add default via $MIKROTIK_LAN_IP dev $HOST_LAN_IF
echo "[OK] Default route host dipindah ke $MIKROTIK_LAN_IP ($HOST_LAN_IF)."

echo "=========================================="
echo "Selesai! Host sekarang internetan lewat MikroTik."
