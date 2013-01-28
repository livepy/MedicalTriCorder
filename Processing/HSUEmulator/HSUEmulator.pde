import processing.serial.*;
import controlP5.*;

private String sEmulatorName = "Medical TriCorder HSU Emulator v1.0";
private boolean bluetoothOn = true;
private boolean serialCon = false;
private boolean initComplete = false;
private DropdownList lstSerialPort;
private Button cmdConnect;
private String[] sPorts;
private ControlP5 cp5;

void setup()
{
  size(400, 130);
  frame.setTitle(sEmulatorName);

  cp5 = new ControlP5(this);
  //cp5.setControlFont(createFont("Arial", 8));

  lstSerialPort = cp5.addDropdownList("lstSerialPort")
    .setPosition(10, 20)
    .setSize(120, 120)
    .setBarHeight(15)
    .setItemHeight(15);
    
  lstSerialPort.captionLabel().set("Available Serial Ports");
  lstSerialPort.captionLabel().style().marginTop = 3;
  lstSerialPort.valueLabel().style().marginTop = 3;
  
  cmdConnect = cp5.addButton("cmdConnect")
     .setValue(0)
     .setPosition(140, 10)
     .setSize(120, 19);

  cmdConnect.captionLabel().set("Start HSU Emulator");
  
  sPorts = Serial.list();
  
  lstSerialPort.addItems(sPorts);
  
  
  initComplete = true;
}

void draw()
{

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
