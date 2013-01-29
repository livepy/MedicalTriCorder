import javax.swing.ImageIcon;
import processing.serial.*;
import controlP5.*;

private String sEmulatorName = "Medical TriCorder HSU Emulator v1.0";
private boolean bluetoothOn = true;
private boolean serialCon = false;
private boolean initComplete = false;
private DropdownList dlSerialPort;
private Button cmdConnect;
private String[] sPorts;
private ControlP5 cp5;
private Serial HSUPort;

void setup()
{
  size(400, 250);
  
  frame.setTitle(sEmulatorName);
  frame.setIconImage(new ImageIcon(loadBytes("ic.png")).getImage());
 
  cp5 = new ControlP5(this);
  //cp5.setControlFont(createFont("Arial", 8));

  dlSerialPort = cp5.addDropdownList("dlSerialPort")
    .setPosition(10, 20)
    .setSize(250, 120)
    .setBarHeight(15)
    .setItemHeight(15);
    
  dlSerialPort.captionLabel().set("Available Serial Ports");
  dlSerialPort.captionLabel().style().marginTop = 3;
  dlSerialPort.valueLabel().style().marginTop = 3;
  
  dlSerialPort.setItemHeight(20);
  dlSerialPort.setBarHeight(15);
  dlSerialPort.captionLabel().style().marginTop = 3;
  dlSerialPort.captionLabel().style().marginLeft = 3;
  dlSerialPort.valueLabel().style().marginTop = 3;
  
  cmdConnect = cp5.addButton("cmdConnect")
     .setValue(0)
     .setPosition(280, 4)
     .setSize(100, 15);

  cmdConnect.captionLabel().set("Start HSU Emulator");
  
  dlSerialPort.addItems(Serial.list());
  
  initComplete = true;
}

void draw()
{
  background(128);
}

void cmdConnect()
{
  if (initComplete)
  {
    if (cmdConnect.captionLabel().getText() == "Start HSU Emulator")
    {
      HSUPort = new Serial(this, dlSerialPort.item((int)dlSerialPort.getValue()).getName(), 38400);
      cmdConnect.captionLabel().set("Stop HSU Emulator");
    }
    else
    {
      HSUPort.stop();
      cmdConnect.captionLabel().set("Start HSU Emulator");
    }
  }
}

void serialEvent(Serial p)
{
  int dataByte = p.read();
  
  switch (dataByte)
  {
    case 0xF0:
      //Return BT Status
      if (bluetoothOn)
      {
        HSUPort.write("BT ON \n");
      }
      else
      {
        HSUPort.write("BT OFF \n");
      }
      break;
    case 0xF1:
      //Turn BT On
      bluetoothOn = true;
      HSUPort.write("OK BT ON\n");
      break;
    case 0xF2:
      //Turn BT Off
      bluetoothOn = false;
      HSUPort.write("OK BT OFF\n");
      break;
    case 0xA1:
      HSUPort.write("Medical TriCorder HSU EMU v1.0\n");
      break;
    case 0xA2:
      HSUPort.write("OK PIN SET\n");
      break;
    case 0xB1:
      //Return BPM
      HSUPort.write((int)random(72, 85) + "\n");
      break;
    case 0xB2:
      //Return SpO2
      HSUPort.write((int)random(90, 100) + "\n");
      break;
    case 0xB3:
      //Return Temp
      HSUPort.write(random(98.0, 101.0) + "\n");
      break;
    case 0xB4:
      //Return Vital Packet
      HSUPort.write("Not Implemented (VP)\n");
      break;
    default:
      break;    
  }
}
