#!/bin/bash

KEY="jakarta-keys/id_rsa"
USER="jakarta-r1"
PORT="2120"

IPS=(
    "10.10.10.10"
    "10.80.80.10"
)

for IP in "${IPS[@]}"; do
    if nc -z -w 2 "$IP" "$PORT" 2>/dev/null; then
        echo "Menghubungkan ke $IP"
        exec ssh -i "$KEY" "$USER@$IP" -p "$PORT"
    fi
done

echo "Semua IP tidak dapat diakses"
exit 1
