
#include <esp_now.h>
#include <WiFi.h>
#include <Arduino.h>
#include <TinyMPU6050.h>
MPU6050 mpu(Wire);


//NeoPixel Library
#include <Adafruit_GFX.h>
#include <Adafruit_NeoMatrix.h>
#include <Adafruit_NeoPixel.h>
#ifndef PSTR
#define PSTR  // Make Arduino Due happy
#endif

#define PIN 33


int buttonPin = 4;
int buttonState;

int width = 8;
int height = 4;
int timer = 0;
boolean sleepMode = 1;

Adafruit_NeoMatrix matrix = Adafruit_NeoMatrix(4, 8, PIN,
                                               NEO_MATRIX_TOP + NEO_MATRIX_RIGHT + NEO_MATRIX_COLUMNS + NEO_MATRIX_PROGRESSIVE,
                                               NEO_GRB + NEO_KHZ800);










//initialize accelerometer variables
float accelX = 0;
float accelY = 0;
float accelZ = 0;
float accTotal = 0;

//initialize gyro variables
float gyroX = 0;
float gyroY = 0;
float pGyroY = 0;

float gyroZ = 0;

float gyroTotal = 0;

//smoothed + latched accelerometer variables
float lerpedAccelZ = 0;
float lerpedAccelY = 0;
float lerpedAccelX = 0;

float lerpedAccTotal = 0;
float latchedAccTotal = 0;

//smoothed + latched accelerometer variables
float lerpedGyroX = 0;
float lerpedGyroY = 0;
float lerpedGyroZ = 0;

float lerpedGyroTotal = 0;
float latchedGyroTotal = 0;

//Motion Variables
/*  
 *   If headstock is:
 *   Jolted Down       Gyro X spikes to ~ -500
 *   Jolted Up         Gyro X spikes to ~  500
 *   Jolted Forward    Gyro Y Spikes to ~  500
 *   Jolted Back       Gyro Y spikes to ~ -500
 */
float downJolt = 0;
float upJolt = 0;
float forwardJolt = 0;
float backJolt = 0;


//Milli loop variable declaration
unsigned long startMillis;
unsigned long currentMillis;
const unsigned long period = 50;


// REPLACE WITH YOUR RECEIVER MAC Address
uint8_t broadcastAddress1[] = { 0xF4, 0xCF, 0xA2, 0xD8, 0x16, 0x3f };
uint8_t broadcastAddress2[] = { 0x24, 0x62, 0xAB, 0x14, 0xBA, 0x86};

//24:62:ab:14:ba:86
// Structure example to send data
// Must match the receiver structure
typedef struct struct_message {

  //  float xTilt;
  //float yTilt;
  float zTilt;
  float totalAcc;
  float lerpedGyroX;
  float lerpedGyroY;
  // float lerpedGyroZ;
  //  int totalGyro;
  int upJolt;
  int downJolt;
  int forwardJolt;
  int backJolt;
  int button;

} struct_message;




// Create a struct_message called myData
struct_message myData;

esp_now_peer_info_t peerInfo;

// callback when data is sent
void OnDataSent(const uint8_t *mac_addr, esp_now_send_status_t status) {
  char macStr[18];
  Serial.print("Packet to: ");
  // Copies the sender mac address to a string
  snprintf(macStr, sizeof(macStr), "%02x:%02x:%02x:%02x:%02x:%02x",
           mac_addr[0], mac_addr[1], mac_addr[2], mac_addr[3], mac_addr[4], mac_addr[5]);
  Serial.print(macStr);
  Serial.print(" send status:\t");
  Serial.println(status == ESP_NOW_SEND_SUCCESS ? "Delivery Success" : "Delivery Fail");
}

void setup() {

  pinMode(buttonPin, INPUT);

  matrix.begin();
  matrix.setBrightness(100);

  
  // Init Serial Monitor
  Serial.begin(115200);
  mpu.Initialize();

  // Set device as a Wi-Fi Station
  WiFi.mode(WIFI_STA);

  if (esp_now_init() != ESP_OK) {
    Serial.println("Error initializing ESP-NOW");
    return;
  }
  
  esp_now_register_send_cb(OnDataSent);
   
  // register peer
  peerInfo.channel = 0;  
  peerInfo.encrypt = false;
  // register first peer  
  memcpy(peerInfo.peer_addr, broadcastAddress1, 6);
  if (esp_now_add_peer(&peerInfo) != ESP_OK){
    Serial.println("Failed to add peer");
    return;
  }
  // register second peer  
  memcpy(peerInfo.peer_addr, broadcastAddress2, 6);
  if (esp_now_add_peer(&peerInfo) != ESP_OK){
    Serial.println("Failed to add peer");
    return;
  }
}

