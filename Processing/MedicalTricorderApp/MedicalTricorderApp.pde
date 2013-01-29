import processing.serial.*;
import controlP5.*;

private ControlP5 cp5;
private DropdownList dlSerialPort;
private Button cmdConnect;
private Textlabel lblPulse;
private Textlabel lblSpO2;
private Textlabel lblTemp;
private Textlabel lblHSUModel;
private boolean initComplete = false;
private Serial HSUConnection;

void setup()
{
  size(600, 520);
  frame.setTitle("Medical TriCorder");
  //TODO: Create icon for Mac (icns file) and detect OS type. Below line will only work on Windows/Linux
  frame.setIconImage( getToolkit().getImage("tricorder.ico") );
  cp5 = new ControlP5(this);
  
  dlSerialPort = cp5.addDropdownList("dlSerialPort")
    .setPosition(10, 20)
    .setSize(250, 50)
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

  cmdConnect.captionLabel().set("Connect to HSU");
  
  dlSerialPort.addItems(Serial.list());
  
  lblPulse = cp5.addTextlabel("lblPulse")
    .setPosition(10, 65)
    .setText("Pulse: ");
    
  lblSpO2 = cp5.addTextlabel("lblSpO2")
    .setPosition(10, 80)
    .setText("SpO2: ");
    
  lblTemp = cp5.addTextlabel("lblTemp")
    .setPosition(10, 95)
    .setText("Temp: ");
  
  lblHSUModel = cp5.addTextlabel("lblHSUModel")
    .setPosition(10, 500)
    .setText("HSU Model: ");
    
  initComplete = true;
}

void draw() 
{
  background(128);
  line(0, 40, 620, 40);
}

void cmdConnect()
{
  if (initComplete)
  {
    if (cmdConnect.captionLabel().getText() == "Connect to HSU")
    {
      HSUConnection = new Serial(this, dlSerialPort.item((int)dlSerialPort.getValue()).getName(), 38400);
      HSUConnection.write(0xA1);
      cmdConnect.captionLabel().set("Disconnect from HSU");
    }
    else
    {
      HSUConnection.stop();
      cmdConnect.captionLabel().set("Connect to HSU");
      lblHSUModel.setText("HSU Model:");
    }
  }
}

void serialEvent(Serial p)
{
  String sData = p.readStringUntil('\n');
  lblHSUModel.setText("HSU Model: " + sData);
}
