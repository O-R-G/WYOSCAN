//#include <msp430f4152.h>
#include "msp430.h"
#include "LCD.h"



/*
 a1a
f   b
6   2
 g7g
e   c
5   3
 d4d
*/

//add an abstraction layer to the segment order
// this array will allow the seg functions to turn on in a given order
// the order below will transpose the seg order to:
/* 
  a1
b2 c3
  d4
e5 f6
  g7
*/
/*
const unsigned char segOrder[7] =
{
//so that order for sure, which accdg to my numbering scheme that seems to be not the standard one, then that would be
//1,2,3,4,5,6,7
//a,f,b,g,e,c,d
  0, //1st = a
  5, //2nd = f
  1, //3rd = b
  6, //4th = g
  4, //5th = e
  2, //6th = c
  3  //7th = d
};*/ 
const unsigned char segOrder[7] =
{
//so that order for sure, which accdg to my numbering scheme that seems to be not the standard one, then that would be
//1,2,3,4,5,6,7
//a,f,b,g,e,c,d
  _a, //1st = a
  _f, //2nd = f
  _b, //3rd = b
  _g, //4th = g
  _e, //5th = e
  _c, //6th = c
  _d  //7th = d
};
const unsigned char segOrderB[7] =
{
//maybe another poss to counteract the two that light up together is (accdg to my numbering above)
//1,7,2,6,3,5,4
//a,d,f,c,b,e,g
  _a, //1st = a
  _b, //2nd = f
  _c, //3rd = b
  _d, //4th = g
  _e, //5th = e
  _f, //6th = c
  _g  //7th = d
};
const unsigned char segOrderC[7] =
{
//or
//7,1,3,4,5,6,2
//d,a,b,g,e,c,f
  _d,_a,_b,_g,_e,_c,_f
};
const char segArr[7] = 
{
  0x01, // 0 -> a
  0x02, // 1 -> b
  0x04, // 2 -> c
  0x08, // 3 -> d
  0x10, // 4 -> e 
  0x20, // 5 -> f
  0x40, // 6 -> g
};

const unsigned char digit[36] =
{
  0x01 + 0x02 + 0x04 + 0x08 + 0x10 + 0x20,  /* 0 */
  segB + segC,  /* "1" */
  segA + segB + segG + segE + segD,  /* "2" */
  segA + segB + segC + segD + segG,  /* "3" */
  segF + segG + segB + segC,  /* "4" */
  segA + segF + segG + segC + segD,  /* "5" */
  segA + segF + segG + segE+ segD + segC,  /* "6" */
  segA + segB + segC,  /* "7" */
  segA + segB + segC + segD + segE + segF + segG,  /* "8" */
  segA + segB+ segC + segD + segF + segG,   /* "9" */
  segA + segB + segC + segE + segF + segG, /* A */
  segA + segC + segD + segE + segF + segG,  /* b */
  segA + segD + segE + segF + segG,  /* "C" */
  segB + segC + segD + segE + segG,  /* "d" */
  segA + segD + segE + segF + segG,  /* "E" */
  segA + segE + segF + segG,  /* "F" */
  segA + segB + segC + segD + segF + segG,  /* "g" */
  segB + segC + segE + segF + segG,  /* "H" */
  segB + segC,  /* "I" */
  segB + segC + segD + segE,  /* "J" */
  segA + segC + segE + segF + segG,  /* "k" */
  segE + segF,  /* "l" */
  segA + segD + segG + segF + segE,   /* "M" -*/
  segA + segB + segC + segE + segF,  /* "n" */
  segA + segB + segC + segD + segE + segF,  /* "O" */
  segA + segB + segE + segF + segG,  /* "P" */
  segA + segB + segC + segF + segG,  /* "q" */
  segE + segG,  /* "r" */
  segA + segC + segD + segF + segG,  /* "S" */
  segB + segC + segG,  /* "t" */
  segB + segC + segD + segE + segF,  /* "U" */
  segC + segD + segE,  /* "v" (u) */
  0,  /* "w" not possible*/
  segB + segE  + segG,  /* "x" */
  segB + segE + segF + segG,  /* "Y" */
  segA + segB + segD + segE + segG  /* "z" */
};

/*
 a1a
f   b
6   2
 g7g
e   c
5   3
 d4d
*/

