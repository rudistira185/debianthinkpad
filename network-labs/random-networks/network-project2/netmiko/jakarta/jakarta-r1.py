from netmiko import ConnectHandler
from netmiko.exceptions import NetmikoTimeoutException, NetmikoAuthenticationException

# 1. Detail Koneksi Pertama Kali (Menggunakan User Admin)
router = {
    "device_type": "mikrotik_routeros",
    "host": "10.90.90.3",
    "port": 2120,
    "username": "admin",          # Menggunakan user admin bawaan
    "password": "admin",  # Ganti dengan password admin saat ini
}

# 2. Pengelompokan Perintah Konfigurasi Awal
grouped_commands = {
    "SET INTERFACE": [
        "/interface set ether1 name=eth1.core-jakarta",
        "/interface set ether2 name=eth2.jakarta-r3",
        "/interface set ether8 name=eth8.to-netmiko",

    #  #gre
    #    "/interface/gre/add allow-fast-path=no ipsec-secret=gre-tunnel local-address=172.10.10.1 remote-address=172.10.10.2 name=gre.jakarta-to-bandung",
    #    "/interface/gre/add allow-fast-path=no ipsec-secret=gre-tunnel local-address=172.10.10.1 remote-address=172.10.10.3 name=gre.jakarta-to-surabaya",
    #    "/interface/gre/add allow-fast-path=no ipsec-secret=gre-tunnel local-address=172.10.10.1 remote-address=172.10.10.4 name=gre.jakarta-to-aceh",
    ],

    "SET SERVICES": [
       '/ip service/set ssh port=2120 address=10.10.10.1,10.80.80.1,10.90.90.1',
       '/ip service/set winbox port=8120 address=10.10.10.1,10.80.80.1',
    ],

    "SET IPADDRESS": [
        "/ip address add address=10.1.1.2/30 interface=eth1.core-jakarta",
        "/ip address add address=10.3.3.1/30 interface=eth2.jakarta-r3"
        "/ip address add address=10.90.90.3/29 interface=eth8.to-netmiko",
        "/ip address/add address=1.2.2.2/32 interface=lo",

       #gre
       # "/ip address add address=172.20.20.1/32 network=172.20.20.2 interface=gre.jakarta-to-bandung",
       # "/ip address add address=172.20.20.1/32 network=172.20.20.3 interface=gre.jakarta-to-surabaya",
       # "/ip address add address=172.20.20.1/32 network=172.20.20.4 interface=gre.jakarta-to-aceh",
    ],

    "CREATE FIREWALL": [
        #remove firewall
        '/ip firewall filter remove [find chain~"input"]',

        #address-list
        "/ip firewall address-list add list=input-remote address=10.10.10.1",
        "/ip firewall address-list add list=input-remote address=10.80.80.1",
        "/ip firewall address-list add list=input-remote address=10.90.90.1",
        '/ip firewall/address-list/add list=input-ospf address=10.1.1.0/30',
        '/ip firewall/address-list/add list=input-ospf address=10.3.3.0/30',
       # '/ip firewall/address-list/add list=input-ipsec address=172.10.10.0/24',
        #'/ip firewall/address-list/add list=input-gre address=172.10.10.0/24',
        #'/ip firewall/address-list/add list=input-ebgp address=172.20.20.1',
        #'/ip firewall/address-list/add list=input-ebgp address=172.20.20.2',
        #'/ip firewall/address-list/add list=input-ebgp address=172.20.20.3',
        #'#/ip firewall/address-list/add list=input-ebgp address=172.20.20.4',
        #'/ip firewall/address-list/add list=input-dns address=10.1.1.0/30',
        #'/ip firewall/address-list/add list=input-dns address=10.2.2.0/30',
        #'/ip firewall/address-list/add list=input-dns address=10.3.3.0/30',
        #'/ip firewall/address-list/add list=input-dns address=10.4.4.0/30',
        #filter / input
        '/ip firewall/filter/add chain=input action=accept connection-state=established,related comment="== INPUT CONNTRACK =="',
        '/ip firewall/filter/add chain=input action=drop connection-state=invalid',
        '/ip firewall/filter/add chain=input action=accept protocol=icmp comment="== INPUT ICMP =="',
        '/ip firewall/filter/add chain=input action=accept protocol=tcp dst-port=2120,8120 src-address-list=input-remote comment="== INPUT REMOTE =="',
        #ospf
        '/ip firewall/filter/add chain=input action=accept protocol=ospf src-address-list=input-ospf comment="== INPUT OSPF =="',
        #ipsec
        #'/ip firewall/filter/add chain=input acton=accept protocol=udp dst-port=500,4500 src-address-list=input-ipsec comment="== INPUT IPSEC =="',
        #'/ip firewall/filter/add chain=input action=accept protocol=ipsec-esp src-address-list=input-ipsec',
        #gre
        #'/ip firewall/filter/add chain=input action=accept protocol=gre src-address-list=input-gre comment="== INPUT GRE"',
        #ebgp
        #'/ip firewall/filter/add chain=input action=accept protocol=tcp dst-port=179 src-address-list=input-ebgp comment="== INPUT EBGP =="',
        #dns
         #'/ip firewall/filter/add chain=input action=accept src-address-list=input-dns protocol=tcp dst-port=53 comment="== INPUT DNS =="',
         #'/ip firewall/filter/add chain=input action=accept src-address-list=input-dns protocol=udp dst-port=53 comment="== INPUT DNS =="',
        #input drop all
        '/ip firewall/filter/add chain=input action=drop comment="== INPUT DROP ALL =="',
    ],

   "CREATE USER": [
           "/user add name=jakarta-r1 group=full password=jakarta-r1",
        ],

    "SYSTEM": [
       # '/system/identity/set name=core-jakarta',
        '/ip dns/set servers=1.1.1.1',
        '/system/ntp/client/set servers=0.id.pool.ntp.org enabled=yes',
        '/system/clock/set time-zone-autodetect=no time-zone-name=Asia/Jakarta',
        #sshd
        # SSH public key
        '/file/add name=jakarta.pub type=file contents="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJpDof/rA67dlN8SYgpS9SqP7qsGYMdW1JP9U2wwb30n carlos@carlos"',
        '/user/ssh-keys/import public-key-file=jakarta.pub user=jakarta-r1',
    ],

   "Routing": [

       #routing filter
       # 'routing/filter/rule/set chain=out.ospf-main rule="if (dst == 10.10.10.0/24) {reject}\nif (dst == 10.80.80.0/24) {reject}\nif (dst == 10.90.90.0/29) {reject}\naccept;"',
       #'/routing/filter/rule/set chain=out.ospf-main rule="if (dst == 10.10.10.0/24) {reject}; if (dst == 10.80.80.0/24) {reject}; if (dst == 10.90.90.0/29) {reject}; accept;"',
       #'/routing/filter/rule add chain=out.ebgp rule="if (dst == 172.20.20.1/32 || dst == 172.20.20.2/32 || dst == 172.20.20.3/32 || dst == 172.20.20.4/32) { reject; }"',
       #route static
       #'/ip route/remove [find dst-address=0.0.0.0/0]',
       #'/ip route/add dst-address=0.0.0.0/0 gateway=10.10.10.1 routing-table=main distance=1 check-gateway=ping comment="== default gateway main isp1"',
       #'/ip route/add dst-address=0.0.0.0/0 gateway=10.80.80.1 routing-table=main distance=2 comment="== default gateway main isp1-failover"',
       #'/ip route/add dst-address=0.0.0.0/0 gateway=10.10.10.1 routing-table=isp1 distance=3 check-gateway=ping comment="== gateway table isp1"',
       #'/ip route/add dst-address=0.0.0.0/0 gateway=10.80.80.1 routing-table=isp1-failover distance=4 comment="== gateway table isp1-failover"',

      #ospf
       '/routing/ospf/instance/add name=main-instance router-id=1.2.2.2 redistribute=connected',
       '/routing/ospf/area/add area-id=0.0.0.0 instance=main-instance name=main-area',
       '/routing/ospf/interface-template/add area=main-area cost=20 networks=10.1.1.0/30 interfaces=eth1.core-jakarta type=ptp comment="ospf.main-to-core-jakarta"',
       '/routing/ospf/interface-template/add area=main-area cost=20 networks=10.3.3.0/30 interfaces=eth2.jakarta-r3 type=ptp comment="ospf.main-to-jakarta-r3"',
       #ebgp
       #'/routing/bgp/instance/add as=65100 name=main-instance router-id=1.1.1.1',
       #'/routing/bgp/connection/add as=65100 name=bgp.jakarta-to-bandung local.role=ebgp local.address=172.20.20.1 remote.address=172.20.20.2 remote.as=65200 output.redistribute=connected,ospf instance=main-instance output.filter-chain=out.ebgp comment="== bgp.jakarta-to-bandung"',
       #'/routing/bgp/connection/add as=65100 name=bgp.jakarta-to-surabaya local.role=ebgp local.address=172.20.20.1 remote.address=172.20.20.3 remote.as=65300 output.redistribute=connected,ospf instance=main-instance output.filter-chain=out.ebgp comment="== bgp.jakarta-to-surabaya"',
       #'/routing/bgp/connection/add as=65100 name=bgp.jakarta-to-aceh local.role=ebgp local.address=172.20.20.1 remote.address=172.20.20.4 remote.as=65400 output.redistribute=connected,ospf instance=main-instance output.filter-chain=out.ebgp comment="== bgp.jakarta-to-aceh"',


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
