import os
import serial
import random

portCount = 1
bluetoothOn = True
serialCon = False

def listSerialPorts():
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

print "Medical TriCorder HSU Emulator v1.0"
print "___________________________________"
print ""

serialPorts = listSerialPorts()

for port in listSerialPorts():
    print str(portCount) + " - " + port    
    portCount += 1

print ""

selectedPort = raw_input("Select a serial port to connect to: ")
selectedPort = serialPorts[int(selectedPort) - 1]

serialPort = serial.Serial(selectedPort, 38400, timeout = 1)

print "HSU Emulator started on " + selectedPort

print ""

while (True):
    print "1 - Send Scanning Command"
    print "2 - Send Scanning Complete & Vitals"
    print "3 - Stop HSU Emulation"
    print ""
    userOption = raw_input("Select an option: ");

    if (userOption == "1"):
        #Scanning
        serialPort.write("SCN\n")
    elif (userOption == "2"):
        #Scanning Complete
        #Return ACK,BPM,Sp02,Temp
        sReturn = "ACK" + "," + str(random.randint(72, 85)) + "," + str(random.randint(90, 100)) + "," + str(random.randint(98, 101)) + "\n"
        serialPort.write(sReturn)
    elif (userOption == "3"):
        #Exit
        serialPort.close()
        os._exit(0);
    else:
        print "Invalid Option!"
        print ""