unsigned char *hoursBMemPtr[7] =
{
  &LCDMEM[10], //a
  &LCDMEM[10], //b
  &LCDMEM[10], //c
  &LCDMEM[10], //d
  &LCDMEM[10], //e
  &LCDMEM[8], //f
  &LCDMEM[10], //g
};


const char hoursBSegs[7] = 
{
  seg2, //a 
  seg6, //b
  seg5, //c 
  seg4, //d 
  seg0, //e
  seg5, //f
  seg1, //g

};

unsigned char *hoursAMemPtr[7] =
{
  &LCDMEM[9], //a
  &LCDMEM[9], //b
  &LCDMEM[9], //c
  &LCDMEM[9], //d
  &LCDMEM[9], //e
  &LCDMEM[9], //f
  &LCDMEM[9], //g
};

const char hoursASegs[7] = 
{
  seg1, //a 
  seg6, //b
  seg4, //c 
  seg1, //d 
  seg0, //e
  seg2, //f
  seg5, //g

};
unsigned char *minsAMemPtr[7] =
{
  &LCDMEM[11], //a
  &LCDMEM[11], //b
  &LCDMEM[11], //c
  &LCDMEM[11], //d
  &LCDMEM[11], //e
  &LCDMEM[11], //f
  &LCDMEM[11], //g
};

const char minsASegs[7] =
{
  seg0, //0 - a+d
  seg6, //1 - b
  seg4, //2 - c
  seg0, //3 - a+d
  seg1, //4 - e
  seg2, //5 - f
  seg5, //6 - g
};

unsigned char *minsBMemPtr[7] =
{
  &LCDMEM[0], //a
  &LCDMEM[5], //b
  &LCDMEM[0], //c
  &LCDMEM[0], //d
  &LCDMEM[0], //e
  &LCDMEM[0], //f
  &LCDMEM[0], //g
};

const char minsBSegs[7] =
{
  seg6, //0 - a+d
  seg2, //1 - b
  seg4, //2 - c
  seg0, //3 - a+d
  seg1, //4 - e
  seg2, //5 - f
  seg5, //6 - g
};

unsigned char *secsAMemPtr[7] = 
{
  &LCDMEM[1], //a
  &LCDMEM[1], //b
  &LCDMEM[2], //c
  &LCDMEM[1], //d
  &LCDMEM[1], //e
  &LCDMEM[1], //f
  &LCDMEM[1], //g
};

const char secsASegs[7] =
{
  seg2,
  seg6,
  seg0,
  seg4,
  seg0,
  seg1,
  seg5
};

unsigned char *secsBMemPtr[7] = 
{
  &LCDMEM[2], //a
  &LCDMEM[2], //b
  &LCDMEM[3], //c
  &LCDMEM[3], //d
  &LCDMEM[2], //e
  &LCDMEM[2], //f
  &LCDMEM[2], //g
};

const char secsBSegs[7] =
{
  seg2,
  seg6,
  seg1,
  seg0,
  seg4,
  seg1,
  seg5
};

unsigned char *dayAMemPtr[8] = 
{
  &LCDMEM[6], //a
  &LCDMEM[6], //b
  &LCDMEM[6], //c
  &LCDMEM[7], //d
  &LCDMEM[7], //e
  &LCDMEM[7], //f
  &LCDMEM[7], //g
  &LCDMEM[7], //|
};

const char dayASegs[8] =
{
  seg4, //a 0
  seg5, //b 1
  seg6, //c 2
  seg6, //d 3
  seg6, //e 4
  seg2, //f 5
  seg0, //g 6
  seg1, //| 7
};

unsigned char *dayBMemPtr[7] = 
{
  &LCDMEM[5], //a
  &LCDMEM[5], //b
  &LCDMEM[5], //c
  &LCDMEM[5], //d
  &LCDMEM[6], //e
  &LCDMEM[6], //f
  &LCDMEM[6], //g
};

const char dayBSegs[8] =
{
  seg4, //a 0
  seg5, //b 1
  seg5, //c 2
  seg6, //d 3
  seg1, //e 4
  seg1, //f 5
  seg2, //g 6
};


unsigned char *dateAMemPtr[7] = 
{
  &LCDMEM[4], //a
  &LCDMEM[4], //b
  &LCDMEM[4], //c
  &LCDMEM[4], //d
  &LCDMEM[5], //e
  &LCDMEM[5], //f
  &LCDMEM[4], //g
};

