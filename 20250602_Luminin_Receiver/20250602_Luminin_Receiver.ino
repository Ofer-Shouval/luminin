// Wiring / Arduino Code
// Code for sensing a switch status and writing the value to the serial port.

#include <ESP8266WiFi.h>
#include <espnow.h>

#include <Arduino_JSON.h>

unsigned long startMillis;
unsigned long currentMillis;
const unsigned long period = 50;

typedef struct data_struct {
  

  float zTilt;
  float totalAcc;
  float lerpedGyroX;
  float lerpedGyroY; 
  int upJolt;
  int downJolt;
  int forwardJolt;
  int backJolt; 
  int button; 
    
} data_struct;

data_struct accelData;

void OnDataRecv(uint8_t * mac, uint8_t *incomingData, uint8_t len) {
  memcpy(&accelData, incomingData, sizeof(accelData));
  
}

void setup() {
  Serial.begin(9600);
  
  WiFi.mode(WIFI_STA);
  WiFi.disconnect();

//
   if (esp_now_init() != 0) {
    Serial.println("Error initializing ESP-NOW");
    return;
  }
  
  // Once ESPNow is successfully Init, we will register for recv CB to
  // get recv packer info
  esp_now_set_self_role(ESP_NOW_ROLE_SLAVE);
  esp_now_register_recv_cb(OnDataRecv);
}

void loop() {

currentMillis = millis();

if(currentMillis - startMillis >= period){

JSONVar accelJson;

//accelJson[0] = accelData.xTilt;
//accelJson[1] = accelData.yTilt;
accelJson[0] = accelData.zTilt;
accelJson[1] = accelData.totalAcc;
accelJson[2] = accelData.lerpedGyroX;
accelJson[3] = accelData.lerpedGyroY; ;
//accelJson[6] = accelData.lerpedGyroZ;
//accelJson[7] = accelData.totalGyro;
accelJson[4] = accelData.upJolt;
accelJson[5] = accelData.downJolt;
accelJson[6] = accelData.forwardJolt;
accelJson[7] = accelData.backJolt;
//accelJson[12] = accelData.vibes;
accelJson[8] = accelData.button;


String jsonString = JSON.stringify(accelJson);

Serial.println(jsonString);


    startMillis = currentMillis;
}


 
}
