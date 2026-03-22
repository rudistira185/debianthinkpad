MikroTik v7 - Routing Rules
📘 Overview

Routing Rules digunakan untuk mengarahkan trafik berdasarkan kebijakan (Policy-Based Routing), bukan hanya destination.

🧠 Konsep
Paket dicek ke routing rules (top-down)
Jika match → gunakan routing table tertentu
Jika tidak → fallback ke main
⚙️ Komponen

Action

lookup → cari route + fallback ke main
lookup-only-in-table → tanpa fallback
blackhole → drop
unreachable → drop + ICMP

Match

Source address
Destination address
Interface
Routing mark

Routing Table

Berisi route untuk jalur tertentu
Harus valid (punya gateway/path)
🔄 Behavior
Dieksekusi berurutan (top-down)
Rule pertama yang match langsung dipakai
Urutan rule menentukan hasil
🧩 Use Case
Multi-WAN
Segmentasi trafik
Policy routing (paksa jalur tertentu)
📦 Ringkas

Routing Rules di RouterOS v7 memberi kontrol fleksibel untuk menentukan jalur trafik berdasarkan kebijakan, bukan hanya routing standar.