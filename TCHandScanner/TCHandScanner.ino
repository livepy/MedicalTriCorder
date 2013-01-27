#include <EEPROM.h>
#include <SoftwareSerial.h>

SoftwareSerial btConnection = SoftwareSerial(2, 3);
boolean bUseLocalSerial = false;
int btPowerPIN = 7;

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
  }
}

void loop()
{
  byte bCommand;
  
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
      case 0xB1:
        //Return BPM
        btConnection.println(random(72, 118)); //Random BPM for testing
        break;
      case 0xB2:
        //Return O2 Sat
        btConnection.println(random(92, 100)); //Random O2 sat for testing
        break;
      case 0xB3:
        //Return Temp
        btConnection.println((float)random((float)98.3, (float)103.6)); //Random temp for testing btConnection.println((float)random((float)98.3, (float)103.6)); //Random temp for testing
        break;
      case 0xB4:
        //Return vital array
        break;
      default:
        break;
    }
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
        break;
      case 0xF2:
        //Turn BT Off
        bUseLocalSerial = true;
        EEPROM.write(0, 0);
        analogWrite(btPowerPIN, 0);
        Serial.println("OK BT OFF");
        break;          
      case 0xA1:
        //Ident Command
        Serial.println("Medical TriCorder HSU v1.0");
        break;
      case 0xA2:
        //Change PIN Command
        break;
      case 0xB1:
        //Return BPM
        Serial.println(random(72, 118)); //Random BPM for testing
        break;
      case 0xB2:
        //Return O2 Sat
        Serial.println(random(92, 100)); //Random O2 sat for testing
        break;
      case 0xB3:
        //Return Temp
        Serial.println((float)random((float)98.3, (float)103.6)); //Random temp for testing btConnection.println((float)random((float)98.3, (float)103.6)); //Random temp for testing
        break;
      case 0xB4:
        //Return vital array
        break;
      default:
        break;
    }
  }
}
