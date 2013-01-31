#include <EEPROM.h>
#include <SoftwareSerial.h>

SoftwareSerial btConnection = SoftwareSerial(2, 3);
boolean bUseLocalSerial = false;
int btPowerPIN = 7;
int scanButton = 4;

void setup()
{
  Serial.begin(38400);
  
  if (EEPROM.read(0) == 1)
  {
    bUseLocalSerial = false;
  }
  else if (EEPROM.read(0) == 0)
  {
    bUseLocalSerial = true;
  }
  
  pinMode(btPowerPIN, OUTPUT);
  pinMode(scanButton, INPUT);
  
  if (bUseLocalSerial)
  {
    Serial.println("RDY BT OFF");
    analogWrite(btPowerPIN, 0);
  }
  else
  {
    Serial.println("RDY BT ON");
    analogWrite(btPowerPIN, 255);
    btConnection.begin(38400);
    btConnection.println("RDY BT ON");
  }
}

void loop()
{
  byte bCommand;
  
  if (digitalRead(scanButton))
  {
    if (bUseLocalSerial)
    {
      Serial.println("SCN");
      getSensorData();
    }
    else
    {
      btConnection.println("SCN");
      getSensorData();
    }
  }
  
  if (btConnection.available())
  {
    bCommand = btConnection.read();

    switch (bCommand)
    {
      case 0xA1:
        //Ident Command
        btConnection.println("Medical TriCorder HSU v1.0");
        break;
      case 0xA2:
        //Change PIN Command
        break;
      default:
        break;
    }
  }
}

void getSensorData()
{
  //THIS IS ALL SIMULATED
  delay(1500);
  int iBPM = random(72, 85);
  int SpO2 = random(90, 100);
  int Temp = random(98, 101);
  String sReturn;
  
  sReturn = "ACK," + (String)iBPM + "," + (String)SpO2 + "," + (String)Temp;
  
  if (bUseLocalSerial)
  {
    Serial.println(sReturn);
  }
  else
  {
    btConnection.println(sReturn);
  }
}

void serialEvent()
{
  byte bCommand;
  
  if (Serial.available())
  {
    bCommand = Serial.read();
    
    switch (bCommand)
    {
      case 0xF0:
        //Return BT Status
        if (bUseLocalSerial)
        {
          Serial.println("BT OFF");
        }
        else
        {
          Serial.println("BT ON");
        }
        break;
      case 0xF1:
        //Turn BT On
        bUseLocalSerial = false;
        EEPROM.write(0, 1);
        analogWrite(btPowerPIN, 255);
        Serial.println("OK BT ON");
        btConnection.begin(38400);   
        break;
      case 0xF2:
        //Turn BT Off
        bUseLocalSerial = true;
        EEPROM.write(0, 0);
        analogWrite(btPowerPIN, 0);
        Serial.println("OK BT OFF");
        btConnection.end();
        break;          
      case 0xA1:
        //Ident Command
        Serial.println("Medical TriCorder HSU v1.0");
        break;
      case 0xA2:
        //Change PIN Command
        break;
      default:
        break;
    }
  }
}


