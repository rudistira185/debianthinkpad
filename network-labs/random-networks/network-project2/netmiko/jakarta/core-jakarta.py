from netmiko import ConnectHandler
from netmiko.exceptions import NetmikoTimeoutException, NetmikoAuthenticationException

# 1. Detail Koneksi Pertama Kali (Menggunakan User Admin)
router = {
    "device_type": "mikrotik_routeros",
    "host": "10.90.90.2",
    "port": 2110,
    "username": "admin",          # Menggunakan user admin bawaan
    "password": "admin",  # Ganti dengan password admin saat ini
}

# 2. Pengelompokan Perintah Konfigurasi Awal
grouped_commands = {
    "SYSTEM INFO": [
        "/system identity print",
        "/system resource print",
    ],
    "DNS CONFIGURATION": [
        "/ip dns set servers=8.8.8.8 allow-remote-requests=yes", 
    ],
    "CREATE NEW USER": [
        # Membuat user baru bernama 'netmiko' dengan hak akses 'full'
        "/user add name=test1 group=full password=test1",
    ]
}

try:
    print("Menghubungkan ke router menggunakan user 'admin'...")
    conn = ConnectHandler(**router)
    
    # Menjalankan grup konfigurasi awal
    for category, commands in grouped_commands.items():
        print("\n" + "=" * 50)
        print(f" SEGMENT: {category} ".center(50, "-"))
        print("=" * 50)
        
        for command in commands:
            output = conn.send_command(command)
            print(f"\n[Command Executed]: {command}")
            print(output)
            print("-" * 50)

    # 3. Proses Disable User Admin (Langkah Terakhir)
    print("\n" + "=" * 50)
    print(" SEGMENT: DEACTIVATING DEFAULT ADMIN ".center(50, "-"))
    print("=" * 50)
    
    disable_command = "/user disable admin"
    print(f"Menjalankan perintah: {disable_command}")
    
    try:
        # Mengirimkan perintah disable. Sesi SSH akan putus di titik ini.
        conn.send_command(disable_command)
        conn.disconnect()
    except Exception:
        # Menangkap pemutusan koneksi paksa oleh router sebagai tanda sukses
        print("\n[INFO]: Koneksi SSH terputus secara otomatis.")
        print("[INFO]: User 'admin' berhasil dinonaktifkan!")

    print("\n" + "=" * 50)
    print(" SETUP SELESAI & SCRIPT BERHENTI ".center(50, "*"))
    print("=" * 50)

except (NetmikoTimeoutException, NetmikoAuthenticationException) as e:
    print(f"\n[ERROR]: Gagal terhubung ke router. Detail: {e}")
