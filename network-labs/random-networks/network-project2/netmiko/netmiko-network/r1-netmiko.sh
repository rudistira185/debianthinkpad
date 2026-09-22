from netmiko import ConnectHandler
from netmiko.exceptions import NetmikoTimeoutException, NetmikoAuthenticationException

# 1. Detail Koneksi Pertama Kali (Menggunakan User Admin)
router = {
    "device_type": "mikrotik_routeros",
    "host": "50.50.50.10",
    "port": 2510,
    "username": "admin",          # Menggunakan user admin bawaan
    "password": "admin",  # Ganti dengan password admin saat ini
}

# 2. Pengelompokan Perintah Konfigurasi Awal
grouped_commands = {
    "SET INTERFACE": [
        "/interface set ether1 name=eth1.to-sw-netmiko",
        "/interface set ether2 name=eth2.to-r1-netmiko",
    ],

    "SET SERVICES": [
       '/ip service/set ssh port=2510',
       '/ip service/set winbox port=8510',
    ],

    "SET IPADDRESS": [
        "/ip address add address=50.50.50.10/24 interface=eth1.to-sw-netmiko",
        "/ip address add address=50.10.10.1/30 interface=eth2.to-r1-netmiko",
        "/ip address add address=5.5.5.5/32 interface=lo",

        ],

    "CREATE FIREWALL": [
        #remove firewall
        '/ip firewall filter remove [find chain~"input"]',

        #address-list
        "/ip firewall address-list add list=input-remote address=50.50.50.1",
        "/ip firewall address-list add list=input-rip address=50.10.10.0/30",
        #filter / input
        '/ip firewall/filter/add chain=input action=accept connection-state=established,related comment="== INPUT CONNTRACK =="',
        '/ip firewall/filter/add chain=input action=drop connection-state=invalid',
        '/ip firewall/filter/add chain=input action=accept protocol=icmp comment="== INPUT ICMP =="',
        '/ip firewall/filter/add chain=input action=accept protocol=tcp dst-port=2510,8510 src-address-list=input-remote comment="== INPUT REMOTE =="',
        #rip
        '/ip firewall/filter/add chain=input action=accept protocol=udp dst-port=520,521 src-address-list=input-rip comment="== INPUT RIP =="',
        #input drop all
        '/ip firewall/filter/add chain=input action=drop comment="== INPUT DROP ALL =="',

        #NAT
        '/ip firewall/nat/add chain=srcnat action=masquerade out-interface=eth1.to-sw-netmiko',

        ],

   "CREATE USER": [
           "/user add name=r1-netmiko group=full password=r1-netmiko",
        ],

    "SYSTEM": [
        #'/system/identity/set name=co',
        '/ip dns/set servers=8.8.8.8 allow-remote-requests=yes',
        '/system/ntp/client/set servers=0.id.pool.ntp.org enabled=yes',
        '/system/clock/set time-zone-autodetect=no time-zone-name=Asia/Jakarta',

        #sshd
        # SSH public key
        '/file/add name=ssh.pub type=file contents="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDLETdwXf/SiocIm/3YES1sIS3yrC17q/2eiiZbl1vqk carlos@carlos"',
        '/user/ssh-keys/import public-key-file=ssh.pub user=r1-netmiko',
    ],

   "Routing": [

       #routing filter
       # 'routing/filter/rule/set chain=out.ospf-main rule="if (dst == 10.10.10.0/24) {reject}\nif (dst == 10.80.80.0/24) {reject}\nif (dst == 10.90.90.0/29) {reject}\nac
       '/routing/filter/rule add chain=out.rip-main rule="if (dst == 50.50.50.0/24) {reject} accept"',
       #rip
       #instance
        '/routing/rip/instance/add afi=ip redistribute=connected out-filter-chain=out.rip-main name=main-instance',
       # interface-template
        '/routing/rip/interface-template/add cost=20 instance=main-instance interfaces=eth2.to-r1-netmiko',

        #static-route
        '/ip route add dst-address=0.0.0.0/0 gateway=50.50.50.1 distance=1'
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
