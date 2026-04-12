#!/bin/bash
sudo chmod 777 /dev/ttyUSB*
esptool.py --chip esp32 --port /dev/ttyUSB0 erase_flash
