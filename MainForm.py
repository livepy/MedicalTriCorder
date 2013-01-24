import serial
import tkMessageBox
from Tkinter import *
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from matplotlib.figure import Figure

class MainForm(Frame):
    def __init__(self, master = None, serialPort = None):
        Frame.__init__(self, master)
        
        self.heartBeats = []
        self.O2 = []

        self.selectedSerialPort = serialPort

        try:
            self.serialPort = serial.Serial(self.selectedSerialPort, 38400, timeout = 1)
            self.serialPort.write("Hello, world!") #BlueTooth Test

            self.pack()
            self.createWidgets()
            self.updateChart()
        except serial.SerialException:
            tkMessageBox.showerror("HSU Connection Error", "Error connecting to HSU")
            self.master.destroy()
    
    def createWidgets(self):
        self.lblPulse = Label(self.master, text = "Pulse: 0 bpm")
        self.lblPulse.pack()
        self.lblPulse.place(x = 10, y = 10)
        
        self.lblO2 = Label(self.master, text = "O2: 0%")
        self.lblO2.pack()
        self.lblO2.place(x = 27, y = 30)

        self.lblTemp = Label(self.master, text = u"Temp: 0 \N{DEGREE SIGN}F")
        self.lblTemp.pack()
        self.lblTemp.place(x = 10, y = 50)

    def updateChart(self):
        heartRateFigure = Figure(figsize=(7, 5))
        bpmPlot = heartRateFigure.add_subplot(111, title="Heart Rate (BPM) & O2(%)", xlabel = "Time", axisbg="black")
        bpmObject, = bpmPlot.plot(self.heartBeats, color='red')
        o2Object, = bpmPlot.plot(self.O2, color='yellow')
        #bpmPlot.legend([bpmObject, o2Object], ["BPM", "O2"], "best")
        
        self.heartRateCanvas = FigureCanvasTkAgg(heartRateFigure, master=self.master)
        self.heartRateCanvas.show()
        self.heartRateCanvasWidget = self.heartRateCanvas.get_tk_widget()
        self.heartRateCanvasWidget.pack()
        self.heartRateCanvasWidget.place(x = 10, y = 80)
