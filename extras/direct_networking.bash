#!/bin/bash


CONNECTION_NAME='x-IMU3 Network(AP)'
SSID='x-IMU3 Network'
NIC=wlp0s20f3 

## there must be a secure way to set this up
PASSWD=xiotechnologies

WANT_THE_ORAGE_ICON=false

nmcli device wifi hotspot con-name "${CONNECTION_NAME}" ifname $NIC ssid "${SSID}" password $PASSWD


if [ "$WANT_THE_ORAGE_ICON" == "true" ]; then
	nmcli con modify "${CONNECTION_NAME}" ipv4.addresses 192.168.1.1/24 ipv4.method shared
	## now we need to modify the dnsmasq because otherwise there may be collisions with the xIMUs which are static. 
	## note, if you change the xIMU driver to use the discovery service, you can remove this part
	## also, if you are already using a dhcp server for something else, you need to find out how network manager chooses the --conf-dir= flag for the connection
	## idk how this works either. do a `ps aux | grep dnsmasq` and follow the breadcrums

	## see here for more options: https://github.com/imp/dnsmasq/blob/master/dnsmasq.conf.example
	sudo echo "dhcp-range=192.168.1.2,192.168.1.101,12h" > /etc/NetworkManager/dnsmasq-shared.d/hotspot.conf
	## I don't think i need this
	sudo systemctl restart NetworkManager
	
else
	nmcli con modify "${CONNECTION_NAME}" ipv4.addresses 192.168.1.1/24 ipv4.method manual
fi

## I thought I was going to need to change the mac address, but it wasn't necessary
#nmcli connection modify  "${CONNECTION_NAME}" 802-11-wireless.mac-address 80:C9:55:00:00:00
#nmcli connection modify  "${CONNECTION_NAME}" 802-11-wireless.channel 44
#nmcli connection modify  "${CONNECTION_NAME}" 802-11-wireless.band


## I dont think i need this
#sudo nmcli connection reload 

nmcli con down "${CONNECTION_NAME}" 

nmcli con up "${CONNECTION_NAME}"
