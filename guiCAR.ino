// Declaring motor pins
int m1 = 4;
int m2 = 5;
int m3 = 6;
int m4 = 7;

// Variable for storing bluetooth signal and speed input
char bluetoothInput;
int speedInput;

// Variables for non-blocking delays
unsigned long previousTime = 0;
unsigned long delayDuration = 0;
bool isDelayActive = false;

void setup() {
  // Motor Pins as Output
  pinMode(m1, OUTPUT);
  pinMode(m2, OUTPUT);
  pinMode(m3, OUTPUT);
  pinMode(m4, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(11, OUTPUT);

  // Starting Serial Monitor
  Serial.begin(9600);
}

void loop() {

    if (Serial.available()) {
      
      while (Serial.available()) {
        bluetoothInput = Serial.read();
        Serial.println(bluetoothInput);
        
        if (bluetoothInput == 'R') {
          int RightInput = Serial.parseInt();
          Serial.println(RightInput);
          right();
          int duration = RightInput * 1000;
          startDelay(duration);
        }
      
        else if (bluetoothInput == 'F') {  // Case for Moving Forward
          int ForwardInput = Serial.parseInt();
          Serial.print(ForwardInput);
          forward();
          int duration = ForwardInput * 1000;
          startDelay(duration);
        }

        else if (bluetoothInput == 'G') {  // Case for Moving Backward
          int BackwardInput = Serial.parseInt();
          Serial.print(BackwardInput);
          backward();
          int duration = BackwardInput * 1000;
          startDelay(duration);
        }

        else if (bluetoothInput == 'L') {  // Case for Moving Left
          int LeftInput = Serial.parseInt();
          Serial.print(LeftInput);
          left();
          int duration = LeftInput * 1000;
          startDelay(duration);
        }

        else if (bluetoothInput == 'S') {  // Case for Stop
          stop();
        }

        else if (bluetoothInput == 'V') {
          speedInput = Serial.parseInt();
          Serial.print(speedInput);
          analogWrite(10, speedInput);
          analogWrite(11, speedInput);
        }
      }
    }
  

  // Check if a delay is active
  if (isDelayActive && millis() - previousTime >= delayDuration) {
    isDelayActive = false;
    stop();
  }
}

// Helper function to start a non-blocking delay
void startDelay(unsigned long duration) {
  isDelayActive =  true;
  previousTime = millis();
  delayDuration = duration;
}

// car to move forward Function
void right() {
  digitalWrite(m1, LOW);
  digitalWrite(m2, HIGH);
  digitalWrite(m3, HIGH);
  digitalWrite(m4, LOW);
}

// car to move backward Function
void left() {
  digitalWrite(m1, HIGH);
  digitalWrite(m2, LOW);
  digitalWrite(m3, LOW);
  digitalWrite(m4, HIGH);
}

// car to move left Function
void backward() {
  digitalWrite(m1, HIGH);
  digitalWrite(m2, LOW);
  digitalWrite(m3, HIGH);
  digitalWrite(m4, LOW);
}

// car to move right Function
void forward() {
  digitalWrite(m1, LOW);
  digitalWrite(m2, HIGH);
  digitalWrite(m3, LOW);
  digitalWrite(m4, HIGH);
}

// car to stop Function
void stop() {
  digitalWrite(m1, LOW);
  digitalWrite(m2, LOW);
  digitalWrite(m3, LOW);
  digitalWrite(m4, LOW);
}