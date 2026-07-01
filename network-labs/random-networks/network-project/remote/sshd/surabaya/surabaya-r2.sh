#!/bin/bash

KEY="surabaya-keys/id_rsa"
USER="surabaya-r2"
PORT="2330"

IPS=(
    "30.30.30.30"
    "30.80.80.30"
)

for IP in "${IPS[@]}"; do
    if nc -z -w 2 "$IP" "$PORT" 2>/dev/null; then
        echo "Menghubungkan ke $IP"
        exec ssh -i "$KEY" "$USER@$IP" -p "$PORT"
    fi
done

echo "Semua IP tidak dapat diakses"
exit 1
