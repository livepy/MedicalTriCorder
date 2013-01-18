from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from matplotlib.figure import Figure
from Tkinter import *

class MainForm(Frame):
    def __init__(self, master=None):
        Frame.__init__(self, master)
        
        self.heartBeats = []
        self.O2 = []
        
        self.pack()
        self.createWidgets()
        self.updateChart()
    
    def createWidgets(self):
        self.lblPulse = Label(self.master, text = "Pulse: 0 bpm")
        self.lblPulse.pack()
        self.lblPulse.place(x = 10, y = 10)
        
        self.lblO2 = Label(self.master, text = "O2: 0%")
        self.lblO2.pack()
        self.lblO2.place(x = 10, y = 30)    

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
        self.heartRateCanvasWidget.place(x = 10, y = 60)

def main():
    height = 600
    width = 485
    root = Tk()
    app = MainForm(master=root)
    app.master.title("Py-TriCorder")
    app.master.geometry(str(height) + "x" + str(width))
    app.master.minsize(height, width)
    app.master.maxsize(height, width)
    app.mainloop()

if __name__ == "__main__":
    main()
