#!/bin/bash

KEY="../netmiko-keys/id_ed25519"
USER="r3-netmiko"
PORT="2530"

IPS=(
    "50.50.50.30"
)

for IP in "${IPS[@]}"; do
    if nc -z -w 2 "$IP" "$PORT" 2>/dev/null; then
        echo "Menghubungkan ke $IP"
        exec ssh -i "$KEY" "$USER@$IP" -p "$PORT"
    fi
done

echo "Semua IP tidak dapat diakses"
exit 1
