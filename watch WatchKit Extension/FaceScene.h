//
//  FaceScene.h
//  watch WatchKit Extension
//
//  Created by Wei Wang on 2022/1/27.
//  Copyright © 2022 HALMOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "msp430.h"
#import "LCD.h"


#define ImageClassName UIImage
#define PathClassName UIBezierPath
#define ColorClassName UIColor

//@interface display : UIView{
//
//    NSMutableArray * memMap;
//}
//
//- (id)initWithFrame:(CGRect)frame;
//- (void)updateDisplay;
//- (void) buildDisplay:(float)scale x:(float)xOffset y:(float)yOffset;
//- (PathClassName*) makeLargeHSeg:(float)scale x:(float)xOffset y:(float)yOffset;
//- (PathClassName*) makeLargeVSeg:(float)scale x:(float)xOffset y:(float)yOffset;
//- (PathClassName*) makeMediumHSeg:(float)scale x:(float)xOffset y:(float)yOffset;
//- (PathClassName*) makeMediumVSeg:(float)scale x:(float)xOffset y:(float)yOffset;
//
//
//
//@end
NS_ASSUME_NONNULL_BEGIN

static const NSTimeInterval  kScheduledTimerInSeconds      = 1.0f/21.0f;


@interface FaceScene : SKScene <SKSceneDelegate>{
    /*
        display:UIView in display.h
    */
    NSMutableArray * memMap;
    NSMutableArray * memMap2;
    
    /*
        f91w:NSObject in f91w.h
    */
    // declare ivars here
    NSTimer *msp430Timer;                        // timer to call back msp430 functions
    NSTimer *displayTimer;                        // timer to update display Emulator
//    display *f91wDisplay;
    float f91wSpeed;
    float f91wHz;
    
    /*
        f91wViewController:UIViewController in f91wViewController.h
    */
    float displayWidth;
    float displayHeight;
    bool hzSetMode;
}
/*
    display:UIView in display.h
*/
//- (id)initWithFrame:(CGRect)frame;
//- (id)initWithCoder:(NSCoder *)coder;

//- (void)update;
- (void) initScene:(float)scale x:(float)xOffset y:(float)yOffset;
- (PathClassName*) makeLargeHSeg:(float)scale x:(float)xOffset y:(float)yOffset;
- (PathClassName*) makeLargeVSeg:(float)scale x:(float)xOffset y:(float)yOffset;
- (PathClassName*) makeMediumHSeg:(float)scale x:(float)xOffset y:(float)yOffset;
- (PathClassName*) makeMediumVSeg:(float)scale x:(float)xOffset y:(float)yOffset;

//@property (readonly) CGSize size;
@property (readonly) CGRect wyoscanArea;

@property (readonly) int counter;
@property (readonly) CGRect dotRect;
@property (readonly) CGPoint dotPoint;
//@property CGContextRef context;
/*
    f91w:NSObject in f91w.h
*/

@property (nonatomic) float f91wSpeed;

- (float) f91wSpeed;
- (void) setF91wSpeed: (float)newSpeed;

//- (id) initWithDisplay: (display*)aDisplay;
- (void) initTimers;
- (void) msp430TimerCallback;
- (void) displayTimerCallback;
//- (void) updateDisplay;
- (NSString *)intToBinary:(int)Number;

//@property (weak, nonatomic) IBOutlet WKInterfaceImage* myImage;
/*
    f91wViewController:UIViewController in f91wViewController.h
*/
//property (weak, nonatomic) IBOutlet UILabel *hzLabel2;
//
//- (IBAction)panAction:(UIPanGestureRecognizer *)sender;
//
//- (IBAction)tapAction:(UITapGestureRecognizer *)sender;
//
//- (IBAction)longPressAction:(UILongPressGestureRecognizer *)sender;

@end

NS_ASSUME_NONNULL_END
