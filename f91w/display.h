//
//  display.h
//  f91w
//
//  Created by e on 6/3/13.
//  Copyright (c) 2013 HALMOS. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import <TargetConditionals.h>
#import "msp430.h"
#import "LCD.h"

#if TARGET_OS_IPHONE
#define ImageClassName UIImage
#define PathClassName UIBezierPath
#define ColorClassName UIColor
#else
#define ImageClassName NSImage
#define PathClassName NSBezierPath
#define ColorClassName NSColor
#endif

@interface display : UIView{

    NSMutableArray * memMap;
}

- (id)initWithFrame:(CGRect)frame;
- (void)updateDisplay;
- (void) buildDisplay:(float)scale x:(float)xOffset y:(float)yOffset;
- (PathClassName*) makeLargeHSeg:(float)scale x:(float)xOffset y:(float)yOffset;
- (PathClassName*) makeLargeVSeg:(float)scale x:(float)xOffset y:(float)yOffset;
- (PathClassName*) makeMediumHSeg:(float)scale x:(float)xOffset y:(float)yOffset;
- (PathClassName*) makeMediumVSeg:(float)scale x:(float)xOffset y:(float)yOffset;



@end
