# 3D AHRS BLE

Rotate a 3D model using Euler Angles.

## Getting Started

For the BLE connection use the following format:
Pitch (double) + ',' + Roll (double) + ',' + Yaw (double) + '\n'
In C: 
sprintf(BLETx, "%0.2f, %0.2f, %0.2f\n", pitch, roll, yaw);