void loop() {
  // Set values to send

  mpu.Execute();
  accelZ = mpu.GetAccZ();
  accelY = mpu.GetAccY();
  accelX = mpu.GetAccX();

  pGyroY = gyroY;

  gyroX = mpu.GetGyroX();
  gyroY = mpu.GetGyroY();
  gyroZ = mpu.GetGyroZ();

  //totalling

  accTotal = sqrt(sq(accelX) + sq(accelY) + sq(accelZ));
  gyroTotal = sqrt(sq(gyroX) + sq(gyroY) + sq(gyroZ));

  lerpedAccelZ = flerp(accelZ, lerpedAccelZ, 10);
  lerpedAccelY = flerp(accelY, lerpedAccelY, 10);
  lerpedAccelX = flerp(accelX, lerpedAccelX, 10);

  lerpedGyroZ = flerp(gyroZ, lerpedGyroZ, 30);
  lerpedGyroY = flerp(gyroY, lerpedGyroY, 30);
  lerpedGyroX = flerp(gyroX, lerpedGyroX, 30);

  lerpedAccTotal = flerp(accTotal, lerpedAccTotal, 5);

  lerpedGyroTotal = flerp(gyroTotal, lerpedGyroTotal, 40);

  //create a latched version of
  if (accTotal > 2.5 && latchedAccTotal < 10) {
    latchedAccTotal = lerpedAccTotal * lerpedAccTotal * lerpedAccTotal;
  }
  latchedAccTotal *= .98;
  //-------------------------------------------------------------------------------------------------------

  if (gyroX < -350) {
    downJolt = abs(gyroX);
  }

  if (gyroX > 350) {
    upJolt = gyroX;
  }

  if (gyroY > 400) {
    forwardJolt = gyroY;
  }

  if (gyroY < -400) {
    backJolt = abs(gyroY);
  }

  downJolt *= .98;
  upJolt *= .98;
  forwardJolt *= .98;
  backJolt *= .98;

  buttonState = digitalRead(buttonPin);

//LEDs
   for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {


          int baseGradient = (int)(cos(x * x + (currentMillis * 0.005)) * 50);
          uint16_t pixColor = 20 * (1 + baseGradient * (downJolt / 100)) + (x + y) * 500 + 1.6 * mapf(lerpedAccelZ, -1, 1, 0, 65536);  //20*(1+baseGradient*latchedAccTotal) +  (x+y) * 500 + 1.6 * mapf(lerpedAccelZ, -1, 1, 0, 65536);



          matrix.setPixelColor(indexCalc(x, y), matrix.ColorHSV(pixColor, 255, 20 + ((downJolt) / 2)));
        }
      }


      matrix.show();

  //set struct values to input
  myData.zTilt = lerpedAccelZ;
  //not super useful
  myData.totalAcc = latchedAccTotal;

  //for wider movements
  myData.lerpedGyroX = lerpedGyroX;
  myData.lerpedGyroY = lerpedGyroY;


  //specific motions;
  myData.upJolt = round(upJolt);
  myData.downJolt = round(downJolt);
  myData.forwardJolt = round(forwardJolt);
  myData.backJolt = round(backJolt);
  myData.button = buttonState;

  //print all data to debug
  Serial.print(myData.zTilt);
  Serial.print(",");
  Serial.print(myData.totalAcc);
  Serial.print(",");
  Serial.print(myData.lerpedGyroX);
  Serial.print(",");
  Serial.print(myData.lerpedGyroY);
  Serial.print(",");
  Serial.print(myData.upJolt);
  Serial.print(",");
  Serial.print(myData.downJolt);
  Serial.print(",");
  Serial.print(myData.forwardJolt);
  Serial.print(",");
  Serial.print(myData.backJolt);
  Serial.print(",");
  Serial.print(myData.button);
  Serial.println();



  //send ESPNOW data
    esp_err_t result = esp_now_send(0, (uint8_t *) &myData, sizeof(myData));
  //esp_err_t result = esp_now_send(broadcastAddress1, (uint8_t *) &myData, sizeof(myData));

  //confirm data was sent successfully
  if (result == ESP_OK) {
    Serial.println("Sent with success");
  } else {
    Serial.println("Error sending the data");
  }
  delay(50);
}



float mapf(float x, float in_min, float in_max, float out_min, float out_max) {
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}


float absf(float x) {
  if (x >= 0) {
    return x;
  } else {
    return -x;
  }
}


float flerp(float a, float b, float tau) {
  return a / tau + b * (1 - 1 / tau);
}

int indexCalc(int x, int y) {

  return y * width + x;
}