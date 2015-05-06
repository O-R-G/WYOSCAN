#ifndef FILE_RTC_SEEN
#define FILE_RTC_SEEN


void initRTC(void);
void testRTC(void);
void testStopwatch(void);
int dow(int, int, int);
void RTC_incMin(void);
void RTC_incHour(void);
void RTC_incMonth(void);
void RTC_incDOW(void);
void RTC_incDate(void);
void RTC_incYear(void);

int int2bcd(int);
int bcd2int(int);
void RTC_resetStopWatch(void);


#endif /*FILE_RTC_SEEN */
