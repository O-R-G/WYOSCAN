//#include <msp430f4152.h>
#include "msp430.h"
#include "dexterSinister.h"
#include "dexterSinister_UI.h"
#include "LCD.h"
#include "RTC.h"



unsigned char currentMode = MODE_SHOW_TIME;
unsigned char currentSubMode = 0;
unsigned char infoAnimMask = 0x80;


/* ***************************************
   function to handle which function to run
***************************************** */
void UI_dispatchMain(void){
     while(1){
       switch(currentMode){
        case MODE_SHOW_TIME:
             clearDate();
             clearDay();
             ds_animateRTC(0,0,0);
             break;
        case MODE_SET_TIME:
             UI_showSetTime();    
             break;
        case MODE_SET_HZ:
             UI_showSetHz();
             break;
        case MODE_STOPWATCH:
             UI_showStopwatch();
             break;
        case MODE_INFO:
             UI_showInfo();
             break;
        default:
          ds_animateRTC(0,0,0);
          break;
       }
        //sleep
         //P5OUT = 0;
         _BIS_SR(LPM3_bits + GIE);  
     }//while loop
}

void UI_showSetTime(void){
     extern unsigned char blinkFlag;
    // show date and day of week
    // setDate(RTCDAY);
    // setDay(RTCDOW);
       clearDate();
       clearDay();
     switch(currentSubMode){
       case MODE_SET_TIME_HOUR:
            ds_animateRTC(1,0,0);
            break;
       case MODE_SET_TIME_MIN:
            ds_animateRTC(0,1,0);
            break; 
       case MODE_SET_TIME_SEC:
            ds_animateRTC(0,0,1);
            break; 
       case MODE_SET_DATE_MO:
            // this case is not in use
            setSecsColon(0);                // turn off colon
            setBCDHours(RTCYEAR >> 8);  // show year 20
            setBCDMins(RTCYEAR & 0xFF);    // show year 12
            if(blinkFlag == 1){             // show month and blink
              clearSecs();
            } else {
              setBCDSecs(RTCMON);
            }
            setDay(RTCDOW);    //show weekday
            setDate(RTCDAY);   // show date
            break;
     }

}

void UI_showInfo(void){
     
    switch (currentSubMode){
    case MODE_INFO_SNAKE:
         UI_showInfoSnake();
         break;
    case MODE_INFO_STAMP:
         UI_showInfoStamp();
         break;

    case MODE_INFO_HALMOS:
         UI_showInfoHalmos();
         break;
    }
}

void UI_showInfoSnake(void){
       unsigned int doubleMask;

       doubleMask = infoAnimMask;
       doubleMask = (doubleMask << 8) | infoAnimMask;
      
       setHourSegs(8,8,doubleMask);
       setMinsSegs(8,8, doubleMask);
       setSecsSegs(8,8, doubleMask);
  
       // rotate animMask - builds up digit one seg at a time and then erases one seg at a time.
       if((infoAnimMask & 1) == 1){
          infoAnimMask = infoAnimMask >> 1;
       } else {
          infoAnimMask = (infoAnimMask >> 1) | infoAnimMask;
       }
       //infoAnimMask = (infoAnimMask >> 1) ^ infoAnimMask;
       if (infoAnimMask == 0xFF) infoAnimMask = ~0x80;
       if (infoAnimMask == 0) infoAnimMask = 0x80;
  
       //infoAnimMask = (infoAnimMask >> 1) | (infoAnimMask << 7);
       //y = (x >> shift) | (x << (sizeof(x)*CHAR_BIT - shift));

}

void UI_showInfoStamp(void){
    // unsigned int temp;

    // show build date: MM:DD:YY
    setBCDHours(BUILD_MONTH);
    setMins(BUILD_DAY);
    setBCDSecs(BUILD_BCD_YEAR & 0xFF);

    setBCDDate(BUILD_HOUR);
    
}
void UI_showInfoHalmos(void){
     clearLCD();
     setHourSegs(_H_,_A_,0xFFFF);
     setMinsSegs(_L_,_M_,0xFFFF);
     setSecsSegs(0,5,0xFFFF);


}
void UI_showStopwatch(void){
     extern unsigned char RTC_SW_Secs;
     extern unsigned char RTC_SW_Mins;
     extern unsigned char RTC_SW_Hundredths;
     clearDate();
     setDay(7);

     ds_animateDigits(RTC_SW_Mins, 0, RTC_SW_Secs, 0, RTC_SW_Hundredths, 0);
    
     //setHours(RTC_SW_Mins);
     
     //setSecs(RTC_SW_Hundredths);
     //setMins(RTC_SW_Secs);

}

void UI_toggleStopwatch(void){
     // toggle between run and stop on stopwatch
     if(currentSubMode == MODE_STOPWATCH_RUN){
       currentSubMode = MODE_STOPWATCH_STOP;
     } else {
       currentSubMode = MODE_STOPWATCH_RUN;
     }

}

