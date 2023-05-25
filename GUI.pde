import controlP5.*;
import processing.serial.*;

Serial port;

ControlP5 cp5;
PFont font;

Button forward, right, left, backward, stop, connectButton, disconnectButton;
Slider Bcolor1, Bcolor2, Bcolor3;
Textfield Duration;
Knob speedKnob;
Textlabel timeLabel;
DropdownList comList; 

int speed = 100;

int bColor1 = 0;
int bColor2 = 0;
int bColor3= 0;

void setup() {
  size(900, 600);
  smooth();

  printArray(Serial.list());
  
  cp5 = new ControlP5(this);
  font = createFont("calibri", 36);
     
  cp5.addGroup("movingbackground")
     .setPosition(140, 50)
     .addCanvas(new Background());
  
  forward = cp5.addButton("ForwardButton")
     .setPosition(360, 90)
     .setSize(200, 80)
     .setFont(font)
     .setCaptionLabel("FORWARD");
     
  stop = cp5.addButton("StopButton")
     .setPosition(360, 171)
     .setSize(200, 80)
     .setFont(font)
     .setCaptionLabel("STOP");
     
  backward = cp5.addButton("BackwardButton")
     .setPosition(360, 252)
     .setSize(200, 80)
     .setFont(font)
     .setCaptionLabel("BACKWARD");
     
  left = cp5.addButton("LeftButton")
     .setPosition(159, 171)
     .setSize(200, 80)
     .setFont(font)
     .setCaptionLabel("LEFT");
     
  right =cp5.addButton("RightButton")
     .setPosition(561, 171)
     .setSize(200, 80)
     .setFont(font)
     .setCaptionLabel("RIGHT");
     
  Duration = cp5.addTextfield("DurationToRun")
     .setPosition(360, 340)
     .setSize(200, 55)
     .setAutoClear(false)
     .setFocus(true)
     .setColor(color(0))
     .setFont(font);
  Duration.setColorBackground(color(255));   
  Duration.getCaptionLabel().setVisible(false); // Hide the label
  
  // Create a Textlabel
  timeLabel = cp5.addTextlabel("myLabel")
                .setPosition(140, 350)
                .setFont(font)
                .setColor(color(0))
                .setText("Enter Duration");

  Bcolor1 = cp5.addSlider("bColor1")
    .setPosition(10, 350)
    .setSize(20, 150)
    .setRange(0, 255);
     
  Bcolor2 = cp5.addSlider("bColor2")
    .setPosition(50, 350)
    .setSize(20, 150)
    .setRange(0, 255);
     
  Bcolor3 = cp5.addSlider("bColor3")
    .setPosition(90, 350)
    .setSize(20, 150)
    .setRange(0, 255);
  
  // Add Connect button
  connectButton = cp5.addButton("connect")
     .setPosition(140, 50)
     .setSize(200, 80)
     .setColorForeground(color(0, 204, 0))
     .setColorBackground(color(0))
     .setFont(font)
     .setLabel("Connect");
     
  // Add Disconnect button
  disconnectButton = cp5.addButton("disconnect")
     .setPosition(570, 50)
     .setSize(200, 80)
     .setColorForeground(color(204, 0, 0))
     .setColorBackground(color(0))
     .setLabel("Disconnect")
     .setFont(font)    ;
     
   // Create the COM port dropdown list
  comList = cp5.addDropdownList("comList")
     .setPosition(350, 200)
     .setSize(200, 200)
     .setLabelVisible(false);
  
  comList.setItemHeight(50);
  comList.setFont(createFont("Arial", 30)); // Set the font size of the arrow
  comList.setBarHeight(50);
  
  speedKnob = cp5.addKnob("SpeedValue")
              .setRange(0, 255)
              .setValue(220)
              .setPosition(395, 405)
              .setRadius(70)
              .setNumberOfTickMarks(30)
              .setTickMarkLength(4)
              .setColorForeground(color(255))
              .setColorBackground(color(0))
              .setColorActive(color(255, 255, 0))
              .setDragDirection(Knob.HORIZONTAL);

  // Intially hide all these 
  forward.hide();
  backward.hide();
  left.hide();
  right.hide();
  speedKnob.hide();
  Duration.hide();
  stop.hide();
  timeLabel.hide();
  
  // Populate the dropdown list with available COM ports
  String[] availablePorts = Serial.list();
  for (int i = 0; i < availablePorts.length; i++) {
    comList.addItem(availablePorts[i], i);
  }
   
}

