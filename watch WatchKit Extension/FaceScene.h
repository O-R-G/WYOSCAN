//
//  FaceScene.h
//  watch WatchKit Extension
//
//  Created by Wei Wang on 2022/1/27.
//  Copyright © 2022 HALMOS. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FaceScene : SKScene <SKSceneDelegate>{
    /*
        display:UIView in display.h
    */
    NSMutableArray * SKNodeArray;
    
    /*
        f91w:NSObject in f91w.h
    */
    NSTimer *msp430Timer;       // timer to call back msp430 functions
    NSDate *startTime;          // overall start date used for time readout
}

/*
    display:UIView in display.h
*/

- (void) initScene:(float)scale x:(float)xOffset y:(float)yOffset;

@property (nonatomic) CGSize size;
@property (readonly) CGRect wyoscanArea;
@property (readwrite) float hz;
@property (readwrite) BOOL running;
@property NSInteger hour;
@property NSInteger minute;
@property NSInteger second;

/*
    f91w:NSObject in f91w.h
*/

- (void) initTimers;
- (void) adjustTimers;
- (void) msp430TimerCallback;
- (void) resetTimers;
- (void) pauseTimers;

@end

NS_ASSUME_NONNULL_END
