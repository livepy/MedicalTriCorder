import processing.serial.*;
import controlP5.*;

ControlP5 cp5;
ListBox serialList;
String[] sPortList;

void setup()
{
  size(600, 520);
 
  cp5 = new ControlP5(this);
  sPortList = Serial.list();
  
  serialList = cp5.addListBox("lstSerialPorts")
    .setPosition(10, 20)
    .setSize(120, 120)
    .setBarHeight(15)
    .setItemHeight(15);
  
  serialList.captionLabel().set("Available Serial Ports");
  serialList.captionLabel().style().marginTop = 3;
  serialList.valueLabel().style().marginTop = 3;
  
  for (int i = 0; i < sPortList.length; i++)
  {
    serialList.addItem(sPortList[i], i);
  }
}

void controlEvent(ControlEvent theEvent) 
{
  if (theEvent.isGroup()) 
  {
    // an event from a group e.g. scrollList
    println(theEvent.group().value()+" from "+theEvent.group());
  }
  
  if(theEvent.isGroup() && theEvent.name().equals("serialList"))
  {
    int test = (int)theEvent.group().value();
    println("Selected Index: " + test);
  }
}

void draw() 
{
  background(128);
  
  if (keyPressed && key==' ') 
  {
    serialList.setWidth(mouseX);
  }
}
