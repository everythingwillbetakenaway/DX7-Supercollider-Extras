#include <Pozyx.h>
#include <Pozyx_definitions.h>
#include <Wire.h>

//FILTERING//
#define filterSamples   13              // filterSamples should  be an odd number, no smaller than 3
int sensSmoothArray1 [filterSamples];   // array for holding raw sensor values for sensor1 
int sensSmoothArray2 [filterSamples];   // array for holding raw sensor values for sensor2 
int sensSmoothArray3 [filterSamples];   // array for holding raw sensor values for sensor2 


int rawData1, smoothData1;  // variables for sensor1 data
int rawData2, smoothData2;  // variables for sensor1 data
int rawData3, smoothData3;  // variables for sensor1 data

////////////////////////////////////////////////
////////////////// PARAMETERS //////////////////
////////////////////////////////////////////////

uint16_t remote_id = 0x6067;                            // set this to the ID of the remote device
bool remote = false;                                    // set this to true to use the remote ID

boolean unity = true;                         // set this to true to output data for the processing sketch
int smooth = 4;
uint8_t num_anchors = 4;                                    // the number of anchors
uint16_t anchors[4] = {0x6039, 0x6002, 0x6007, 0x6043};   
int32_t anchors_x[4] = {0, 4500, 500, 4450};               // anchor x-coorindates in mm
int32_t anchors_y[4] = {0, 0, 3300, 3500};                  // anchor y-coordinates in mm
int32_t heights[4] = {1500, 1800, 1100, 2000};              // anchor z-coordinates in mm

uint8_t algorithm = POZYX_POS_ALG_UWB_ONLY;             // positioning algorithm to use. try POZYX_POS_ALG_TRACKING for fast moving objects.
uint8_t dimension = POZYX_3D;                           // positioning dimension
int32_t height = 1000;                                  // height of device, required in 2.5D positioning


////////////////////////////////////////////////

void setup(){
  Serial.begin(115200);

  if(Pozyx.begin() == POZYX_FAILURE){
  //  Serial.println(F("ERROR: Unable to connect to POZYX shield"));
//    Serial.println(F("Reset required"));
    delay(100);
    abort();
  }

  if(!remote){
    remote_id = NULL;
  }

  Pozyx.clearDevices(remote_id);
  // sets the anchor manually
  setAnchorsManual();

  printCalibrationResult();
  delay(2000);

}

void loop(){
  coordinates_t position;
  int status;
  if(remote){
    status = Pozyx.doRemotePositioning(remote_id, &position, dimension, height, algorithm);
  }else{
    status = Pozyx.doPositioning(&position, dimension, height, algorithm);
  }

  if (status == POZYX_SUCCESS){
    // prints out the result
    printCoordinates(position);
  }else{
    // prints out the error code
    printErrorCode("positioning");
  }
}


void printCoordinates(coordinates_t coor){
  smooth++;
  rawData1 = coor.x/10;
  rawData2 = coor.y/10;
  rawData3 = coor.z/10;
  smoothData1 = digitalSmooth(rawData1, sensSmoothArray1);  // every sensor you use with digitalSmooth needs its own array
  smoothData2 = digitalSmooth(rawData2, sensSmoothArray2);  // every sensor you use with digitalSmooth needs its own array
  smoothData3 = digitalSmooth(rawData3, sensSmoothArray3);  // every sensor you use with digitalSmooth needs its own array

  uint16_t network_id = remote_id;
  if (network_id == NULL){
    network_id = 0;
  }
  if(unity && (smooth%5 == 0) ){
    
    Serial.print(network_id,HEX);
    Serial.print("\n");
    Serial.print(smoothData1);
    Serial.print("\n");
    Serial.print(smoothData2);
    Serial.print("\n");
    Serial.println(smoothData3);
    
  }
}

