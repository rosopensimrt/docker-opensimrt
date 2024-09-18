#1/bin/bash


CONNECTION_NAME='x-IMU3 Network(AP)'
SSID='x-IMU3 Network 5 GHz'
NIC=wlp0s20f3 

#there must be a secure way to set this up
PASSWD=xiotechnologies

nmcli device wifi hotspot con-name "${CONNECTION_NAME}" ifname $NIC ssid "${SSID}" password $PASSWD

nmcli con modify "${CONNECTION_NAME}" ipv4.addresses 192.168.1.1/24 ipv4.method manual

nmcli con down "${CONNECTION_NAME}" 

nmcli con up "${CONNECTION_NAME}"
