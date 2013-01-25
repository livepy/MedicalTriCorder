#include <SoftwareSerial.h>

SoftwareSerial btConnection = SoftwareSerial(2, 3);

void setup()
{
  Serial.begin(9600);
  btConnection.begin(38400);
}

void loop()
{
  byte bCommand;
  
  if (btConnection.available())
  {
    bCommand = btConnection.read();
    Serial.println(bCommand);
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
        btConnection.println((float)random((float)98.3, (float)103.6)); //Random temp for testing
        break;
      case 0xB4:
        //Return vital array
        break;
      default:
        break;
    }
  }
}
