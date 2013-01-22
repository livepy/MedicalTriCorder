int pulsePin = 0;                 // Pulse Sensor purple wire connected to analog pin 0
int blinkPin = 13;                // pin to blink led at each beat
int fadePin = 5;                  // pin to do fancy classy fading blink at each beat

volatile int BPM;                   // used to hold the pulse rate
volatile int Signal;                // holds the incoming raw data
volatile int IBI = 600;             // holds the time between beats, the Inter-Beat Interval
volatile boolean Pulse = false;     // true when pulse wave is high, false when it's low
volatile boolean QS = false;        // becomes true when Arduoino finds a beat.

void setup()
{
  Serial.begin(9600);
  
  pinMode(blinkPin, OUTPUT);         // pin that will blink to your heartbeat!
  pinMode(fadePin, OUTPUT);          // pin that will fade to your heartbeat!
  
  interruptSetup();
}

void loop()
{
  if (QS)
  {
    Serial.print("BPM: ");
    Serial.println(BPM);
    Serial.print("IBI: ");
    Serial.println(IBI);
    delay(1500);
  }
  else
  {
    Serial.println("No Contact");
    delay(1500);
  }
}