void UI_showSetHz(void){
     extern unsigned char blinkFlag;
     extern unsigned char speed;
     extern unsigned char Hz;

     setDay(9);   // show 'HZ'
     if(blinkFlag == 0){
       // speed ranges from 0 to 10
       // with a offset of 25
       //Hz =            
       setDate( 1000 / (25-speed) ); // conver to Hz 
     } else {
       clearDate();
     }
     ds_animateRTC(0,0,0);
}



void UI_setHz(void){
     extern unsigned char speed;

     if(speed < 1) speed = 11; // the 1 and 11 etc are just to avoid using a signed var
     speed--;
     // baseline of 1.5Hz + speed
     // thus the HZ range = 1.5Hz to 2.5Hz
     TACCR0 = (780+390+(speed * 78)); 
     //setDate(25\-speed);

}

/* ***************************************
   function to handle button events
***************************************** */

void UI_dispatchEvent(unsigned char TL, unsigned char BL, unsigned char BR){
  // light should be on whenever TL is pressed down
  //if(TL == 1) setLightOn();

  if(TL+BL+BR > 1){
      void clearLCD();
      currentMode = MODE_INFO;
      currentSubMode = MODE_INFO_SNAKE;
  }
  if(TL & BL & BR){
        // all three buttons are down - show info
        void clearLCD();
        currentMode = MODE_INFO;
        currentSubMode = MODE_INFO_SNAKE;

  } else if((BL == 1) && (TL == 0) && (BR == 0)){
        // only BL is pressed - change mode
        void clearLCD();

        switch( currentMode){
        case MODE_SHOW_TIME:
             currentMode = MODE_STOPWATCH;
             currentSubMode = MODE_STOPWATCH_STOP;
             break;
        case MODE_STOPWATCH:
             currentMode = MODE_SET_TIME;
             currentSubMode = MODE_SET_TIME_SEC;
             break;
        case MODE_SET_TIME: 
             // changeMode to show time
             currentMode = MODE_SET_HZ;
             break;
        case MODE_SET_HZ:
             currentMode = MODE_SHOW_TIME;
             break;
        default:
             currentMode = MODE_SHOW_TIME;
             break;
        }
        
  } else if((BL == 0) && (TL == 1) && (BR ==   0)){
        // TL is pressed - turn on light and if in set mode, progress to next step in set process
        if(currentMode == MODE_SET_TIME){
          switch(currentSubMode){
          case MODE_SET_TIME_SEC:
               currentSubMode = MODE_SET_TIME_HOUR;
               break;
          case MODE_SET_TIME_HOUR:
               currentSubMode = MODE_SET_TIME_MIN;
               break;
          case MODE_SET_TIME_MIN:
               currentMode = MODE_SHOW_TIME;
               currentSubMode = MODE_SET_TIME_SEC;
               break;
          /* not going to use date/year/month, etc
          case MODE_SET_DATE_MO:
               currentSubMode = MODE_SET_DATE_DATE;
               break;
          case MODE_SET_DATE_DATE:
               currentSubMode = MODE_SET_DATE_WD;
               break;
          case MODE_SET_DATE_WD:
               currentSubMode = MODE_SET_DATE_YR;
               break;
           */     
          }
        } else if(currentMode == MODE_STOPWATCH){
               // when the TL button is pressed in stopwatch mode, reset to 0
               RTC_resetStopWatch();
        } else if(currentMode == MODE_INFO){
          switch(currentSubMode){
          case MODE_INFO_SNAKE:
               currentSubMode = MODE_INFO_STAMP;
               break;
          case MODE_INFO_STAMP:
               currentSubMode = MODE_INFO_HALMOS;
               break;
          case MODE_INFO_HALMOS:
               currentSubMode = MODE_INFO_SNAKE;
               break;
          }
        }

  } else if((BL == 0) && (TL == 0) && (BR ==   1)){
        // BR is pressed - if in set mode, increment value of number being adjusted
        switch(currentMode){
        case MODE_SET_TIME:
             UI_setTime_Inc();
             break;
        case MODE_STOPWATCH:
             UI_toggleStopwatch();
             break;
        case MODE_SET_HZ:
             UI_setHz();
             break;
        }
  }
}



void UI_setTime_Inc(void){
     
     switch(currentSubMode){
     case MODE_SET_TIME_SEC:
          RTCSEC = 0;
          break;
     case MODE_SET_TIME_MIN:
          RTC_incMin();
          break;
     case MODE_SET_TIME_HOUR:
          RTC_incHour();
          break;
     case MODE_SET_DATE_MO:
          RTC_incMonth();
          break;
     case MODE_SET_DATE_YR:
          RTC_incYear();
          break;
     case MODE_SET_DATE_DATE:
          RTC_incDate();
          break;
     case MODE_SET_DATE_WD:
          RTC_incDOW();
          break;
     }

}