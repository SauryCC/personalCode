//declaration
#include <Servo.h>
#include <math.h>
const int trigPin = 2;
const int echoPin = 3;
long duration;
int distance;
int xpos;
int ypos;
String resultx = "";
String resulty = "";
// loadx
int wir15 = 22;
int wir14 = 24;
int wir13 = 26;
int wir12 = 28;
int wir11 = 30;
int wir10 = 32;
int wir9 = 34;
int wir8 = 36;
// loady
int wir7 = 31;
int wir6 = 33;
int wir5 = 35;
int wir4 = 37;
int wir3 = 39;
int wir2 = 41;
int wir1 = 43;
int wir0 = 45;

//call servo
Servo myServo;  
void setup(){
  //set up sonic sensor
  pinMode(trigPin, OUTPUT); 
  pinMode(echoPin, INPUT); 
  //attach servo to pin
  myServo.attach(4); 
  //call serial to check data
  Serial.begin(9600);
 //set up outputs of the position data for verilog						
  pinMode(wir15, OUTPUT);
  pinMode(wir14, OUTPUT);
  pinMode(wir13, OUTPUT);
  pinMode(wir12, OUTPUT);
  pinMode(wir11, OUTPUT);
  pinMode(wir10, OUTPUT);
  pinMode(wir9, OUTPUT);
  pinMode(wir8, OUTPUT);
  pinMode(wir7, OUTPUT);
  pinMode(wir6, OUTPUT);
  pinMode(wir5, OUTPUT);
  pinMode(wir4, OUTPUT);
  pinMode(wir3, OUTPUT);
  pinMode(wir2, OUTPUT);
  pinMode(wir1, OUTPUT);
  pinMode(wir0, OUTPUT);
}
void loop(){											
  xpos = 0;
  ypos = 0;

//controls the servo to spin from 0 to 180 degrees
for(int i=0;i<=180;i++){ 									
  distance = 0;

  myServo.write(i);
  delay(10);
  distance = calculateDistance();								
  xpos = 80 + distance*cos(i*3.1415926/180);						
  ypos = 60 - distance*sin(i*3.1415926/180);
  int disx = xpos;
  int disy = ypos;
  int dis = distance;
  Serial.print(i); 
  Serial.print(" --> "); 
  if(distance > 40){										
    Serial.print( "Out of range --> ");
    resultx = "00000000";
    disx = 0;
    disy = 0;
    resulty = "00000000";
  }
  else{ 
    // xpos in binary
    resultx = "";											
    while(xpos > 0){
      if((xpos % 2) == 0){
        resultx = "0" + resultx;
      }else{
        resultx = "1" + resultx;
      }
      xpos /= 2;
    }
    String temp = "";
    if (resultx != "00000000"){
       while (resultx.length() < 8){
       temp = temp + "0"; 
       resultx = temp + resultx;
       temp = "";
      }
      }
      
    // ypos in binary
    resulty = "";
    while(ypos > 0){
      if((ypos % 2) == 0){
        resulty = "0" + resulty; 
      }else{
        resulty = "1" + resulty;}
      ypos /= 2;
    }
   String tempy = "";
   
  while (resulty.length() < 8){									
     tempy = tempy + "0"; 
     resulty = tempy + resulty;
     tempy = "";
  }
   
  }
  Serial.print(resultx);
  Serial.print(" --> "); 
  Serial.print(resulty);
  Serial.print(" --> "); 
  Serial.print(distance); 
  Serial.print(" --> ");
  Serial.print(disx);
  Serial.print(" --> ");
  Serial.print(disy);
  Serial.print('\n'); /

  //////////////////////////////////////////  make binary outputs

  //x with pins declared 									
    if (resultx.charAt(7) == '1'){
    digitalWrite(wir15, HIGH); 									
  }
     if (resultx.charAt(6) == '1'){
    digitalWrite(wir14, HIGH); 
  }
     if (resultx.charAt(5) == '1'){
    digitalWrite(wir13, HIGH); 
  }
     if (resultx.charAt(4) == '1'){
    digitalWrite(wir12, HIGH); 
  }
     if (resultx.charAt(3) == '1'){
    digitalWrite(wir11, HIGH); 
  }
     if (resultx.charAt(2) == '1'){
    digitalWrite(wir10, HIGH); 
  }
     if (resultx.charAt(1) == '1'){
    digitalWrite(wir9, HIGH); 
  }
     if (resultx.charAt(0) == '1'){
    digitalWrite(wir8, HIGH); 
  }

  
  //y with pins declared 
     if (resulty.charAt(7) == '1'){
    digitalWrite(wir7, HIGH); 
  }
     if (resulty.charAt(6) == '1'){
    digitalWrite(wir6, HIGH); 
  }
  
     if (resulty.charAt(5) == '1'){
    digitalWrite(wir5, HIGH); 
  }
     if (resulty.charAt(4) == '1'){
    digitalWrite(wir4, HIGH); 
  }
     if (resulty.charAt(3) == '1'){
    digitalWrite(wir3, HIGH); 
  }
     if (resulty.charAt(2) == '1'){
    digitalWrite(wir2, HIGH); 
  }
     if (resulty.charAt(1) == '1'){
    digitalWrite(wir1, HIGH); 
  }
     if (resulty.charAt(0) == '1'){
    digitalWrite(wir0, HIGH); 
  }

  delay(100);											
  
//clear all signals to 0V								
  digitalWrite(wir15, LOW);
  digitalWrite(wir14, LOW);
  digitalWrite(wir13, LOW);
  digitalWrite(wir12, LOW);
  digitalWrite(wir11, LOW);
  digitalWrite(wir10, LOW);
  digitalWrite(wir9, LOW);
  digitalWrite(wir8, LOW);
  
  digitalWrite(wir7, LOW);
  digitalWrite(wir6, LOW);
  digitalWrite(wir5, LOW);
  digitalWrite(wir4, LOW);
  digitalWrite(wir3, LOW);
  digitalWrite(wir2, LOW);
  digitalWrite(wir1, LOW);
  digitalWrite(wir0, LOW);

  //reset disx,disy
    disx = 0;
    disy = 0;
  }

  // from 180 to 0 degrees
  for(int i=180;i>0;i--){  									
  myServo.write(i);
  delay(16);
  distance = calculateDistance();
  xpos = 80 + distance*cos(i*3.14/180);
    ypos = 60 - distance*sin(i*3.14/180);
    int disx = xpos;
   int disy = ypos;
 int dis = distance;
  Serial.print(i); // Sends the current degree into the Serial Port
  Serial.print(" --> "); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
  if(distance > 40){
    Serial.print( "Out of range --> ");
    resultx = "00000000";
    disx = 0;
    disy = 0;
    resulty = "00000000";
    
  }
  else{ 
    // xpos
    resultx = "";
    while(xpos > 0){
      if((xpos % 2) == 0){

        resultx = "0" + resultx;
        
      }else{
        resultx = "1" + resultx;
      }
      xpos /= 2;
    }
    String temp = "";
    if (resultx != "00000000"){
       while (resultx.length() < 8){
       temp = temp + "0"; 
       resultx = temp + resultx;
       temp = "";
      }
      }
  // ypos
    resulty = "";
    while(ypos > 0){
      if((ypos % 2) == 0){
        resulty = "0" + resulty; 
      }else{
        resulty = "1" + resulty;}
      ypos /= 2;
    }
   String tempy = "";
   
  while (resulty.length() < 8){
     tempy = tempy + "0"; 
     resulty = tempy + resulty;
     tempy = "";
  }
   
  }
  Serial.print(resultx);
  Serial.print(" --> "); 
  Serial.print(resulty);
  Serial.print(" --> "); 
  Serial.print(distance); 
  Serial.print(" --> ");
  Serial.print(disx);
  Serial.print(" --> ");
  Serial.print(disy);
  Serial.print('\n'); 

  ////////////////////////////////////////// x

 if (resultx.charAt(7) == '1'){
    digitalWrite(wir15, HIGH); 
  }
     if (resultx.charAt(6) == '1'){
    digitalWrite(wir14, HIGH); 
  }
     if (resultx.charAt(5) == '1'){
    digitalWrite(wir13, HIGH); 
  }
     if (resultx.charAt(4) == '1'){
    digitalWrite(wir12, HIGH); 
  }
     if (resultx.charAt(3) == '1'){
    digitalWrite(wir11, HIGH); 
  }
     if (resultx.charAt(2) == '1'){
    digitalWrite(wir10, HIGH); 
  }
     if (resultx.charAt(1) == '1'){
    digitalWrite(wir9, HIGH); 
  }
     if (resultx.charAt(0) == '1'){
    digitalWrite(wir8, HIGH); 
  }

  /////////////////////////////////////  y
     if (resulty.charAt(7) == '1'){
    digitalWrite(wir7, HIGH); 
  }
     if (resulty.charAt(6) == '1'){
    digitalWrite(wir6, HIGH); 
  }
  
     if (resulty.charAt(5) == '1'){
    digitalWrite(wir5, HIGH); 
  }
     if (resulty.charAt(4) == '1'){
    digitalWrite(wir4, HIGH); 
  }
     if (resulty.charAt(3) == '1'){
    digitalWrite(wir3, HIGH); 
  }
     if (resulty.charAt(2) == '1'){
    digitalWrite(wir2, HIGH); 
  }
     if (resulty.charAt(1) == '1'){
    digitalWrite(wir1, HIGH); 
  }
     if (resulty.charAt(0) == '1'){
    digitalWrite(wir0, HIGH); 
  }

  delay(100);
  //clear all
  digitalWrite(wir15, LOW);
  digitalWrite(wir14, LOW);
  digitalWrite(wir13, LOW);
  digitalWrite(wir12, LOW);
  digitalWrite(wir11, LOW);
  digitalWrite(wir10, LOW);
  digitalWrite(wir9, LOW);
  digitalWrite(wir8, LOW);
  
  digitalWrite(wir7, LOW);
  digitalWrite(wir6, LOW);
  digitalWrite(wir5, LOW);
  digitalWrite(wir4, LOW);
  digitalWrite(wir3, LOW);
  digitalWrite(wir2, LOW);
  digitalWrite(wir1, LOW);
  digitalWrite(wir0, LOW);
  
  xpos = 0;
  ypos = 0;
  }


  
}
// calculate the distance of the object from the sensor
int calculateDistance(){ 
  
  digitalWrite(trigPin, LOW); 
  delayMicroseconds(2);
  //Make the trigPin high for 10 ms to send signal
  digitalWrite(trigPin, HIGH); 
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  //gets the time used
  duration = pulseIn(echoPin, HIGH); 							
  //calculate distance, note unit conversion
  distance= duration*0.034/2;									
  return distance;
}
