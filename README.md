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