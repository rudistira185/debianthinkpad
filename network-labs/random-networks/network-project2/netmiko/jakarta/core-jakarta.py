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
    "SET INTERFACE": [
        "/interface set ether1 name=eth1.to-isp1",
        "/interface set ether2 name=eth2.to-isp1-failover",
        "/interface set ether3 name=eth3.to-netmiko",
    ],

    "SET SERVICES": [
       '/ip service/set ssh port=2110 address=10.10.10.1,10.80.80.1,10.90.90.1',
       '/ip service/set winbox port=8110 address=10.10.10.1,10.80.80.1',
    ],

    "SET IPADDRESS": [
        "/ip address add address=10.10.10.10/24 interface=eth1.to-isp1",
        "/ip address add address=10.80.80.10/24 interface=eth2.to-isp1-failover",
        "/ip address add address=10.90.90.2/29 interface=eth3.to-netmiko",   
    ],

    "CREATE FIREWALL": [
        #remove firewall
        '/ip firewall filter remove [find chain=input]'

        #address-list
        "/ip firewall address-list add list=input-remote address=10.10.10.1",
        "/ip firewall address-list add list=input-remote address=10.80.80.1",
        "/ip firewall address-list add list=input-remote address=10.90.90.1",

        #filter / input
        '/ip firewall/filter/add chain=input action=accept connection-state=established,related comment="== INPUT CONNTRACK =="',
        '/ip firewall/filter/add chain=input action=drop connection-state=invalid',
        '/ip firewall/filter/add chain=input action=accept protocol=icmp comment="== INPUT ICMP =="',
        '/ip firewall/filter/add chain=input action=accept protocol=tcp dst-port=2110,8110 src-address-list=input-remote comment="== INPUT REMOTE =="',
        '/ip firewall/filter/add chain=input action=drop comment="== INPUT DROP ALL =="',
    ],

   "CREATE USER": [
       "/user add name=core-jakarta group=full password=core-jakarta",
    ],


   "Routing": [
       #route static
       '/ip route/add dst-address=0.0.0.0/0 gateway=10.10.10.1 routing-table=main distance=1 check-gateway=ping comment="== default gateway main isp1"',
       '/ip route/add dst-address=0.0.0.0/0 gateway=10.80.80.1 routing-table=main distance=2 comment="== default gateway main isp1-failover"',
       '/ip route/add dst-address=0.0.0.0/0 gateway=10.10.10.1 routing-table=isp1 distance=3 check-gateway=ping comment="== gateway table isp1"',
       '/ip route/add dst-address=0.0.0.0/0 gateway=10.80.80.1 routing-table=isp1-failover distance=4 comment="== gateway table isp1-failover"',
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
