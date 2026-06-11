#!/bin/bash

KEY="../bandung-keys/id_rsa"
USER="bandung-mpls-ler1"
PORT="2500"

IPS=(
    "20.20.20.20"
    "20.80.80.20"
)

for IP in "${IPS[@]}"; do
    if nc -z -w 2 "$IP" "$PORT" 2>/dev/null; then
        echo "Menghubungkan ke $IP"
        exec ssh -i "$KEY" "$USER@$IP" -p "$PORT"
    fi
done

echo "Semua IP tidak dapat diakses"
exit 1