void draw() {
  textFont(font);
  background(bColor1, bColor2, bColor3);
  fill(0, 0, 0);
}

void ForwardButton() {
  sendCommand('F');
}

void BackwardButton() {
  sendCommand('G');
}

void LeftButton() {
  sendCommand('L');

}
void StopButton()
{
  sendCommand('S');
}
void RightButton()
{
  sendCommand('R');
}
void sendCommand(char command) {
  String value = cp5.get(Textfield.class, "DurationToRun").getText();
  int numericValue = int(value);

  // Send the command and numeric value to the Arduino via the Bluetooth module
  port.write(command);
  port.write(String.valueOf(numericValue));

  // Print the command and value to the console
  println("Command sent: " + command);
  println("Value sent: " + numericValue);
}

void SpeedValue(int value) {
  speed = value; // update the speed value when the slider is moved

  // Convert the speed value to a string
  String speedValue = str(speed);

  // Send the command and speed value to the Arduino via the Bluetooth module
  port.write('V'); // Send a command to indicate the speed value is being sent
  port.write(speedValue); // Send the speed value as a string

  // Print the command and value to the console
  println("Command sent: V");
  println("Value sent: " + speedValue);
}


void connect() {
  // Get the selected COM port from the dropdown list
  int selectedPortIndex = int(comList.getValue());
  String selectedPort = comList.getItem(selectedPortIndex).get("name").toString();

  // Configure the Bluetooth settings
  String deviceAddress = selectedPort;  // Use the selected COM port
  int baudRate = 9600;  // Replace with the appropriate baud rate

  // Establish a serial connection
  port = new Serial(this, deviceAddress, baudRate);
  println("Connected to Arduino Bluetooth car.");
  
  forward.show();
  backward.show();
  left.show();
  right.show();
  speedKnob.show();
  Duration.show();
  stop.show();
  timeLabel.show();
  
  // Hide the connect button and COM port dropdown list
  connectButton.hide();
  comList.hide();
  
  
}

void disconnect() {
  // Close the serial connection
  if (port != null) {
    port.stop();
    port = null;
    println("Disconnected from Arduino Bluetooth car.");
    

    forward.hide();
    backward.hide();
    left.hide();
    right.hide();
    speedKnob.hide();
    Duration.hide();
    stop.hide();
    timeLabel.hide();
  
    // Show the connect button and COM port dropdown list
    connectButton.show();
    comList.show();
  }
}

class Background extends Canvas {
  
  float n;
  float a;
  
  public void setup(PGraphics pg) {
    println("starting a test canvas.");
    n = 1;
  }
  public void draw(PGraphics pg) {
    n += 0.01;
    pg.ellipseMode(CENTER);
    pg.fill(lerpColor(color(0,100,200),color(0,200,100),map(sin(n),-1,1,0,1)));
    pg.rect(0,0,630,510);
    pg.fill(255,150);
    a+=0.01;
    ellipse(350,200,abs(sin(a)*350),abs(sin(a)*350));
    ellipse(160,350,abs(sin(a+0.5)*200),abs(sin(a+0.5)*200));
    ellipse(100,140,abs(cos(a)*180),abs(cos(a)*180));
    ellipse(500,100,abs(cos(a)*100),abs(cos(a)*100));
    ellipse(500,400,abs(cos(a)*80),abs(cos(a)*80));
  }
}