const char dateASegs[8] =
{
  seg5, //a 0
  seg4, //b 1
  seg6, //c 2
  seg5, //d 3
  seg0, //e 4
  0x00,   //  5
  seg5, //g 6
};

unsigned char *dateBMemPtr[7] = 
{
  &LCDMEM[3], //a
  &LCDMEM[3], //b
  &LCDMEM[3], //c
  &LCDMEM[3], //d
  &LCDMEM[4], //e
  &LCDMEM[4], //f
  &LCDMEM[4], //g
};

const char dateBSegs[8] =
{
  seg4, //a 0
  seg5, //b 1
  seg6, //c 2
  seg2, //d 3
  seg2, //e 4
  seg0, //f  5
  seg1, //g 6
};


unsigned char *segOrderPtr = &segOrder[0];



////////////////////////////////////////////////


void testLCD_contrast(void){
     char i = 1;
    for(;;){
      LCDAVCTL1 = 1 << i;
      i++;
      if(i>15) i = 1;
      //P5OUT ^= BIT3; // toggle  LED
      _BIS_SR(LPM3_bits + GIE); 
    }
}


void testLCD_bitByBit(void){
    char i = 0; // sequence through bytes in lcd mem
    int j = 0;  // sequence through bits in lcd mem
    for(;;){
     // test lcd - sequence through lcd segments - 
        LCDMEM[i] ^=  1 << j;
        j++;
        if(j > 7){
             j=0;
             i++;
             if(i > 11) i = 0;
        }
       

      // Enter LPM3 w/ interrupts   
         _BIS_SR(LPM3_bits + GIE);   

          P5OUT = 0; // turn off led if it's on
  }

}
// sequence through the lcd segments and toggle them off and on
void testLCDbySegArr(void){
     char i = 0;
     int j = 0;
     for(;;){
        P5OUT ^= BIT3; // toggle  LED
    
    
           // random junk
       
        // test lcd - sequence through lcd segments - 
        LCDMEM[i] ^=  segArr[j];
        j++;
        if(j > 7){
             j=0;
             i++;
             if(i > 11) i = 0;
        }
        // test lcd 0 sequnc   
        if(P6IN > 0){
    
                //debug_printf("button\n");
        }
        // Enter LPM3 w/ interrupts   
        _BIS_SR(LPM3_bits + GIE);     
    }
}

/* day memory format: memory.bit:
     6.4  6.0  5.4
    7 7 6     6   5
    . . .     .   .
    0 1 5     1   5
     7.5       6.2
    7 7 6     6   5
    . . .     .   .
    2 1 6     1   5
7.4  7.6       5.6

*/
void setDay(char d){
   // int k;

  // clear segments
  LCDMEM[5] &= ~(seg4 + seg5 + seg6);
  LCDMEM[6] = 0;
  LCDMEM[7] = 0;
  
  // HZ
  if(d==9){
   LCDMEM[5] |= seg6;
   LCDMEM[6] |= seg0 + seg1 + seg6;
   LCDMEM[7] |= seg0 + seg5 + seg2;
  }
    // extra = ST = stop watch
  if(d==7){
    LCDMEM[5] |= seg4;
    LCDMEM[6] |= seg0 + seg1 + seg4 + seg6;
    LCDMEM[7] |= seg0 + seg5 + seg6;
  }

  // sunday = SU
  if(d==0) {
   LCDMEM[5] |= seg6 + seg5;
   LCDMEM[6] |= seg4 + seg6 + seg1;
   LCDMEM[7] |= seg0 + seg6 + seg5;
  
  }

  // monday = MO
  if(d==1) {
    LCDMEM[5] |= seg4 + seg5 + seg6;
    LCDMEM[6] |= seg4 + seg5 + seg6 + seg1;
    LCDMEM[7] |= seg2 + seg0 + seg1;
  }

  // tuesday = TU
  if(d==2){
    LCDMEM[5] |= seg6 + seg5;
    LCDMEM[6] |= seg4 + seg1;
    LCDMEM[7] |= seg1;
  }

  // wednesday = WE
  if(d==3){
    LCDMEM[5] |= seg6 + seg4;
    LCDMEM[6] |= seg1 + seg2 + seg5 + seg6;
    LCDMEM[7] |= seg0 + seg2 + seg1 + seg6;

  }
  // thursday = TH
  if(d==4){
    LCDMEM[7] |= seg1;
    LCDMEM[6] |= seg4 + seg1 + seg2;
    LCDMEM[5] |= seg5;
  }
  
  // friday = FR
  if(d==5){
    LCDMEM[7] |= seg5 + seg0 + seg2;
    LCDMEM[6] |= seg4 + seg1 + seg2;
    LCDMEM[5] |= seg5 + seg4;
  }

  // Saturday = SA
  if(d==6){
    LCDMEM[5] |= seg4 + seg5;
    LCDMEM[6] |= seg4 + seg6 + seg1 + seg2;
    LCDMEM[7] |= seg0 + seg5 + seg6;
  }


    // extra = L = length
  if(d==8){
    //LCDMEM[5] |= seg6 + seg4;
    //LCDMEM[6] |= seg1 + seg2;
    LCDMEM[7] |= seg0 + seg2 + seg6;
  }
  

}

