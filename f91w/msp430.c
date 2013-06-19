//
//  msp430.c
//  f91w
//
//  Created by e on 6/1/13.
//  Copyright (c) 2013 HALMOS. All rights reserved.
//

#include <stdio.h>
#include "msp430.h"


// init globals

char unsigned GIE = 0;
char unsigned LPM3_bits = 0;

char RTCSEC = 0;
char RTCMIN = 0;
char RTCHOUR = 0;
char RTCDAY = 0;
char RTCMON = 0;
char RTCYEAR = 0;
char RTCDOW = 0;

char RTCHOLD = 0;
char RTCCTL = 0;

char BUILD_SECOND = 0;
char BUILD_MINUTE = 0;
char BUILD_HOUR = 0;
char BUILD_MONTH = 0;
char BUILD_YEAR = 0;
char BUILD_DAY = 0;
char BUILD_BCD_YEAR = 0;

unsigned char TACCR0 = 0;

unsigned char LCDMEM[12];

unsigned char BIT3 = 0;
unsigned char P5OUT = 0;
unsigned char P6IN = 0;

unsigned char LCDAVCTL1;

unsigned char Hz = 0;

char displayModeFlag = 0;
int delayLength = 0;


char UIModeFlag = 0;
char segOrderFlag = 1;
unsigned char speed = 5;         // represents 10ths of Hz of anim sequence speed
unsigned int blinkCounter = 0;
unsigned char blinkFlag = 0;

void _BIS_SR(char c){

}

void __no_operation(void){
    
}
