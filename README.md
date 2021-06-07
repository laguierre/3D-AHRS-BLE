# 3D AHRS BLE

Rotate a 3D model using Euler Angles.

## Getting Started

For the BLE connection use the following format:
Pitch (double) + ',' + Roll (double) + ',' + Yaw (double) + '\n'.

## UART Over BLE & Battery Services
```C
sprintf(BLETx, "%0.2f, %0.2f, %0.2f\n", pitch, roll, yaw);

#define SERVICE_UUID                  "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
#define CHARACTERISTIC_UUID_RX        "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
#define CHARACTERISTIC_UUID_TX        "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"
#define SERVICE_UUID_BATTERY          BLEUUID((uint16_t)0x180F)
#define CHARACTERISTIC_UUID_BATTERY   BLEUUID((uint16_t)0x2A19)
```
## Screensho![Screenshot_20210506-191216](https://user-images.githubusercontent.com/84541098/121090943-b425f700-c7bf-11eb-9a57-d6d949ed0c4f.jpg)
![Screenshot_20210607-170251](https://user-images.githubusercontent.com/84541098/121090952-b5572400-c7bf-11eb-8674-25becd86b869.jpg)
![Screenshot_20210607-170258](https://user-images.githubusercontent.com/84541098/121090954-b5efba80-c7bf-11eb-92b6-2901059bfa26.jpg)
![Screenshot_20210607-180035](https://user-images.githubusercontent.com/84541098/121090959-b6885100-c7bf-11eb-8207-7f127e3c989d.jpg)
ts