void clearDay(void){
 // clear segments
  LCDMEM[5] &= ~(seg4 + seg5 + seg6);
  LCDMEM[6] = 0;
  LCDMEM[7] = 0;

}


/*****************************
  Set the Minute digits using BCD formated input
 ****************************/
void setBCDHours(char num){
  char digitA = 0;
  char digitB = 0;

    digitA = (num>>4); // high nibble
    digitB = (num&0x0F); // low nibble

  // set segments
  setHourSegs(digitA, digitB, 0xFFFF);

}

/*****************************
  Set the Hour digits with decimal input 
 ****************************/
void setHours(char num){
  // int k;
  char digitA = 0;
  char digitB = 0;

  // clear digit
  /*
  for(k=0; k < 7; k++){
    *hoursAMemPtr[k] &= ~(*hoursASegs[k]);
    *hoursBMemPtr[k] &= ~(*hoursBSegs[k]);
  }
*/
  // get first and second digit
  if(num > 9){
    digitA = num/10;
    digitB = num%10;
  } else {
    digitA = 0;
    digitB = num;
  }

  // set segments
  setHourSegs(digitA, digitB, 0xFFFF);
}

void clearHours(void){
     char k;
   for(k=0; k < 7; k++){
    *hoursAMemPtr[k] &= ~hoursASegs[k];
    *hoursBMemPtr[k] &= ~hoursBSegs[k];
  }
}
/*****************************
  Set the Hour segments 
 ****************************/
void setHourSegs(char digitA, char digitB, unsigned int segMask){
     extern unsigned char blinkFlag;
     
    // unsigned int mask;
    unsigned int k, subMaskA, subMaskB;
    unsigned char segNum = 0;
    unsigned char bit = 0;
     subMaskA = segMask >> 7;     // get upper niblle
     subMaskB = segMask & 0x7F;  // get lower nibble
     
    // clear segments before setting new ones
    for(k=0;k<7;k++){
      segNum = segOrder[k]; 
      *hoursAMemPtr[segNum] &= ~hoursASegs[segNum];
      *hoursBMemPtr[segNum] &= ~hoursBSegs[segNum];
    }

 
      for(k = 0; k < 7; k++){
        //segNum = segOrder[k]; 
        segNum = *(segOrderPtr+k);
       // mask = (digit[digitA] & segArr[segNum]);// & subMaskA);
       
       // convert the digit segment into an absolute lcd position
       // and see if it is within the mask area 
         bit = 1 << (6-k);
        
         // digitA 
         if (subMaskA & bit ){
            // if it is in animMask see if this digit segment should be on
            if ((digit[digitA] & segArr[segNum]) > 0) {
              // set segment
               *hoursAMemPtr[segNum] |= *hoursAMemPtr[segNum] | hoursASegs[segNum];
               __no_operation();
            }
         }
  
         // digit B
         if (subMaskB & bit){
           if ((digit[digitB] & segArr[segNum]) > 0){
             *hoursBMemPtr[segNum] |= *hoursBMemPtr[segNum] | hoursBSegs[segNum];
           }
         }
         
      }// for loop
 

  __no_operation();
}


/*****************************
  Set the Minute digits using BCD formated input
 ****************************/
void setBCDMins(char num){
  char digitA = 0;
  char digitB = 0;

    digitA = (num>>4); // high nibble
    digitB = (num&0x0F); // low nibble

  // set segments
  setMinsSegs(digitA, digitB, 0xFFFF);

}


