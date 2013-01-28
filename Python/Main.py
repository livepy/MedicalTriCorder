import os
import serial
import BTSetup
import MainForm
import tkMessageBox
from Tkinter import *
from serial.tools import list_ports

def main():
    showSetup()
    
def showSetup():
    if (os.name == "nt"):
        height = 250
        width = 400
    else:
        height = 250
        width = 500
    
    root = Tk()
    setupApp = BTSetup.BTSetup(master = root)
    setupApp.master.title("Medical TriCorder - Setup")
    setupApp.master.wm_iconbitmap("tricorder.ico")
    setupApp.master.geometry(str(width) + "x" + str(height))
    setupApp.master.minsize(width, height)
    setupApp.master.maxsize(width, height)
    setupApp.mainloop()

    if (setupApp.selectedPort == ''):
        tkMessageBox.showinfo("HSU Error", "You must selected a valid HSU port")
        showSetup()
    else:
        showMainForm(setupApp.selectedPort)
    
def showMainForm(serialPort):
    height = 520
    width = 600
    
    #try:
    root = Tk()
    app = MainForm.MainForm(master = root, serialPort = serialPort)
    app.master.title("Medical TriCorder - Connected to Hand Scanner Unit")
    app.master.wm_iconbitmap("tricorder.ico")
    app.master.geometry(str(width) + "x" + str(height))
    app.master.minsize(width, height)
    app.master.maxsize(width, height)
    app.mainloop()
    #except:
        #pass

if __name__ == "__main__":
    main()
