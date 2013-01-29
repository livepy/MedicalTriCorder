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

void setup()
{
  size(400, 250);
  frame.setTitle(sEmulatorName);

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
  
  sPorts = Serial.list();
  
  dlSerialPort.addItems(sPorts);
  
  
  initComplete = true;
}

void draw()
{
  background(128);
}

void controlEvent(ControlEvent theEvent) 
{
  if (theEvent.isGroup()) 
  {
    println("GROUP EVENT: " + theEvent.group().value() + " from " + theEvent.group());
  }
  
  if(theEvent.isGroup() && theEvent.name().equals("lstSerialPort"))
  {
    int test = (int)theEvent.group().value();
    println("Selected Index: " + test);
  }
}

void cmdConnect()
{
  if (initComplete)
  {
    println("Connect clicked!");
  }
}