/*****************************
  Set the Minute digits
 ****************************/
void setMins(char num){

  char digitA = 0;
  char digitB = 0;

  // get first and second digit
  if(num > 9){
    digitA = num/10;
    digitB = num%10;
  } else {
    digitA = 0;
    digitB = num;
  }

  // set segments
 setMinsSegs(digitA, digitB, 0xFFFF);


}

void clearMins(void){
     char k;
     for(k=0;k<7;k++){
      *minsAMemPtr[k] &= ~minsASegs[k];
      *minsBMemPtr[k] &= ~minsBSegs[k];
    }


}
/*****************************
  Set the Minute digits segments
 ****************************/

void setMinsSegs(char digitA, char digitB, unsigned int segMask){
  //TODO because there are only 7 segments the mask doesn't align with nibbles
    // unsigned int mask;
    unsigned int k, subMaskA, subMaskB;
     unsigned char segNum = 0;
     unsigned char bit = 0;
     subMaskA = segMask >> 7;     // get upper niblle
     subMaskB = segMask & 0x7F;  // get lower nibble
     
    // clear segments before setting new ones
    for(k=0;k<7;k++){
      segNum = segOrder[k]; 
      *minsAMemPtr[segNum] &= ~minsASegs[segNum];
      *minsBMemPtr[segNum] &= ~minsBSegs[segNum];
    }

    for(k = 0; k < 7; k++){
      //segNum = segOrder[k]; 
        segNum = *(segOrderPtr+k);   
     // convert the digit segment into an absolute lcd position
     // and see if it is within the mask area 
       bit = 1 << (6-k);
      
       // digitA 
       if (subMaskA & bit ){
          // if it is in animMask see if this digit segment should be on
          if ((digit[digitA] & segArr[segNum]) > 0) {
            // set segment
             *minsAMemPtr[segNum] |= *minsAMemPtr[segNum] | minsASegs[segNum];
             __no_operation();
          } 
       }

       // digit B
       if (subMaskB & bit){
         if ((digit[digitB] & segArr[segNum]) > 0){
           *minsBMemPtr[segNum] |= *minsBMemPtr[segNum] | minsBSegs[segNum];
         }
       }
       
    }

  __no_operation();
}

/*****************************
  Set the Seconds digits with a BCD formated char as input
 ****************************/
void setBCDSecs(char num){
 
  char digitA = 0;
  char digitB = 0;

    digitA = (num>>4); // high nibble
    digitB = (num&0x0F); // low nibble

  // set segments
  setSecsSegs(digitA, digitB, 0xFFFF);

}


/*****************************
  Set the Seconds digits with a decimal char as input
 ****************************/

void setSecs(char num){
 
  char digitA = 0;
  char digitB = 0;


  // get first and second digit
  if(num > 9){
    digitA = num/10;
    digitB = num%10;
  } else {
    digitA = 0;
    digitB = num;
  }

  setSecsSegs(digitA, digitB, 0xFFFF);
/*
  if(modeFlag == mill){
    if(millColonFlag == 0){
     LCDMEM[8] &= ~colon;   // toggle second colon
    } else if(millColonFlag == 1){
      LCDMEM[8] |= colon;   // toggle second colon
    }
   }else{
    if(lostColonFlag == 0){
      LCDMEM[8] &= ~colon;   // toggle second colon
    } else if(lostColonFlag == 1){
      LCDMEM[8] |= colon;   // toggle second colon
    }
   }
*/
}

void clearSecs(void){
    char k;

    for(k=0;k<7;k++){ 
      *secsAMemPtr[k] &= ~secsASegs[k];
      *secsBMemPtr[k] &= ~secsBSegs[k];
    }

}
/*****************************
  Set the second digits segments
 ****************************/

