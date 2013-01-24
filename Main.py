from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from matplotlib.figure import Figure
from Tkinter import *
import os
import serial
from serial.tools import list_ports

class MainForm(Frame):
    def __init__(self, master = None, serialPort = None):
        Frame.__init__(self, master)
        
        self.heartBeats = []
        self.O2 = []

        self.selectedSerialPort = serialPort

        self.serialPort = serial.Serial(self.selectedSerialPort, 38400, timeout = 1)
        self.serialPort.write("Hello, world!") #BlueTooth Test
        
        self.pack()
        self.createWidgets()
        self.updateChart()
    
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
        self.lblSetup = Label(self.master, text = "Select a connection and click 'OK' to continue");
        self.lblSetup.pack()
        self.lblSetup.place(x = 20, y = 10)
        
        self.lstPorts = Listbox(self.master, width = "40")
        self.lstPorts.pack()
        self.lstPorts.place(x = 10, y = 30)

        for port in self.listSerialPorts():
            self.lstPorts.insert(END, port)

        self.cmdOk = Button(self.master, width = "8", text = "OK", command = self.cmdOk_Click)
        self.cmdOk.pack()
        self.cmdOk.place(x = 10, y = 210)

    def cmdOk_Click(self):
        self.selectedPort = self.lstPorts.get(self.lstPorts.curselection()[0])
        self.master.destroy()
            
def main():
    height = 300
    width = 350
    root = Tk()
    setupApp = BTSetup(master = root)
    setupApp.master.title("Medical TriCorder - Setup")
    setupApp.master.geometry(str(width) + "x" + str(height))
    setupApp.master.minsize(width, height)
    setupApp.master.maxsize(width, height)
    setupApp.mainloop()
    
    height = 500
    width = 600

    root = Tk()
    app = MainForm(master = root, serialPort = setupApp.selectedPort)
    app.master.title("Medical TriCorder - Connected to Hand Scanner Unit")
    app.master.geometry(str(width) + "x" + str(height))
    app.master.minsize(width, height)
    app.master.maxsize(width, height)
    app.mainloop()
    
if __name__ == "__main__":
    main()
