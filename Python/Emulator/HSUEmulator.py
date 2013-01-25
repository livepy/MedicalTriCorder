import os
import serial
import random

portCount = 1
bluetoothOn = True

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

while (True):
    commandByte = serialPort.read()
    
    if (commandByte == "\xF0"):
        #Return BT Status
        if (bluetoothOn):
            serialPort.write("BT ON\n")
        else:
            serialPort.write("BT OFF\n")
    elif (commandByte == "\xF1"):
        #Turn BT On
        serialPort.write("OK BT ON\n")
        bluetoothOn = True
    elif (commandByte == "\xF2"):
        #Turn BT Off
        serialPort.write("OK BT OFF\n")
        bluetoothOn = False
    elif (commandByte == "\xA1"):
        #Send Ident
        serialPort.write("Medical TriCorder HSU EMU v1.0\n")
    elif (commandByte == "\xA2"):
        #Set PIN
        serialPort.write("OK PIN SET\n")
    elif (commandByte == "\xB1"):
        #Return BPM
        serialPort.write(str(random.randint(72, 85)) + "\n")
    elif (commandByte == "\xB2"):
        #Return SpO2
        serialPort.write(str(random.randint(90, 100)) + "\n")
    elif (commandByte == "\xB3"):
        #Return Temp
        serialPort.write(str(random.randint(98, 101)) + "\n")
    elif (commandByte == "\xB4"):
        #Return Vital Packet
        serialPort.write("Not Implemented (VP)\n")  
