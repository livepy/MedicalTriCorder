import os
import serial
import BTSetup
import MainForm
import tkMessageBox
from Tkinter import *
from serial.tools import list_ports

selectedHSUPort = ''

def main():
    showSetup()
    showMainForm()
    
def showSetup():
    height = 250
    width = 500
    
    root = Tk()
    setupApp = BTSetup.BTSetup(master = root)
    setupApp.master.title("Medical TriCorder - Setup")
    setupApp.master.geometry(str(width) + "x" + str(height))
    setupApp.master.minsize(width, height)
    setupApp.master.maxsize(width, height)
    setupApp.mainloop()

    selectedHSUPort = setupApp.selectedPort

    if (selectedHSUPort == ''):
        tkMessageBox.showinfo("HSU Error", "You must selected a valid HSU port")
        showSetup()
    else:
        showMainForm()
    
def showMainForm():
    height = 500
    width = 600
    
    try:
        root = Tk()
        app = MainForm.MainForm(master = root, serialPort = selectedHSUPort)
        app.master.title("Medical TriCorder - Connected to Hand Scanner Unit")
        app.master.geometry(str(width) + "x" + str(height))
        app.master.minsize(width, height)
        app.master.maxsize(width, height)
        app.mainloop()
    except:
        pass

if __name__ == "__main__":
    main()
