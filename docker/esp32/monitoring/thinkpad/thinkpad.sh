#!/bin/bash

# --- KONFIGURASI ---
ESP_IP="172.25.25.71"
LIMIT_BAWAH=15
LIMIT_ATAS=80
INTERVAL=10
PUSHGATEWAY_URL="http://localhost:9091/metrics/job/thinkpad_stats"

# Warna Terminal
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

while true; do
    # 1. DATA BATERAI (T460s Dual Battery)
    B0=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 0)
    B1=$(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null || echo 0)
    TOTAL_BAT=$(( (B0 + B1) / 2 ))
    AC_STATUS=$(cat /sys/class/power_supply/AC*/online 2>/dev/null | head -n 1)

    # 2. DATA SUHU (Sesuai hasil audit sebelumnya)
    CPU_TEMP=$(cat /sys/class/thermal/thermal_zone3/temp 2>/dev/null | sed 's/...$//' || echo 0)
    PCH_TEMP=$(cat /sys/class/thermal/thermal_zone1/temp 2>/dev/null | sed 's/...$//' || echo 0)
    AMB_TEMP=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null | sed 's/...$//' || echo 0)

    # 3. DATA KIPAS (ThinkPad Fan Speed)
    FAN_SPEED=$(awk '/speed:/ {print $2}' /proc/acpi/ibm/fan 2>/dev/null || echo 0)

    # 4. DATA TEGANGAN & USAGE
    VOLT_RAW=$(cat /sys/class/power_supply/BAT0/voltage_now 2>/dev/null || echo 0)
    VOLT=$(echo "scale=2; $VOLT_RAW / 1000000" | bc)
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')

    # 5. PUSH KE PROMETHEUS VIA PUSHGATEWAY
    cat <<EOF | curl --data-binary @- $PUSHGATEWAY_URL
# TYPE thinkpad_battery_total gauge
thinkpad_battery_total $TOTAL_BAT
# TYPE thinkpad_ac_status gauge
thinkpad_ac_status $AC_STATUS
# TYPE thinkpad_cpu_temp gauge
thinkpad_cpu_temp $CPU_TEMP
# TYPE thinkpad_pch_temp gauge
thinkpad_pch_temp $PCH_TEMP
# TYPE thinkpad_fan_speed gauge
thinkpad_fan_speed $FAN_SPEED
# TYPE thinkpad_battery_voltage gauge
thinkpad_battery_voltage $VOLT
# TYPE thinkpad_cpu_usage gauge
thinkpad_cpu_usage $CPU_USAGE
EOF

    # 6. LOGIKA RELAY
    TIME=$(date +"%H:%M:%S")
    if [ "$TOTAL_BAT" -le "$LIMIT_BAWAH" ] && [ "$AC_STATUS" -eq 0 ]; then
        curl -s "http://$ESP_IP/cm?cmnd=Power%20On" > /dev/null
        EVENT="${RED}LOW BAT (ON)${NC}"
    elif [ "$TOTAL_BAT" -ge "$LIMIT_ATAS" ] && [ "$AC_STATUS" -eq 1 ]; then
        curl -s "http://$ESP_IP/cm?cmnd=Power%20Off" > /dev/null
        EVENT="${GREEN}FULL BAT (OFF)${NC}"
    else
        EVENT="${CYAN}MONITORING${NC}"
    fi

    # 7. TAMPILAN DASHBOARD TERMINAL
    clear
    echo -e "${CYAN}=== THINKPAD T460S SYSTEM MONITOR ===${NC}"
    echo -e "Waktu      : $TIME"
    echo -e "Baterai    : $TOTAL_BAT% (B0:$B0% B1:$B1%)"
    echo -e "Status AC  : $([ "$AC_STATUS" -eq 1 ] && echo -e "${YELLOW}Charging${NC}" || echo -e "${BLUE}Discharging${NC}")"
    echo -e "-------------------------------------"
    echo -e "CPU Usage  : $CPU_USAGE %"
    echo -e "Fan Speed  : ${GREEN}$FAN_SPEED RPM${NC}"
    echo -e "Suhu CPU   : $CPU_TEMP °C"
    echo -e "Suhu PCH   : $PCH_TEMP °C"
    echo -e "Voltage    : $VOLT V"
    echo -e "-------------------------------------"
    echo -e "Action     : $EVENT"
    echo -e "${CYAN}=====================================${NC}"

    sleep "$INTERVAL"
done
