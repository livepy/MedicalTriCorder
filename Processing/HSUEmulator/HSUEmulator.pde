import javax.swing.ImageIcon;
import processing.serial.*;
import controlP5.*;

public class HSUEmulator extends PApplet
{
  private String sEmulatorName = "Medical TriCorder HSU Emulator v1.0";
  private boolean bluetoothOn = true;
  private boolean serialCon = false;
  private boolean initComplete = false;
  private DropdownList dlSerialPort;
  private Button cmdConnect;
  private ControlP5 cp5;
  private Serial HSUPort;
  private byte[] appIcon;
  
  public static void main(String args[]) 
  {
      PApplet.main(new String[] { "HSUEmulator" });
  }
  
  void setup()
  {
    size(400, 130);
    
    frame.setTitle(sEmulatorName);
    
    appIcon = loadBytes("ic.png");
    
    if (appIcon != null)
    {
      frame.setIconImage(new ImageIcon(appIcon).getImage());
    }
   
    cp5 = new ControlP5(this);
    //cp5.setControlFont(createFont("Arial", 8));
  
    dlSerialPort = cp5.addDropdownList("dlSerialPort");
    dlSerialPort.setPosition(10, 20);
    dlSerialPort.setSize(250, 120);
    dlSerialPort.setBarHeight(15);
    dlSerialPort.setItemHeight(20);
    dlSerialPort.captionLabel().set("Available Serial Ports");
    dlSerialPort.captionLabel().style().marginTop = 3;
    dlSerialPort.captionLabel().style().marginLeft = 3;
    dlSerialPort.valueLabel().style().marginTop = 3;
    
    cmdConnect = cp5.addButton("cmdConnect");
    cmdConnect.setValue(0);
    cmdConnect.setPosition(280, 4);
    cmdConnect.setSize(100, 15);
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
    String sReturn = "";
    
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
        sReturn += (int)random(72, 85) + "," + (int)random(90, 100) + "," + random(98.0, 101.0) + "\n";

        HSUPort.write(sReturn);
        break;
      default:
        break;    
    }
  }
}
