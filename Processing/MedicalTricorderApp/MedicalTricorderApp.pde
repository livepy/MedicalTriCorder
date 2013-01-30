import javax.swing.ImageIcon;
import processing.serial.*;
import controlP5.*;

public class MedicalTricorderApp extends PApplet
{
  private ControlP5 cp5;
  private DropdownList dlSerialPort;
  private Button cmdConnect;
  private Textlabel lblPulse;
  private Textlabel lblSpO2;
  private Textlabel lblTemp;
  private Textlabel lblHSUModel;
  private boolean initComplete = false;
  private boolean bConnectedToHSU = false;
  private Serial HSUConnection;
  private int lastRequest;
  private String sHSUModel;
  private ControlTimer controlTimer;
  private String sStatus = "NONE";
  private byte[] appIcon;
  private int lastWrite = 0x0;
  private String[] sVitalPacket;
  private boolean bNewPacket = false;
  
  public static void main(String args[]) 
  {
    PApplet.main(new String[] { "MedicalTricorderApp" });
  }
  
  void setup()
  {
    size(600, 520);
  
    ControlP5.printPublicMethodsFor(ControlTimer.class);
    
    cp5 = new ControlP5(this);
    controlTimer = new ControlTimer();
    
    controlTimer.setSpeedOfTime(1);
    //cp5.setControlFont(createFont("Arial", 12));
    
    frame.setTitle("Medical TriCorder");
	
    appIcon = loadBytes("tricorder.png");
    
    if (appIcon != null)
    {
      frame.setIconImage(new ImageIcon(appIcon).getImage());
    }
    
    dlSerialPort = cp5.addDropdownList("dlSerialPort");
    dlSerialPort.setPosition(10, 20);
    dlSerialPort.setSize(250, 50);
    dlSerialPort.setBarHeight(15);
    dlSerialPort.setItemHeight(20);
    dlSerialPort.captionLabel().set("Available Serial Ports");
    dlSerialPort.captionLabel().style().marginTop = 3;
    dlSerialPort.valueLabel().style().marginTop = 3;
    dlSerialPort.captionLabel().style().marginLeft = 3;
        
    cmdConnect = cp5.addButton("cmdConnect");
    cmdConnect.setValue(0);
    cmdConnect.setPosition(280, 4);
    cmdConnect.setSize(100, 15);
    cmdConnect.captionLabel().set("Connect to HSU");
    
    dlSerialPort.addItems(Serial.list());
    
    lblPulse = cp5.addTextlabel("lblPulse");
    lblPulse.setPosition(10, 65);
    lblPulse.setText("Pulse: ");
      
    lblSpO2 = cp5.addTextlabel("lblSpO2");
    lblSpO2.setPosition(10, 80);
    lblSpO2.setText("SpO2: ");
      
    lblTemp = cp5.addTextlabel("lblTemp");
    lblTemp.setPosition(10, 95);
    lblTemp.setText("Temp: ");
    
    lblHSUModel = cp5.addTextlabel("lblHSUModel");
    lblHSUModel.setPosition(10, 500);
    lblHSUModel.setText("HSU Model: ");

    
    initComplete = true;
  }
  
  void draw() 
  {
    background(128);
    stroke(0, 0, 0);
    line(0, 40, 620, 40);
    
    int time = Integer.parseInt(controlTimer.toString().substring(10, 12));
    
    if (bConnectedToHSU)
    {
      if (time >= 1)
      {       
        HSUConnection.write(0xB4);
        lastWrite = 0xB4;
        controlTimer.reset();
      }
    }
    
    drawGraphs();
  }
  
  void cmdConnect()
  {
    if (initComplete)
    {
      if (cmdConnect.captionLabel().getText() == "Connect to HSU")
      {
        HSUConnection = new Serial(this, dlSerialPort.item((int)dlSerialPort.getValue()).getName(), 38400);
        controlTimer.reset();
        HSUConnection.write(0xA1);
        lastWrite = 0xA1;
        
        cmdConnect.captionLabel().set("Disconnect from HSU");
        bConnectedToHSU = true;
      }
      else
      {
        HSUConnection.stop();
        bConnectedToHSU = false;
        controlTimer.reset();
        cmdConnect.captionLabel().set("Connect to HSU");
        lblPulse.setText("Pulse: ");
        lblSpO2.setText("SpO2: ");
        lblTemp.setText("Temp: ");
        lblHSUModel.setText("HSU Model:");
      }
    }
  }
  int bpmXPos = 25;
  void drawGraphs()
  {
    float mappedValue = 0;
    //BPM Graph
    fill(0);
    rect(20, 130, 560, 100);
    
    //SpO2 Graph
    fill(0);
    rect(20, 250, 560, 100);
    
    //Temp Graph
    fill(0);
    rect(20, 370, 560, 100);
    
    if (bNewPacket)
    {
      //Draw Graphs.
    }
  }
  
  void serialEvent(Serial p)
  {
    String sData = p.readStringUntil('\n');
   
    if (sData != null)
    {
      sData = sData.replace("\n", "");
      
      switch (lastWrite)
      {
        case 0xA1:
          lblHSUModel.setText("HSU Model: " + sData);
          break;
        case 0xB4:
          sVitalPacket = sData.split(",");
          
          if (sVitalPacket != null)
          {
            lblPulse.setText("Pulse: " + sVitalPacket[0] + " BPM");
            lblSpO2.setText("SpO2: " + sVitalPacket[1] + " %");
            lblTemp.setText("Temp: " + String.format("%.2f", Float.parseFloat(sVitalPacket[2])) + "\u00B0 F");
            bNewPacket = true;
          }         
          
          break;
        default:
          break;
      }
    }
  }
}
