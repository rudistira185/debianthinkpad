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
        "/interface set ether4 name=eth4.to-jakarta-r1",
        "/interface set ether5 name=eth5.to-jakarta-r2",
        "/interface set ether8 name=eth8.to-bridge-interconnection",

      #gre
        "/interface/gre/add allow-fast-path=no ipsec-secret=gre-tunnel local-address=172.10.10.1 remote-address=172.10.10.2 name=gre.jakarta-to-bandung",
        "/interface/gre/add allow-fast-path=no ipsec-secret=gre-tunnel local-address=172.10.10.1 remote-address=172.10.10.3 name=gre.jakarta-to-surabaya",
        "/interface/gre/add allow-fast-path=no ipsec-secret=gre-tunnel local-address=172.10.10.1 remote-address=172.10.10.4 name=gre.jakarta-to-aceh",
    ],

    "SET SERVICES": [
       '/ip service/set ssh port=2110 address=10.10.10.1,10.80.80.1,10.90.90.1',
       '/ip service/set winbox port=8110 address=10.10.10.1,10.80.80.1',
    ],

    "SET IPADDRESS": [
        "/ip address add address=10.10.10.10/24 interface=eth1.to-isp1",
        "/ip address add address=10.80.80.10/24 interface=eth2.to-isp1-failover",
        "/ip address add address=10.90.90.2/29 interface=eth3.to-netmiko",
        "/ip address add address=10.1.1.1/30 interface=eth4.to-jakarta-r1",
        '/ip address add address=10.2.2.1/30 interface=eth5.to-jakarta-r2',
        "/ip address add address=172.10.10.1/24 interface=eth8.to-bridge-interconnection",  
        "/ip address/add address=1.1.1.1/32 interface=lo",

       #gre
        "/ip address add address=172.20.20.1/32 network=172.20.20.2 interface=gre.jakarta-to-bandung",
        "/ip address add address=172.20.20.1/32 network=172.20.20.3 interface=gre.jakarta-to-surabaya",
        "/ip address add address=172.20.20.1/32 network=172.20.20.4 interface=gre.jakarta-to-aceh",
    ],

    "CREATE FIREWALL": [
        #remove firewall
        '/ip firewall filter remove [find chain~"input"]',

        #address-list
        "/ip firewall address-list add list=input-remote address=10.10.10.1",
        "/ip firewall address-list add list=input-remote address=10.80.80.1",
        "/ip firewall address-list add list=input-remote address=10.90.90.1",
        '/ip firewall/address-list/add list=input-ospf address=10.1.1.0/30',
        '/ip firewall/address-list/add list=input-ospf address=10.2.2.0/30',
        '/ip firewall/address-list/add list=input-ipsec address=172.10.10.0/24',
        '/ip firewall/address-list/add list=input-gre address=172.10.10.0/24',
        '/ip firewall/address-list/add list=input-ebgp address=172.20.20.1',
        '/ip firewall/address-list/add list=input-ebgp address=172.20.20.2',
        '/ip firewall/address-list/add list=input-ebgp address=172.20.20.3',
        '/ip firewall/address-list/add list=input-ebgp address=172.20.20.4',

        #filter / input
        '/ip firewall/filter/add chain=input action=accept connection-state=established,related comment="== INPUT CONNTRACK =="',
        '/ip firewall/filter/add chain=input action=drop connection-state=invalid',
        '/ip firewall/filter/add chain=input action=accept protocol=icmp comment="== INPUT ICMP =="',
        '/ip firewall/filter/add chain=input action=accept protocol=tcp dst-port=2110,8110 src-address-list=input-remote comment="== INPUT REMOTE =="',
        #ospf
        '/ip firewall/filter/add chain=input action=accept protocol=ospf src-address-list=input-ospf comment="== INPUT OSPF =="',
        #ipsec
        '/ip firewall/filter/add chain=input acton=accept protocol=udp dst-port=500,4500 src-address-list=input-ipsec comment="== INPUT IPSEC =="',
        '/ip firewall/filter/add chain=input action=accept protocol=ipsec-esp src-address-list=input-ipsec',
        #gre
        '/ip firewall/filter/add chain=input action=accept protocol=gre src-address-list=input-gre comment="== INPUT GRE"',
        #ebgp
        '/ip firewall/filter/add chain=input action=accept protocol=tcp dst-port=179 src-address-list=input-ebgp comment="== INPUT EBGP =="',
        '/ip firewall/filter/add chain=input action=drop comment="== INPUT DROP ALL =="',        
    ],

   "CREATE USER": [
       "/user add name=core-jakarta group=full password=core-jakarta",
    ],


   "Routing": [

       #routing filter
       # 'routing/filter/rule/set chain=out.ospf-main rule="if (dst == 10.10.10.0/24) {reject}\nif (dst == 10.80.80.0/24) {reject}\nif (dst == 10.90.90.0/29) {reject}\naccept;"',
       '/routing/filter/rule/set chain=out.ospf-main rule="if (dst == 10.10.10.0/24) {reject}; if (dst == 10.80.80.0/24) {reject}; if (dst == 10.90.90.0/29) {reject}; accept;"',

       #route static
       '/ip route/remove [find dst-address=0.0.0.0/0]',
       '/ip route/add dst-address=0.0.0.0/0 gateway=10.10.10.1 routing-table=main distance=1 check-gateway=ping comment="== default gateway main isp1"',
       '/ip route/add dst-address=0.0.0.0/0 gateway=10.80.80.1 routing-table=main distance=2 comment="== default gateway main isp1-failover"',
       '/ip route/add dst-address=0.0.0.0/0 gateway=10.10.10.1 routing-table=isp1 distance=3 check-gateway=ping comment="== gateway table isp1"',
       '/ip route/add dst-address=0.0.0.0/0 gateway=10.80.80.1 routing-table=isp1-failover distance=4 comment="== gateway table isp1-failover"',

      #ospf
       '/routing/ospf/instance/add name=main-instance originate-default=always router-id=1.1.1.1 out-filter-chain=out.ospf-main',
       '/routing/ospf/area/add area-id=0.0.0.0 instance=main-instance name=main-area',
       '/routing/ospf/interface-template/add area=main-area cost=20 networks=10.1.1.0/30 interfaces=eth4.to-jakarta-r1 type=ptp comment="ospf.main-to-jakarta-r1"',
       '/routing/ospf/interface-template/add area=main-area cost=30 networks=10.2.2.0/30 interfaces=eth5.to-jakarta-r2 type=ptp comment="ospf.main-to-jakarta-r2"',
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
