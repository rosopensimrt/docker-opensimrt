#!/usr/bin/env python
import os
import sys

file_dir = os.path.dirname(__file__)
sys.path.append(file_dir)
import csvdumper

# Send to server using created UDP socket
if __name__ == "__main__":

    B = csvdumper.Sender("mobl2016_imu.csv")
    B.loopsend()
