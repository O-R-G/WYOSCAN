//
//  f91w.m
//  f91w
//
//  Created by e on 6/1/13.
//  Copyright (c) 2013 HALMOS. All rights reserved.
//

#import "f91w.h"
#import "msp430.h"
#import "LCD.h"
#import "display.h"
#import "dexterSinister.h"
#import "dexterSinister_UI.h"
#import "RTC.h"

@implementation f91w


- (id) initWithDisplay:(display*)aDisplay
{
    if (self = [super init]){
        f91wDisplay = aDisplay;
        self.f91wSpeed = 2;
        [self initTimers];
         ds_init();
    }
    return self;
}

- (void) initTimers
{
    
    msp430Timer = [NSTimer timerWithTimeInterval:1.f/21.f
									target:self
								  selector:@selector(msp430TimerCallback)
								  userInfo:nil
								   repeats:YES];
	
	[[NSRunLoop currentRunLoop] addTimer:msp430Timer forMode:NSDefaultRunLoopMode];
    
    
    /*displayTimer = [NSTimer timerWithTimeInterval:kScheduledTimerInSeconds
                                          target:self
                                        selector:@selector(displayTimerCallback)
                                        userInfo:nil
                                         repeats:YES];
	
	[[NSRunLoop currentRunLoop] addTimer:displayTimer forMode:NSDefaultRunLoopMode];*/
    
    
}

- (void) msp430TimerCallback
{

  
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    
    NSInteger hour= [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    // run the c code
    RTCSEC = int2bcd((char)second);
    RTCMIN = int2bcd((char)minute);
    RTCHOUR = int2bcd((char)hour);

    ds_animateRTC(0,0,0);
    [self updateDisplay];
    
}
- (void) displayTimerCallback
{
    [self updateDisplay];
    
}

/* Method to read the LCDMEM array and update the LCD emulation */
- (void) updateDisplay
{
    
    [f91wDisplay setNeedsDisplay];
    
}


- (float) f91wSpeed
{
    return f91wSpeed;
    
}
- (void) setF91wSpeed:(float)newSpeed
{
    //NSLog(@"New Speed: %f", newSpeed);
    f91wSpeed = newSpeed;
    f91wHz = 1.0f/f91wSpeed;
    
    NSTimeInterval timerLength = 1.0f/(f91wHz*21.0f);
     NSLog(@"New Hz: %f", f91wHz);
     NSLog(@"New tl: %f", (float)timerLength);
    
    [msp430Timer invalidate];
	msp430Timer = nil;
	
    
	msp430Timer = [NSTimer timerWithTimeInterval:timerLength target:self selector:@selector(msp430TimerCallback) userInfo:nil repeats:YES];
	
	[[NSRunLoop currentRunLoop] addTimer:msp430Timer forMode:NSDefaultRunLoopMode];
    
   
}


- (NSString *)intToBinary:(int)number
{
    // Number of bits
    //int bits =  sizeof(number) * 8;
    int bits= 8;
    
    // Create mutable string to hold binary result
    NSMutableString *binaryStr = [NSMutableString string];
    
    // For each bit, determine if 1 or 0
    // Bitwise shift right to process next number
    for (; bits > 0; bits--, number >>= 1)
    {
        // Use bitwise AND with 1 to get rightmost bit
        // Insert 0 or 1 at front of the string
        [binaryStr insertString:((number & 1) ? @"1" : @"0") atIndex:0];
    }
    
    return (NSString *)binaryStr;
}

@end
