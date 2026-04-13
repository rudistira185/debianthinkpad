#/bin/bash
sudo chmod 777 /dev/ttyUSB*

esptool --chip esp32 --port /dev/ttyUSB0 --baud 115200 write_flash -z 0x0 tasmota32.factory.prometheus.bin
