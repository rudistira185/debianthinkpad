sudo sysctl vm.swappiness=20
zramctl
swapon --show
cat /sys/block/zram0/comp_algorithm
lsblk
cat /proc/sys/vm/swappiness
