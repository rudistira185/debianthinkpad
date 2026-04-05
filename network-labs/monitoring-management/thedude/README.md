# MikroTik Dude Server (RouterOS v7)
📌 Overview

Dude Server adalah layanan monitoring jaringan pada MikroTik RouterOS yang digunakan untuk memantau status perangkat, performa jaringan, dan topologi secara real-time.

Dude merupakan bagian dari aplikasi The Dude yang dikembangkan oleh MikroTik.

🚀 Features
🔍 Auto-discovery network devices
📡 Monitoring (ping, SNMP, service status)
📊 Graphing (traffic, CPU, memory)
🗺️ Network topology visualization
⚠️ Alerts & notifications


🏗️ Architecture

[Dude Client] ---> [Dude Server (RouterOS)] ---> [Network Devices]
- Dude Server berjalan di MikroTik RouterOS v7
- Dude Client digunakan untuk GUI monitoring
- Devices adalah target monitoring


⚙️ Requirements
- RouterOS v7
- Package dude.npk
- Storage & RAM cukup (disarankan CHR atau router high-end)


💻 Access Dude Server
Gunakan Dude Client (Windows):

- Connect ke IP MikroTik
- Default port: 2210


⚠️ Notes
- Dude tidak ringan untuk router kecil
- Disarankan gunakan CHR atau VPS
- Backup database secara berkala


📊 Use Cases
- Monitoring ISP / backbone
- Home lab network visibility
- Enterprise network management
- Troubleshooting jaringan