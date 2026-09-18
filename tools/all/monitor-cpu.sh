#!/bin/bash

# Menangkap sinyal Ctrl+C agar script berhenti dengan bersih
trap "clear; echo 'Monitoring dihentikan.'; exit 0" SIGINT

while true; do
    # 1. Ambil Suhu CPU
    if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
        temp_raw=$(cat /sys/class/thermal/thermal_zone0/temp)
        temp_c=$((temp_raw / 1000))
    else
        temp_c="N/A"
    fi

    # 2. Ambil Kecepatan Fan
    if [ -f /proc/acpi/ibm/fan ]; then
        fan_speed=$(awk '/speed:/ {print $2}' /proc/acpi/ibm/fan)
        fan_rpm="${fan_speed} RPM"
    else
        fan_rpm="Tidak terdeteksi"
    fi

    # 3. Ambil Data Gabungan Dua Baterai (Sinkron dengan GNOME Shell)
    # GNOME membaca data gabungan ini dari UPower
    upower_info=$(upower -i /org/freedesktop/UPower/devices/DisplayDevice 2>/dev/null)
    
    if [ -n "$upower_info" ]; then
        bat_percent=$(echo "$upower_info" | awk '/percentage:/ {print $2}')
        bat_state=$(echo "$upower_info" | awk '/state:/ {print $2}')
        
        # Percantik tampilan status baterai
        case "$bat_state" in
            charging)      bat_status="Charging ⚡" ;;
            discharging)   bat_status="Discharging 🔋" ;;
            fully-charged) bat_status="Full 🔌" ;;
            *)             bat_status="${bat_state^}" ;;
        esac
    else
        bat_percent="N/A"
        bat_status="N/A"
    fi

    # 4. Kalkulasi CPU Usage (Ambil data awal)
    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
    prev_idle=$idle
    prev_total=$((user + nice + system + idle + iowait + irq + softirq + steal))

    # Jeda 1 detik (juga berfungsi sebagai refresh rate)
    sleep 1 

    # 5. Kalkulasi CPU Usage (Ambil data akhir)
    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
    curr_idle=$idle
    curr_total=$((user + nice + system + idle + iowait + irq + softirq + steal))

    diff_idle=$((curr_idle - prev_idle))
    diff_total=$((curr_total - prev_total))

    if [ $diff_total -eq 0 ]; then
        cpu_usage=0
    else
        cpu_usage=$((100 * (diff_total - diff_idle) / diff_total))
    fi

    # 6. Render Tampilan
    clear
    echo "====================================="
    echo "    ThinkPad T460s System Monitor    "
    echo "====================================="
    echo " CPU Usage : ${cpu_usage}%"
    echo " CPU Temp  : ${temp_c}°C"
    echo " Fan Speed : ${fan_rpm}"
    echo " Battery   : ${bat_percent} (${bat_status})"
    echo "====================================="
    echo " Tekan Ctrl+C untuk keluar"
done
