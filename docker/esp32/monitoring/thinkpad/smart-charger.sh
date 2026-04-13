#!/bin/bash

# === KONFIGURASI ===
ESP32_IP="172.25.25.71"
RELAY_INDEX="2"
INTERVAL=5

# === AREA TESTING ===
LOWER_LIMIT=20
UPPER_LIMIT=21

# Warna Terminal
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' 

echo -e "${CYAN}=== SMART CHARGER THINKPAD (GNOME ENGINE) ===${NC}"
echo "--------------------------------------------------------"

while true; do
    # 1. Ambil angka mentah (desimal) dari upower (contoh: 14.4613)
    RAW_AVG=$(upower -i $(upower -e | grep 'DisplayDevice') | grep "percentage" | awk '{print $2}' | tr -d '%')
    
    # Jika gagal mendapat data, set ke 0 agar script tidak crash
    RAW_AVG=${RAW_AVG:-0}

    # 2. Bulatkan ke angka bulat terdekat (integer) sesuai standar GNOME
    AVG=$(printf "%.0f" "$RAW_AVG")

    NOW_TIME=$(date +"%H:%M:%S")

    # LOGIKA (sekarang memakai angka bulat)
    if [ "$AVG" -le "$LOWER_LIMIT" ]; then
        STATUS_MSG="${RED}[ON] Baterai $AVG% - Menyalakan Charger...${NC}"
        curl -s "http://$ESP32_IP/cm?cmnd=Power$RELAY_INDEX%20ON" > /dev/null
    elif [ "$AVG" -ge "$UPPER_LIMIT" ]; then
        STATUS_MSG="${GREEN}[OFF] Baterai $AVG% - Mematikan Charger...${NC}"
        curl -s "http://$ESP32_IP/cm?cmnd=Power$RELAY_INDEX%20OFF" > /dev/null
    else
        STATUS_MSG="${YELLOW}[-] Baterai $AVG% - Monitoring...${NC}"
    fi

    # Menampilkan angka bulat dan desimal di terminal agar kamu bisa memantaunya
    echo -e "[$NOW_TIME] Status Real: ${CYAN}$AVG%${NC} (Raw: $RAW_AVG%) | $STATUS_MSG"

    sleep $INTERVAL
done