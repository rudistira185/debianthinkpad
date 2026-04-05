# MikroTik Monitoring Stack (MTX + Prometheus + Grafana)

Monitoring stack untuk perangkat MikroTik berbasis Prometheus exporter (MTX/MTXP) yang divisualisasikan menggunakan Grafana.

📌 Overview

Project ini menyediakan setup sederhana namun powerful untuk monitoring RouterOS menggunakan:

- MikroTik Exporter (MTX)
- Prometheus (time-series database)
- Grafana (visualisasi dashboard)

Arsitektur:

MikroTik RouterOS
        ↓ (API)
MTX Exporter
        ↓ (/metrics)
Prometheus
        ↓


Grafana
⚙️ Requirements
- Docker & Docker Compose
- Router MikroTik dengan API aktif
- Network connectivity dari container ke router



Konfigurasi MTX

Edit file:
./mktxp-config/mktxp.conf    (ada di folder docker/)

Contoh:

[mikrotik-grafana]
enabled = True
hostname = 10.10.10.10
username = mikrotik-grafana
password = mikrotik-grafana
port = 8728