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
    root.protocol('WM_DELETE_WINDOW', exitApplication)
    root.resizable(0,0)
    
    #root.iconbitmap("tricorder.png")
    setupApp = BTSetup.BTSetup(master = root)
    setupApp.master.title("Medical TriCorder - Setup")
    xp = (root.winfo_screenwidth() / 2) - (width / 2) - 8
    yp = (root.winfo_screenheight() / 2) - (height / 2) - 8
    setupApp.master.geometry("{0}x{1}+{2}+{3}".format(str(width), str(height), xp, yp))
    setupApp.master.minsize(width, height)
    setupApp.master.maxsize(width, height)
    setupApp.mainloop()

    if (setupApp.selectedPort == ''):
        tkMessageBox.showinfo("HSU Error", "You must selected a valid HSU port")
        showSetup()
    else:
        showMainForm(setupApp.selectedPort)
    
def showMainForm(serialPort):
    height = 130
    width = 300

    root = Tk()
    root.protocol('WM_DELETE_WINDOW', exitApplication)
    root.resizable(0,0)
    
    #root.iconbitmap("tricorder.png")
    app = MainForm.MainForm(master = root, serialPort = serialPort)
    app.master.title("Medical TriCorder")
    xp = (root.winfo_screenwidth() / 2) - (width / 2) - 8
    yp = (root.winfo_screenheight() / 2) - (height / 2) - 8
    app.master.geometry("{0}x{1}+{2}+{3}".format(str(width), str(height), xp, yp))
    app.master.minsize(width, height)
    app.master.maxsize(width, height)
    app.mainloop()

def exitApplication():
    os._exit(0)
    
if __name__ == "__main__":
    main()
