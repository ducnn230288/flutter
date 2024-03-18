#!/bin/bash
sleep 10
# Connect to the Android emulator container.
adb connect emulator:5555

#List the available Flutter devices. You should see the connected dockerized emulator.
adb wait-for-device
bash waiting-for-boot.sh

# Install the Flutter packages.
flutter channel stable
flutter upgrade --force
flutter pub cache repair
flutter clean
flutter pub get


flutter test integration_test -d emulator:5555
