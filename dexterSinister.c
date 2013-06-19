//#include <msp430f4152.h>
#include "msp430.h"
#include "dexterSinister.h"
#include "LCD.h"

/*****************************
  Set the Seconds segments for each digit
 ****************************/

          // 
unsigned int trailLength = 8; // max length is 20
unsigned char oldRTCSEC = 0;

unsigned long trailMask = 0xFFFFFFFF;

unsigned long long animMask = 0; // to hold 42 bits
 

char lastDigitPlace = 0;
char lastSegPlace = 0;

extern char digit[];
extern char segArr[];

void initDS(void){
     char i;
     // init animMask


}

/*
void shiftAnimMask(void){
     char i;
     testMask = 0xFF >> 1;

     for(i=41; i>0; i--){
             animMask[i] = animMask[i-1]; 
     }

}*/

void ds_test(void){
     extern char displayModeFlag;
     extern int delayLength;
     int i;

     setTrailLength(11);
     //setDate(RTCDAY);
     //setDay(RTCDOW);

     for(;;){
       if(displayModeFlag == 0){
       //ds_animate(0,0,0);
       // turn on led
       //P5OUT ^= BIT3;
         // Enter LPM3 w/ interrupts   
        // for(i=0; i<delayLength; i++){
                  _BIS_SR(LPM3_bits + GIE);   
         //} // for i loop
       } // if displayModeFlag
     } // for loop
}

void ds_init(void){
     setTrailLength(trailLength);
}


void ds_animateDigits(unsigned char hours, unsigned char blinkHoursFlag, unsigned char mins, unsigned char blinkMinsFlag, unsigned char secs, unsigned char blinkSecsFlag){
     // animation runs at faster rate than time updates
     // therefor - make an animated mask for the time
  unsigned char digitA = 0;
  unsigned char digitB = 0;
  unsigned int animHoursMask;
  unsigned int animMinsMask;
  unsigned int animSecsMask;
  extern unsigned char blinkFlag;

  if((blinkHoursFlag == 1)){
    if(blinkFlag == 1){
       animHoursMask =  0xFFFF;
    }else{
      animHoursMask = 0;
    }
  } else {
    animHoursMask = (animMask >> 28) & 0x3FFF;
  }
  if((blinkMinsFlag == 1)){
    if(blinkFlag == 1){                
     animMinsMask =  0xFFFF;
    }else{
      animMinsMask = 0;
    }
  }else{
    animMinsMask = (animMask >> 14) & 0x3FFF;
  }
  if(blinkSecsFlag == 1){
    if(blinkFlag == 1){                
       animSecsMask =  0xFFFF;
    }else{
      animSecsMask = 0;
    }
  }else{
    animSecsMask = animMask & 0x3FFF;
  }

  if(hours > 9){
    digitA = hours/10;
    digitB = hours%10;
  } else {
    digitA = 0;
    digitB = hours;
  }

  // set segments
  setHourSegs(digitA, digitB, animHoursMask);

  if(mins > 9){
    digitA = mins/10;
    digitB = mins%10;
  } else {
    digitA = 0;
    digitB = mins;
  }

  // set segments
  setMinsSegs(digitA, digitB, animMinsMask);

  if(secs > 9){
    digitA = secs/10;
    digitB = secs%10;
  } else {
    digitA = 0;
    digitB = secs;
  }

  // set segments
  setSecsSegs(digitA, digitB, animSecsMask);

    //bitshift the mask
     animMask = animMask >> 1;
     if(animMask == 0) {
     
       wrapAnimMask();
        __no_operation();
     }
     // blink sec colon
     if (oldRTCSEC != RTCSEC){
        // second has lapsed, toggle sec colon
        setSecsColon(2);
        oldRTCSEC = RTCSEC;
      }

}

void ds_animateRTC(unsigned char blinkHoursFlag, unsigned char blinkMinsFlag, unsigned char blinkSecsFlag){
     // animation runs at faster rate than time updates
     // therefor - make an animated mask for the time
  char digitA = 0;
  char digitB = 0;
  unsigned int animHoursMask;
  unsigned int animMinsMask;
  unsigned int animSecsMask;
  extern unsigned char blinkFlag;

  if((blinkHoursFlag == 1)){
    if(blinkFlag == 1){
       animHoursMask =  0xFFFF;
    }else{
      animHoursMask = 0;
    }
  } else {
    animHoursMask = (animMask >> 28) & 0x3FFF;
  }
  if((blinkMinsFlag == 1)){
    if(blinkFlag == 1){                
     animMinsMask =  0xFFFF;
    }else{
      animMinsMask = 0;
    }
  }else{
    animMinsMask = (animMask >> 14) & 0x3FFF;
  }
  if(blinkSecsFlag == 1){
    if(blinkFlag == 1){                
       animSecsMask =  0xFFFF;
    }else{
      animSecsMask = 0;
    }
  }else{
    animSecsMask = animMask & 0x3FFF;
  }
 

    digitA = (RTCHOUR>>4); // high nibble
    digitB = (RTCHOUR&0x0F); // low nibble

  // set segments
  setHourSegs(digitA, digitB, animHoursMask);

    digitA = (RTCMIN>>4); // high nibble
    digitB = (RTCMIN&0x0F); // low nibble

  // set segments
  setMinsSegs(digitA, digitB, animMinsMask);

    digitA = (RTCSEC>>4); // high nibble
    digitB = (RTCSEC&0x0F); // low nibble

  // set segments
  setSecsSegs(digitA, digitB, animSecsMask);

    //bitshift the mask
     animMask = animMask >> 1;
     if(animMask == 0) {
     
       wrapAnimMask();
        __no_operation();
     }
     // blink sec colon
     if (oldRTCSEC != RTCSEC){
        // second has lapsed, toggle sec colon
        setSecsColon(2);
        oldRTCSEC = RTCSEC;
      }

}

/* *************************************
   Function to set the length of the trail
   ************************************* */
void setTrailLength(unsigned char length){
     int shiftAmount = 0;
     if(length > 20) length = 20;
     if(length < 1) length = 1;
     trailMask = 0xFFFFFFFF >> (32 - length);
     trailLength = length;
    // if (trailLength == 42) trailLength = 0;

    

     if(trailLength > 20) trailLength = 20; // max trail length is 10 otherwise it exceeds the length of the 64bit animMask
     wrapAnimMask();
      __no_operation();
   
}
/* *************************************
   Function to wrap bit mask back to beginning
   ************************************* */
void wrapAnimMask(void){
     unsigned int shiftAmount;
     shiftAmount = 41;//(42 + trailLength - 10);
     animMask = 0;
     animMask = (animMask | trailMask) << shiftAmount; 
     __no_operation();
}
