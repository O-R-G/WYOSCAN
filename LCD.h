#ifndef FILE_LCD_SEEN
#define FILE_LCD_SEEN

#define segA 0x01
#define segB 0x02
#define segC 0x04
#define segD 0x08
#define segE 0x10
#define segF 0x20
#define segG 0x40

#define seg0 0x01
#define seg1 0x02
#define seg2 0x04
#define seg3 0x08
#define seg4 0x10
#define seg5 0x20
#define seg6 0x40

/*
 a1a
f   b
6   2
 g7g
e   c
5   3
 d4d
*/

#define _a 0
#define _b 1
#define _c 2
#define _d 3
#define _e 4
#define _f 5
#define _g 6

#define _A_ 10
#define _B_ 11
#define _C_ 12
#define _D_ 13
#define _E_ 14
#define _F_ 15
#define _G_ 16
#define _H_ 17
#define _I_ 18
#define _J_ 19
#define _K_ 20
#define _L_ 21
#define _M_ 22
#define _N_ 23
#define _O_ 24
#define _P_ 25
#define _Q_ 26
#define _R_ 27
#define _S_ 28
#define _T_ 29
#define _U_ 30
#define _V_ 31
#define _W_ 32
#define _X_ 33
#define _Y_ 34
#define _Z_ 35

#define sound 0x10
#define alarm 0x01
#define H24 0x04
#define colon 0x02
#define lap 0x01
#define PM 0x40





void testLCD(void);
void clearLCD(void);

void setBCDHours(char);
void setHours(char);
void setHourSegs(char, char, unsigned int);
void clearHours(void);

void setBCDMins(char);
void setMins(char);
void setMinsSegs(char, char, unsigned int);
void clearMins(void);

void setSecs(char);
void setBCDSecs(char);
void setSecsSegs(char, char, unsigned int);
void clearSecs(void);

void setSecsColon(char);

void showTime(char, char, char);

void setDay(char);
void clearDay(void);

void setDate(char);
void setBCDDate(char);
void clearDate(void);

void testLCD_bitByBit(void);
void testLCD_contrast(void); 

#endif /* FILE_LCD_SEEN */
