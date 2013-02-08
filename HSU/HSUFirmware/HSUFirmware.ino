#include <EEPROM.h>
#include <i2cmaster.h>
#include <SoftwareSerial.h>

SoftwareSerial btConnection = SoftwareSerial(3, 4);
boolean bUseLocalSerial = false;
int scanButton = 5;
int btPowerPIN = 13;
int redRGBLEDPIN = 6;
int greenRGBLEDPIN = 7;
int blueRGBLEDPIN = 8;

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
  
  i2c_init(); //Initialise the i2c bus for temp readings
  PORTC = (1 << PORTC4) | (1 << PORTC5);//enable pullups
  
  setRGBColor(0, 255, 0);
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
  setRGBColor(0, 0, 255);
  delay(1500);
  char buffer[10];
  //THIS IS SIMULATED
  int iBPM = random(72, 85);
  //THIS IS SIMULATED
  int SpO2 = random(90, 100);
  String Temp;
  String sReturn;
  
  Temp = dtostrf(getTemp(false), 5, 2, buffer);
  
  sReturn = "ACK," + (String)iBPM + "," + (String)SpO2 + "," + Temp;
  
  if (bUseLocalSerial)
  {
    Serial.println(sReturn);
  }
  else
  {
    btConnection.println(sReturn);
  }
  
  setRGBColor(0, 255, 0);
}

float getTemp(boolean bReturnCelcius)
{
    int dev = 0x5A<<1;
    int data_low = 0;
    int data_high = 0;
    int pec = 0;
    
    i2c_start_wait(dev+I2C_WRITE);
    i2c_write(0x07);
    
    // read
    i2c_rep_start(dev+I2C_READ);
    data_low = i2c_readAck(); //Read 1 byte and then send ack
    data_high = i2c_readAck(); //Read 1 byte and then send ack
    pec = i2c_readNak();
    i2c_stop();
    
    //This converts high and low bytes together and processes temperature, MSB is a error bit and is ignored for temps
    double tempFactor = 0.02; // 0.02 degrees per LSB (measurement resolution of the MLX90614)
    double tempData = 0x0000; // zero out the data
    int frac; // data past the decimal point
    
    // This masks off the error bit of the high byte, then moves it left 8 bits and adds the low byte.
    tempData = (double)(((data_high & 0x007F) << 8) + data_low);
    tempData = (tempData * tempFactor)-0.01;
    
    float celcius = tempData - 273.15;
    float fahrenheit = (celcius*1.8) + 32;
    
    if (bReturnCelcius)
    {
      return celcius;
    }
    else
    {
      return fahrenheit;
    }
}

void setRGBColor(int iRed, int iGreen, int iBlue)
{
  analogWrite(redRGBLEDPIN, iRed);
  analogWrite(greenRGBLEDPIN, iGreen);
  analogWrite(blueRGBLEDPIN, iBlue);
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


