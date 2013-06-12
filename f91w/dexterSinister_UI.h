#ifndef FILE_DSUI_SEEN
#define FILE_DSUI_SEEN

#define MODE_SET_TIME 10
#define MODE_SET_TIME_SEC 11
#define MODE_SET_TIME_HOUR 12
#define MODE_SET_TIME_MIN 13

#define MODE_SET_DATE 20
#define MODE_SET_DATE_MO 21
#define MODE_SET_DATE_DATE 22
#define MODE_SET_DATE_WD 23
#define MODE_SET_DATE_YR 24

#define MODE_SET_HZ 30

#define MODE_STOPWATCH 40
#define MODE_STOPWATCH_RUN 41
#define MODE_STOPWATCH_STOP 42

#define MODE_BACK-DOOR 50

#define MODE_INFO 60
#define MODE_INFO_SNAKE 61
#define MODE_INFO_STAMP 62
#define MODE_INFO_HALMOS 63

#define MODE_SHOW_TIME 70

void UI_dispatchEvent(unsigned char, unsigned char, unsigned char);
void UI_dispatchMain(void);
void UI_showSetTime(void);
void UI_showSetHz(void);
void UI_setTimeMode(void);

void UI_showInfoSnake(void);
void UI_showInfoStamp(void);
void UI_showInfoHalmos(void);


#endif /*FILE_DSUI_SEEN */