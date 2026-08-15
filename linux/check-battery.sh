#!/bin/bash

BAT0="/sys/class/power_supply/BAT0"
BAT1="/sys/class/power_supply/BAT1"

if [ ! -d "$BAT0" ] || [ ! -d "$BAT1" ]; then
    echo "Error: Baterai tidak lengkap/tidak ditemukan!"
    exit 1
fi

while true; do
    clear
    echo "=========================================="
    echo "       THINKPAD DUAL BATTERY MONITOR      "
    echo "=========================================="
    echo "Waktu: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "------------------------------------------"

    # --- BAT0 ---
    e_now0=$(cat "$BAT0/energy_now" 2>/dev/null || cat "$BAT0/charge_now" 2>/dev/null || echo 0)
    e_full0=$(cat "$BAT0/energy_full" 2>/dev/null || cat "$BAT0/charge_full" 2>/dev/null || echo 1)
    stat0=$(cat "$BAT0/status" 2>/dev/null || echo "Unknown")
    cap0=$(( e_now0 * 100 / e_full0 ))
    
    pow0_raw=$(cat "$BAT0/power_now" 2>/dev/null || echo "0")
    pow0=$(awk "BEGIN {print $pow0_raw/1000000}")

    echo "  [BAT0 - Internal]"
    echo "  Capacity : $cap0%"
    echo "  Status   : $stat0"
    echo "  Power    : ${pow0} W"
    echo "------------------------------------------"

    # --- BAT1 ---
    e_now1=$(cat "$BAT1/energy_now" 2>/dev/null || cat "$BAT1/charge_now" 2>/dev/null || echo 0)
    e_full1=$(cat "$BAT1/energy_full" 2>/dev/null || cat "$BAT1/charge_full" 2>/dev/null || echo 1)
    stat1=$(cat "$BAT1/status" 2>/dev/null || echo "Unknown")
    cap1=$(( e_now1 * 100 / e_full1 ))

    pow1_raw=$(cat "$BAT1/power_now" 2>/dev/null || echo "0")
    pow1=$(awk "BEGIN {print $pow1_raw/1000000}")

    echo "  [BAT1 - External]"
    echo "  Capacity : $cap1%"
    echo "  Status   : $stat1"
    echo "  Power    : ${pow1} W"
    echo "------------------------------------------"

    # --- TOTAL AKURAT (Metode UPower / GNOME) ---
    total_energy_now=$(( e_now0 + e_now1 ))
    total_energy_full=$(( e_full0 + e_full1 ))
    total_cap=$(awk "BEGIN {printf \"%.1f\", ($total_energy_now / $total_energy_full) * 100}")

    echo "  [TOTAL COMBINED - REAL]"
    echo "  Accurate Level : $total_cap%"
    echo "=========================================="
    echo "Tekan [CTRL+C] untuk keluar."

    sleep 5
done
