#!/usr/bin/env python

# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import socket
import time
import csv

now = str(time.time()) + " "

def genmsg():
    NUM_IMU = 10
#msgFromClient       = "Hello UDP Server"
    msgFromClient       = now + ("".join([(str(float(x/100))+" ")*NUM_IMU for x in range(0,18)])) 
    return msgFromClient

def getreadfromcsv():
    with open("gait1992_imu.csv") as csvfile:
        line = csv.reader(csvfile)
        next(line) ## trying to skip the header
        next(line) ## trying to skip the header
        next(line) ## trying to skip the header
        next(line) ## trying to skip the header
        
        next(line) ## this line has the actual labels, if you want them
        for a in line:
        # like use as a generator?
            yield " ".join(a) 

#bytesToSend         = str.encode(msgFromClient)

serverAddressPort   = ("172.17.0.2", 8080 )

bufferSize          = 4096



# Create a UDP socket at client side

UDPClientSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)

## loop?

# Send to server using created UDP socket
if __name__ == "__main__":
    for msg in getreadfromcsv():
        print(msg)
        bytesToSend = str.encode(msg)

        UDPClientSocket.sendto(bytesToSend, serverAddressPort)

        msgFromServer = UDPClientSocket.recvfrom(bufferSize)

        msg_rec = "Message from Server {}".format(msgFromServer[0])

        print(msg_rec)

        time.sleep(0.01)

    print("finished!")
