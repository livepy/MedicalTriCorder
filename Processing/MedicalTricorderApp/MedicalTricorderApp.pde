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
  
  final int Ident = 0;
  final int BluetoothStatus = 1;
  final int BluetoothOn = 2;
  final int BluetoothOff = 3;
  final int SetPIN = 4;
  final int BPM = 5;
  final int SPO2 = 6;
  final int Temp = 7;
  final int VitalPacket = 8;
  
  public static void main(String args[]) 
  {
    PApplet.main(new String[] { "MedicalTricorderApp" });
  }
  
  void setup()
  {
    size(600, 520);
  
    ControlP5.printPublicMethodsFor(ControlTimer.class);
    frame.setTitle("Medical TriCorder");
    appIcon = loadBytes("tricorder.png");
    
    if (appIcon != null)
    {
      frame.setIconImage(new ImageIcon(appIcon).getImage());
    }
    
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
    
    controlTimer = new ControlTimer();
    controlTimer.setSpeedOfTime(1);
    
    initComplete = true;
  }
  
  void draw() 
  {
    background(128);
    line(0, 40, 620, 40);
    
    int time = Integer.parseInt(controlTimer.toString().substring(10, 12));
    
    if (bConnectedToHSU)
    {
      if (time >= 1)
      {
        //Determine a better way to do this. Maybe get VPs working?
        if (sStatus == "NONE")
        {
          getBPM();
        }
        
        if (sStatus == "BPM")
        {
          getSPO2();
        }
        
        if (sStatus == "SPO2")
        {      
          getTemp();
        }
        
        if (sStatus == "TEMP")
        {
          sStatus = "NONE";
        }
        
        controlTimer.reset();
      }
    }
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
        lastRequest = Ident;
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
  
  void getBPM()
  {
    HSUConnection.write(0xB1);
    lastRequest = BPM;
  }
  
  void getSPO2()
  {
    HSUConnection.write(0xB2);
    lastRequest = SPO2;
  }
  
  void getTemp()
  {
    HSUConnection.write(0xB3);
    lastRequest = Temp; 
  }
  
  void serialEvent(Serial p)
  {
    String sData = p.readStringUntil('\n');
    
    if (sData != null)
    {
      sData = sData.replace("\n", "");
    }
    
    switch(lastRequest)
    {
      case Ident:
        lblHSUModel.setText("HSU Model: " + sData);
        break;
      case BPM:
        lblPulse.setText("Pulse: " + sData + " BPM");
        sStatus = "BPM";
        break;
      case SPO2:
        lblSpO2.setText("SpO2: " + sData + "%");
        sStatus = "SPO2";
        break;
      case Temp:
        lblTemp.setText("Temp: " + sData + " F");
        sStatus = "TEMP";
        break;
      default:
        break;
    }
  }
}
