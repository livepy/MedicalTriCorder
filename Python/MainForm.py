import serial
import thread
import tkMessageBox
from Tkinter import *

class MainForm(Frame):
    def __init__(self, master, serialPort):
        Frame.__init__(self, master)

        self.selectedSerialPort = serialPort

        self.serialPort = serial.Serial(self.selectedSerialPort, 38400, timeout = 1)

        self.pack()
        self.createWidgets()

        self.checkForHSUData()
        
    def createWidgets(self):
        self.lblPulse = Label(self.master, text = "Pulse: 0", font = ("Impact", 18))
        self.lblPulse.pack()
        self.lblPulse.place(x = 15, y = 10)
        
        self.lblO2 = Label(self.master, text = "SpO2: 0", font = ("Impact", 18))
        self.lblO2.pack()
        self.lblO2.place(x = 15, y = 40)

        self.lblTemp = Label(self.master, text = "Temp: 0", font = ("Impact", 18))
        self.lblTemp.pack()
        self.lblTemp.place(x = 15, y = 70)

        self.lblStatus = Label(self.master, text = "Waiting on HSU...", font = ("Arial", 8))
        self.lblStatus.pack()
        self.lblStatus.place(x = 0, y = 110)

    def checkForHSUData(self):
        serialData = self.serialPort.readline().rstrip()
        
        if (serialData != None):
            if (serialData == "SCN"):
                self.lblStatus.config(text = "HSU Scanning...")
            elif ("ACK" in serialData):
                serialSplitData = serialData.split(",")

                self.lblPulse.config(text = "Pulse: " + serialSplitData[1])
                self.lblO2.config(text = "SpO2: " + serialSplitData[2])
                self.lblTemp.config(text = "Temp: " + serialSplitData[3])
                
                self.lblStatus.config(text = "Scanning Complete...")
            
        self.after(500, self.checkForHSUData)