void setSecsSegs(char digitA, char digitB, unsigned int segMask){
  //TODO because there are only 7 segments the mask doesn't align with nibbles
    // unsigned int mask;
    unsigned int k, subMaskA, subMaskB;
     unsigned char segNum = 0;
     unsigned char bit = 0;
     subMaskA = segMask >> 7;     // get upper niblle
     subMaskB = segMask & 0x7F;  // get lower nibble
     
    // clear segments before setting new ones
    for(k=0;k<7;k++){
      segNum = segOrder[k]; 
      *secsAMemPtr[segNum] &= ~secsASegs[segNum];
      *secsBMemPtr[segNum] &= ~secsBSegs[segNum];
    }

    for(k = 0; k < 7; k++){
      //segNum = segOrder[k]; 
       segNum = *(segOrderPtr+k);     
     // convert the digit segment into an absolute lcd position
     // and see if it is within the mask area 
       bit = 1 << (6-k);
      
       // digitA 
       if (subMaskA & bit ){
          // if it is in animMask see if this digit segment should be on
          if ((digit[digitA] & segArr[segNum]) > 0) {
            // set segment
             *secsAMemPtr[segNum] |= *secsAMemPtr[segNum] | secsASegs[segNum];
             __no_operation();
          }
       }

       // digit B
       if (subMaskB & bit){
         if ((digit[digitB] & segArr[segNum]) > 0){
           *secsBMemPtr[segNum] |= *secsBMemPtr[segNum] | secsBSegs[segNum];
         }
       }
       
    }

  __no_operation();
}


/*****************************
  Set the Seconds segments for each digit
 ****************************/
/*
void setSecsSegs(char digitA, char digitB, int segMask){
     int mask, k,  subMaskA, subMaskB;
     subMaskA = segMask >> 8;     // get upper niblle
     subMaskB = segMask & 0xFF;  // get lower nibble

// set segments
  for(k = 0; k < 7; k++){
    mask = (digit[digitA] & segArr[k] & subMaskA);
    if (mask > 0) *secsAMemPtr[k] |=  secsASegs[k];
    if (mask == 0) *secsAMemPtr[k] &= ~secsASegs[k];
    k=k;
  }

  for(k = 0; k < 7; k++){
    mask = (digit[digitB] & segArr[k] & subMaskB);
    if (mask > 0) *secsBMemPtr[k] |= secsBSegs[k];
    if (mask == 0) *secsBMemPtr[k] &= ~secsBSegs[k];
    k=k;
  }

}*/

/*****************************
  Set the Seconds colon on or off
 ****************************/
void setSecsColon(char state){

    if(state == 0){
     LCDMEM[8] &= ~colon;   // turn colon off
    } else if(state == 1){
      LCDMEM[8] |= colon;   // turn colon on
    } else if(state == 2){
      // -1 means to toggle colon
      LCDMEM[8] ^= colon;
    }


}

void setDate(char num){
  int k;
  int mask;
  char digitA = 0;
  char digitB = 0;

  clearDate();

  // get first and second digit
  if(num > 9){
    digitA = num/10;
    digitB = num%10;
  } else {
    digitA = 0;
    digitB = num;
  }

  // set segments
  if(digitA > 0){
    for(k = 0; k < 7; k++){
      mask = (digit[digitA] & segArr[k]);
      if (mask > 0) *dateAMemPtr[k] |=  dateASegs[k];
     
    }
  }

  for(k = 0; k < 7; k++){
    mask = (digit[digitB] & segArr[k]);
    if (mask > 0) *dateBMemPtr[k] |= dateBSegs[k];
    
  }
}

void setBCDDate(char num){
  int k;
  int mask;
  char digitA = 0;
  char digitB = 0;

    digitA = (num>>4); // high nibble
    digitB = (num&0x0F); // low nibble

 // set segments
  if(digitA > 0){
    for(k = 0; k < 7; k++){
      mask = (digit[digitA] & segArr[k]);
      if (mask > 0) *dateAMemPtr[k] |=  dateASegs[k];
     
    }
  }

  for(k = 0; k < 7; k++){
    mask = (digit[digitB] & segArr[k]);
    if (mask > 0) *dateBMemPtr[k] |= dateBSegs[k];
    
  }

}

void clearDate(void){
 char k;
 // clear digit
  for(k=0; k < 7; k++){
    *dateAMemPtr[k] &= ~(dateASegs[k]);
    *dateBMemPtr[k] &= ~(dateBSegs[k]);
  }
}

/********************************************
 convenience function to set hours, minutes
 all at once
 ********************************************/
void showTime(char hours, char mins, char secs){
     setHours(hours);
     setMins(mins);
     setSecs(secs);
}

 void clearLCD(void)
 {
    int i;
     for (i=0; i<14; ++i)                     // clear
      LCDMEM[i] = 0;
 }

 void testLCD(void)
 {
    int i;
     for (i=0; i<14; ++i)                     // clear
      LCDMEM[i] = 0xFF;
 }

