#include <__cross_studio_io.h>
#include <stdlib.h>
#include <msp430f4152.h>
#include "rtc.h"
#include "lcd.h"
#include "dexterSinister_UI.h"

unsigned int hundredthsCounter = 1;
unsigned char RTC_SW_Hundredths = 0;
unsigned char RTC_SW_Secs = 0;
unsigned char RTC_SW_Mins = 0;

void initRTC(void){
 // Init time
 unsigned char day;
 unsigned int year;

  RTCSEC =  BUILD_SECOND;                       // Set Seconds
  RTCMIN =  BUILD_MINUTE;                       // Set Minutes
  RTCHOUR = BUILD_HOUR;                       // Set Hours

  // Init date
  //RTCDOW =  0x02;                       // Set DOW
  
   day = BUILD_DAY;

  RTCDAY =  BUILD_DAY;                       // Set Day
  RTCMON =  BUILD_MONTH;                       // Set Month

  year = BUILD_YEAR;  // returns year in BCD format

  RTCYEAR = BUILD_BCD_YEAR;                     // Set Year
  //year = BUILD_YEAR >> (8 + BUILD_YEAR & 0xFF)
  RTCDOW = dow(BUILD_YEAR,RTCMON,RTCDAY);

  
  RTCCTL &= ~RTCHOLD;                   // Enable RTC

}

void RTC_incMin(void){
     unsigned int intMin = bcd2int(RTCMIN);
     intMin++;
     if (intMin > 59){
        intMin = 0;
     }
     RTCMIN = int2bcd(intMin);

}

void RTC_incHour(void){
     unsigned int intHour = bcd2int(RTCHOUR);
     intHour++;
     if (intHour > 23){
        intHour = 0;
     }
     RTCHOUR = int2bcd(intHour);


}

void RTC_incMonth(void){
     unsigned int intMonth= bcd2int(RTCMON);
     intMonth++;
     if(intMonth > 12){
                 intMonth = 1;
     }
     RTCMON = int2bcd(intMonth);
}

void RTC_incDOW(void){
     unsigned int intDOW = RTCDOW;
     intDOW++;
     if(intDOW>7)intDOW = 1;
     RTCDOW = intDOW;

}

void RTC_incDate(void){
      unsigned int intDate= bcd2int(RTCDAY);
     intDate++;
     if(intDate > 31){
                 intDate = 1;
     }
     RTCDAY = int2bcd(intDate);
}
void RTC_incYear(void){
      unsigned int intYear= bcd2int(RTCYEAR);
     intYear++;
     if(intYear > 3000){
                 intYear = 2012;
     }
     RTCYEAR = int2bcd(intYear);
}

int int2bcd(int dec)
{
  return ((dec/10)<<4)+(dec%10);
}

int bcd2int(int bcd)
{
return ((bcd>>4)*10)+bcd%16;
}


void testRTC(void){
    
     for(;;){
        //debug_printf("S: %d \n", RTCSEC);
       // setHours(RTCHOUR);
       // setMins(RTCMIN);
       // setSecs(RTCSEC);
        setBCDHours(RTCHOUR);
        setBCDMins(RTCMIN);
        setBCDSecs(RTCSEC);
        // Enter LPM3 w/ interrupts   
        _BIS_SR(LPM3_bits + GIE);
     
         }
}

void testStopwatch(void){
     for(;;){
      setBCDMins(RTCSEC);
      setSecs(RTC_SW_Hundredths);
      _BIS_SR(LPM3_bits + GIE);
     }
}


void RTC_incStopwatch(void){
     
  extern unsigned char currentMode;  // the current mode from the UI
  extern unsigned char currentSubMode;

  if((currentMode == MODE_STOPWATCH) && (currentSubMode == MODE_STOPWATCH_RUN)){
     // running off of TimerA1 interrupts 32 times per second
     RTC_SW_Hundredths = (hundredthsCounter * 100) / 32;
    
      hundredthsCounter++;
      if(hundredthsCounter == 32){
         // 1 tenth of second increment
         hundredthsCounter = 1;
          //P5OUT ^= BIT3;
         //toggle led
  
         RTC_SW_Secs++;
         if(RTC_SW_Secs > 59){
            RTC_SW_Secs = 0;
            RTC_SW_Mins++;
            if(RTC_SW_Mins>60){
              RTC_SW_Mins = 0;
            }
         } // if secs > 59  
      } // if hundedths > 32
  } // if currentMode
}

void RTC_resetStopWatch(void){
     RTC_SW_Secs = 0;
     RTC_SW_Mins = 0;
     RTC_SW_Hundredths = 0;
     hundredthsCounter = 0;
}

// function to find day of the week
// http://en.wikipedia.org/wiki/Determination_of_the_day_of_the_week#cite_ref-3
 int dow(int y, int m, int d)
   {
       static int t[] = {0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4};
       y -= m < 3;
       return (y + y/4 - y/100 + y/400 + t[m-1] + d) % 7;
   }