int digitalSmooth(int rawIn, int *sensSmoothArray){     // "int *sensSmoothArray" passes an array to the function - the asterisk indicates the array name is a pointer
  int j, k, temp, top, bottom;
  long total;
  static int i;
 // static int raw[filterSamples];
  static int sorted[filterSamples];
  boolean done;

  i = (i + 1) % filterSamples;    // increment counter and roll over if necc. -  % (modulo operator) rolls over variable
  sensSmoothArray[i] = rawIn;                 // input new data into the oldest slot

  // Serial.print("raw = ");

  for (j=0; j<filterSamples; j++){     // transfer data array into anther array for sorting and averaging
    sorted[j] = sensSmoothArray[j];
  }

  done = 0;                // flag to know when we're done sorting              
  while(done != 1){        // simple swap sort, sorts numbers from lowest to highest
    done = 1;
    for (j = 0; j < (filterSamples - 1); j++){
      if (sorted[j] > sorted[j + 1]){     // numbers are out of order - swap
        temp = sorted[j + 1];
        sorted [j+1] =  sorted[j] ;
        sorted [j] = temp;
        done = 0;
      }
    }
  }

/*
  for (j = 0; j < (filterSamples); j++){    // print the array to debug
    Serial.print(sorted[j]); 
    Serial.print("   "); 
  }
  Serial.println();
*/

  // throw out top and bottom 15% of samples - limit to throw out at least one from top and bottom
  bottom = max(((filterSamples * 15)  / 100), 1); 
  top = min((((filterSamples * 85) / 100) + 1  ), (filterSamples - 1));   // the + 1 is to make up for asymmetry caused by integer rounding
  k = 0;
  total = 0;
  for ( j = bottom; j< top; j++){
    total += sorted[j];  // total remaining indices
    k++; 
    // Serial.print(sorted[j]); 
    // Serial.print("   "); 
  }

//  Serial.println();
//  Serial.print("average = ");
//  Serial.println(total/k);
  return total / k;    // divide by number of samples
}

// error printing function for debugging
void printErrorCode(String operation){
  uint8_t error_code;
  if (remote_id == NULL){
    Pozyx.getErrorCode(&error_code);
//    Serial.print("ERROR ");
//    Serial.print(operation);
//    Serial.print(", local error code: 0x");
//    Serial.println(error_code, HEX);
    return;
  }
  int status = Pozyx.getErrorCode(&error_code, remote_id);
  if(status == POZYX_SUCCESS){
//    Serial.print("ERROR ");
//    Serial.print(operation);
//    Serial.print(" on ID 0x");
//    Serial.print(remote_id, HEX);
//    Serial.print(", error code: 0x");
//    Serial.println(error_code, HEX);
  }else{
    Pozyx.getErrorCode(&error_code);
//    Serial.print("ERROR ");
//    Serial.print(operation);
//    Serial.print(", couldn't retrieve remote error code, local error: 0x");
//    Serial.println(error_code, HEX);
  }
}

// print out the anchor coordinates (also required for the processing sketch)
void printCalibrationResult(){
  uint8_t list_size;
  int status;

  status = Pozyx.getDeviceListSize(&list_size, remote_id);
//  Serial.print("list size: ");
//  Serial.println(status*list_size);

  if(list_size == 0){
    printErrorCode("configuration");
    return;
  }

  uint16_t device_ids[list_size];
  status &= Pozyx.getDeviceIds(device_ids, list_size, remote_id);

//  Serial.println(F("Calibration result:"));
//  Serial.print(F("Anchors found: "));
//  Serial.println(list_size);

  coordinates_t anchor_coor;
  for(int i = 0; i < list_size; i++)
  {
//    Serial.print("ANCHOR,");
//    Serial.print("0x");
//    Serial.print(device_ids[i], HEX);
//    Serial.print(",");
//    Pozyx.getDeviceCoordinates(device_ids[i], &anchor_coor, remote_id);
//    Serial.print(anchor_coor.x);
//    Serial.print(",");
//    Serial.print(anchor_coor.y);
//    Serial.print(",");
//    Serial.println(anchor_coor.z);
  }
}

// function to manually set the anchor coordinates
void setAnchorsManual(){
  for(int i = 0; i < num_anchors; i++){
    device_coordinates_t anchor;
    anchor.network_id = anchors[i];
    anchor.flag = 0x1;
    anchor.pos.x = anchors_x[i];
    anchor.pos.y = anchors_y[i];
    anchor.pos.z = heights[i];
    Pozyx.addDevice(anchor, remote_id);
 }
}

