//
//  FaceScene.h
//  watch WatchKit Extension
//
//  Created by Wei Wang on 2022/1/27.
//  Copyright © 2022 HALMOS. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

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

//static const NSTimeInterval  kScheduledTimerInSeconds      = 1.0f/21.0f;


@interface FaceScene : SKScene <SKSceneDelegate>{
    /*
        display:UIView in display.h
    */
    NSMutableArray * SKNodeArray;
    
    /*
        f91w:NSObject in f91w.h
    */
    NSTimer *msp430Timer;                        // timer to call back msp430 functions
}
/*
    display:UIView in display.h
*/

- (void) initScene:(float)scale x:(float)xOffset y:(float)yOffset;

@property (readonly) CGSize size;
@property (readonly) CGRect wyoscanArea;

/*
    f91w:NSObject in f91w.h
*/

- (void) initTimers;
- (void) msp430TimerCallback;

@end

NS_ASSUME_NONNULL_END
