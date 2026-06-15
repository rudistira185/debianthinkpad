#!/bin/bash

KEY="../aceh-keys/id_rsa"
USER="aceh-pcq-tree"
PORT="4500"

IPS=(
    "40.40.40.40"
    "40.80.80.40"
)

for IP in "${IPS[@]}"; do
    if nc -z -w 2 "$IP" "$PORT" 2>/dev/null; then
        echo "Menghubungkan ke $IP"
        exec ssh -i "$KEY" "$USER@$IP" -p "$PORT"
    fi
done

echo "Semua IP tidak dapat diakses"
exit 1
