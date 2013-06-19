//
//  f91w.h
//  f91w
//
//  Created by e on 6/1/13.
//  Copyright (c) 2013 HALMOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "display.h"

/*
  TACCR0 = (780+390+(speed * 78)); 
  
  780 = 32768 / 42(segments) = 1 hz animation sequence
  watch is set to default to run at .5 hz (2 times per sec)
  780 = 1hz, 390 = .5hz, speed = 5, 5 * 78 = 390
  780 + 390 + 390 = 1560 = .5 hz = mid hz = 2x/sec
  min = 780 + 390 + 0 = 1170 = 2 hz = 
  max = 780 + 390 + 780 = 1950 = .25 hz
 
 780 = 1Hz
 1170 = 1.5Hz = speed 0
 1560 = .5Hz = speed 5
 1950 = .4Hz = speed 10
 */
static const NSTimeInterval  kScheduledTimerInSeconds      = 1.0f/21.0f;


@interface f91w : NSObject{
    // declare ivars here
    NSTimer *msp430Timer;						// timer to call back msp430 functions
    NSTimer *displayTimer;						// timer to update display Emulator
    display *f91wDisplay;
    float f91wSpeed;
    float f91wHz;
}

@property (nonatomic) float f91wSpeed;

- (float) f91wSpeed;
- (void) setF91wSpeed: (float)newSpeed;

- (id) initWithDisplay: (display*)aDisplay;
- (void) initTimers;
- (void) msp430TimerCallback;
- (void) displayTimerCallback;
- (void) updateDisplay;
- (NSString *)intToBinary:(int)Number;


@end
