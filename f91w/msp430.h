//
//  msp430.h
//  f91w
//
//  Created by e on 6/1/13.
//  Copyright (c) 2013 HALMOS. All rights reserved.
//

#ifndef f91w_msp430_h
#define f91w_msp430_h

extern unsigned char GIE;
extern unsigned char LPM3_bits;

extern char RTCSEC;
extern char RTCMIN;
extern char RTCHOUR;
extern char RTCDAY;
extern char RTCMON;
extern char RTCYEAR;
extern char RTCDOW;

extern char RTCHOLD;
extern char RTCCTL;

extern char BUILD_SECOND;
extern char BUILD_MINUTE;
extern char BUILD_HOUR;
extern char BUILD_MONTH;
extern char BUILD_YEAR;
extern char BUILD_DAY;
extern char BUILD_BCD_YEAR;

extern unsigned char TACCR0;

extern unsigned char LCDMEM[];

extern unsigned  char BIT3;
extern unsigned char P5OUT;
extern unsigned char P6IN;

extern unsigned char LCDAVCTL1;

extern unsigned char blinkFlag;
extern unsigned char speed;
extern unsigned char Hz;

extern char UIModeFlag;
extern char segOrderFlag;
extern unsigned int blinkCounter;

extern char displayModeFlag;
extern int delayLength;

void _BIS_SR(char);

void __no_operation(void);

#endif
