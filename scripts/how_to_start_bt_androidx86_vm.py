#!/usr/bin/env python3
# vim:fenc=utf-8

#
# @author      : frekle (frekle@bml01.mech.kth.se)
# @file        : how_to_start_bt_androidx86_vm
# @created     : Friday Jan 05, 2024 16:35:06 CET
#


import tkinter as tk
from tkinter import messagebox
import subprocess

def start_vm():
        subprocess.run(['VBoxManage','startvm','Android x86'])

def troubleshooting():
    tk.messagebox.showinfo("Troubleshooting tip:", "Find me so we can fix it.") 

def main():
    root = tk.Tk()
     
    # specify size of window.
    root.geometry("700x800")
     
    # Create text widget and specify size.
    T = tk.Text(root, height = 30, width = 80)
     
    # Create label
    l = tk.Label(root, text = """
    Non-automatic start procedure for the realtek dongle:
    """)
    l.config(font =("Courier", 14))
     
    Fact = """
    1. after the vm finished loading find the shell thing on the main screen
    2. open that shell thing
    3. wait for it to load and run the commands:

        $ su
        # hciconfig hci0 down
        # pm disable com.android.bluetooth
        # pm enable com.android.bluetooth
        # service call bluetooth_manager 6
        # hciconfig hci0 up
        # service call bluetooth_manager 9
    
    4. if everything worked out fine, you should have bluetooth enabled
    5. test it with opening configurations (slide the top bar down), open it up more, click the gear, type bluetooth and select the second one
    6. click "pair"
    7. you should see other bt devices around you. if you don't then it failed

    CLOSING PROCEDURE:

    1. Open the terminal again.
    2. type the commands:

        $ su
        # pm disable com.android.bluetooth
        # hciconfig hci0 down

    3. if everything worked out, you probably didn't destroy the vm and it will run again okay next time. 

    """
     
    # Create button for next text.
    b1 = tk.Button(root, text = "Something doesnt work, what do i do?", command=troubleshooting )
     
    # Create an Exit button.
    b2 = tk.Button(root, text = "Exit",
                command = root.destroy) 
     
    l.pack()
    T.pack()
    start_vm_ = tk.Button(root, text="Start Android VM", command = start_vm)
    start_vm_.pack(fill="both",expand=True)
    b1.pack()
    b2.pack()

    # Insert The Fact.
    T.insert(tk.END, Fact)
    

    tk.mainloop()

if __name__ == '__main__':
	main()



