#!/bin/bash

TARGET="8.8.8.8"
MAX_FAILURES=10
FAIL_COUNT=0

echo "Memulai monitoring koneksi ke $TARGET..."

while true; do
    # Ping 1 paket (-c 1) dengan batas waktu tunggu 2 detik (-W 2)
    if ping -c 1 -W 2 "$TARGET" > /dev/null 2>&1; then
        # Jika ping berhasil, reset counter ke 0
        if [ "$FAIL_COUNT" -ne 0 ]; then
            echo "Koneksi stabil. Counter di-reset."
            FAIL_COUNT=0
        fi
    else
        # Jika ping gagal (RTO/unreachable), tambah counter
        FAIL_COUNT=$((FAIL_COUNT + 1))
        echo "Ping RTO: $FAIL_COUNT/$MAX_FAILURES"
    fi

    # Jika kegagalan mencapai batas maksimal
    if [ "$FAIL_COUNT" -ge "$MAX_FAILURES" ]; then
        echo "Koneksi terputus (5x RTO berturut-turut). Merestart Wi-Fi..."
        
        # Matikan Wi-Fi
        nmcli radio wifi off
        sleep 3 # Beri jeda agar hardware benar-benar mati
        
        # Hidupkan Wi-Fi
        nmcli radio wifi on
        echo "Wi-Fi dihidupkan kembali. Menunggu auto-connect..."
        
        # Reset counter
        FAIL_COUNT=0
        
        # Beri jeda lebih lama (misal 15 detik) agar Wi-Fi sempat terhubung 
        # ke hotspot sebelum mulai ping lagi
        sleep 15
    fi

    # Jeda 1 detik antar ping
    sleep 1
done
