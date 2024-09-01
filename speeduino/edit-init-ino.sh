#!/bin/bash

new_mapping="      pinInjector1 = PE14;
      pinInjector2 = PE15;
      pinInjector3 = PB12;
      pinInjector4 = PD8;
      pinInjector5 = PG8;
      pinInjector6 = PG7;
      pinInjector7 = PG6;
      pinInjector8 = PG5;
      pinCoil1 = PE3;
      pinCoil2 = PE2;
      pinCoil3 = PD13;
      pinCoil4 = PD12;
      pinCoil5 = PG4;
      pinCoil6 = PG3;
      pinCoil7 = PG2;
      pinCoil8 = PD15;
      pinTrigger = PE5;
      pinTrigger2 = PE4;
      pinCLT = PA0;
      pinTPS = PA1;
      pinMAP = PA2;
      pinBat = PC3;
      pinO2 = PA3;
      pinIAT = PA4;
      pinStepperDir = PE9;
      pinStepperStep = PE8;
      pinStepperEnable = PE10;
      pinTachOut = PD9;
      pinFan = PD10;
      pinFuelPump = PD11;
      pinIdle1 = PE11; // AUX1
      pinIdle2 = PE12; // AUX2
      pinBoost = PE13; // AUX3"

awk -v start="case 60:" -v end="break;" -v new="$new_mapping" '
  {
    if ($0 ~ start) {
      inside_block = 1;
      print $0;
      next;
    }
    if (inside_block) {
      if ($0 ~ end) {
        print new;
        inside_block = 0;
      } else {
        next;
      }
    }
    print $0;
  }
' speeduino/init.ino > temp_init && mv temp_init speeduino/init.ino

sed -i 's/setPinMapping(3)/setPinMapping(60)/' speeduino/init.ino
sed -i 's/setPinMapping(configPage2.pinMapping)/setPinMapping(60)/' speeduino/init.ino
