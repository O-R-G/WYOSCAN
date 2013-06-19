#ifndef FILE_DS_SEEN
#define FILE_DS_SEEN

#define segCount = 42; 

void ds_test(void);
void ds_init(void);

void ds_animateDigits(unsigned char hours, unsigned char blinkHoursFlag, unsigned char mins, unsigned char blinkMinsFlag, unsigned char secs, unsigned char blinkSecsFlag);
void ds_animateRTC(unsigned char, unsigned char, unsigned char);
void setTrailLength(unsigned char);
void wrapAnimMask(void);
#endif /* FILE_DS_SEEN */
