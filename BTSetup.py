import os
import serial
import tkMessageBox
from Tkinter import *
from serial.tools import list_ports

class BTSetup(Frame):
    def __init__(self, master = None):
        Frame.__init__(self, master)

        self.selectedPort = ''
        self.createWidgets()
        
    def listSerialPorts(self):
        if (os.name == "nt"):
            available = []
            for i in range(256):
                try:
                    s = serial.Serial(i)
                    available.append('COM' + str(i + 1))
                    s.close()
                except serial.SerialException:
                    pass
                
            return available
        else:
            #Mac / Linux check
            return [port[0] for port in list_ports.comports()]

    def createWidgets(self):
        self.lblSetup = Label(self.master, text = "Select the Hand Scanner Unit (HSU) port and click 'OK' to continue");
        self.lblSetup.pack()
        self.lblSetup.place(x = 30, y = 10)
        
        self.lstPorts = Listbox(self.master, width = "60")
        self.lstPorts.pack()
        self.lstPorts.place(x = 10, y = 30)

        for port in self.listSerialPorts():
            self.lstPorts.insert(END, port)

        self.cmdOk = Button(self.master, width = "8", text = "OK", command = self.cmdOk_Click)
        self.cmdOk.pack()
        self.cmdOk.place(x = 10, y = 210)

    def cmdOk_Click(self):
        try:
            self.selectedPort = self.lstPorts.get(self.lstPorts.curselection()[0])
            self.master.destroy()            
        except IndexError:
            tkMessageBox.showinfo("Setup", "You must select a valid Hand Scanner Unit (HSU) port to connect to.")

