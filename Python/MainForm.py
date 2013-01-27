import serial
import thread
import tkMessageBox
from Tkinter import *
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from matplotlib.figure import Figure

class MainForm(Frame):
    def __init__(self, master, serialPort):
        Frame.__init__(self, master)
        hsuReady = False
        self.heartBeats = []
        self.O2 = []

        self.selectedSerialPort = serialPort

        #try:
        self.serialPort = serial.Serial(self.selectedSerialPort, 38400, timeout = 1)

        while (not hsuReady):
            data = self.serialPort.readline()

            if ("RDY" in data):
                hsuReady = True
        
        self.serialPort.write("\xA1")
        self.hsuModel = self.serialPort.readline();

        self.pack()
        self.createWidgets()

        self.updateChart()
        self.updateData()
        
        #except serial.SerialException:
            #tkMessageBox.showerror("HSU Connection Error", "Error connecting to HSU")
            #self.master.destroy()
    
    def createWidgets(self):
        self.lblPulse = Label(self.master, text = "Pulse: 0 BPM")
        self.lblPulse.pack()
        self.lblPulse.place(x = 15, y = 10)
        
        self.lblO2 = Label(self.master, text = "SpO2: 0%")
        self.lblO2.pack()
        self.lblO2.place(x = 15, y = 30)

        self.lblTemp = Label(self.master, text = u"Temp: 0 \N{DEGREE SIGN}F")
        self.lblTemp.pack()
        self.lblTemp.place(x = 10, y = 50)

        self.lblModel = Label(self.master, text = "HSU Model: " + self.hsuModel)
        self.lblModel.pack()
        self.lblModel.place(x = 15, y = 490)
	
    def updateChart(self):
        heartRateFigure = Figure(figsize=(7, 5))
        bpmPlot = heartRateFigure.add_subplot(111, title="Heart Rate (BPM) & SpO2(%)", xlabel = "Time", axisbg="black")
        bpmObject, = bpmPlot.plot(self.heartBeats, color='red')
        o2Object, = bpmPlot.plot(self.O2, color='yellow')
        #bpmPlot.legend([bpmObject, o2Object], ["BPM", "O2"], "best")
        
        self.heartRateCanvas = FigureCanvasTkAgg(heartRateFigure, master=self.master)
        self.heartRateCanvas.show()
        self.heartRateCanvasWidget = self.heartRateCanvas.get_tk_widget()
        self.heartRateCanvasWidget.pack()
        self.heartRateCanvasWidget.place(x = 10, y = 80)
		
    def updateData(self):
        latestBPM = self.getBPM()
        latestSPO2 = self.getO2()
        latestTemp = self.getTemp()

        self.heartBeats.append(latestBPM)
        self.O2.append(latestSPO2)
        
        self.updateChart()
        
        self.lblPulse.config(text = "Pulse: " + str(latestBPM) + " BPM")
        self.lblO2.config(text = "SpO2: " + str(latestSPO2) + "%")
        self.lblTemp.config(text = "Temp: " + str(latestTemp) + u" \N{DEGREE SIGN}F")
        
        self.after(1000, self.updateData)        
        
    def getBPM(self):
        self.serialPort.write("\xB1")
        readBPM = self.serialPort.readline().rstrip()
        
        return int(readBPM)

    def getO2(self):
        self.serialPort.write("\xB2")
        readO2 = self.serialPort.readline().rstrip()
        
        return int(readO2)

    def getTemp(self):
        self.serialPort.write("\xB3")
        readTemp = self.serialPort.readline().rstrip()
        
        return float(readTemp)
