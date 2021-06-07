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
## Screenshots
![Screenshot_20210506-191216](https://user-images.githubusercontent.com/84541098/121091501-770e3480-c7c0-11eb-95c3-7cd4e254a070.jpg)
![Screenshot_20210607-170251](https://user-images.githubusercontent.com/84541098/121091503-783f6180-c7c0-11eb-8cdd-5b2885bf9822.jpg)
![Screenshot_20210607-170258](https://user-images.githubusercontent.com/84541098/121091504-783f6180-c7c0-11eb-9c44-b50cebcf5d3b.jpg)
![Screenshot_20210607-180035](https://user-images.githubusercontent.com/84541098/121091506-78d7f800-c7c0-11eb-9f16-aebab1d121b5.jpg)
