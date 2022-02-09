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
    NSTimer *msp430Timer;                        // timer to call back msp430 functions
}

/*
    display:UIView in display.h
*/

- (void) initScene:(float)scale x:(float)xOffset y:(float)yOffset;

@property (readonly) CGSize size;
@property (readonly) CGRect wyoscanArea;
@property (readwrite) float hz;

/*
    f91w:NSObject in f91w.h
*/

- (void) initTimers;
- (void) adjustTimers;
- (void) msp430TimerCallback;

@end

NS_ASSUME_NONNULL_END
