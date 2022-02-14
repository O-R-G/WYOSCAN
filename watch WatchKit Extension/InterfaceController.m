//
//  InterfaceController.m
//  watch WatchKit Extension
//
//  Created by Wei Wang on 2022/1/26.
//  Copyright © 2022 HALMOS. All rights reserved.
//

#import "InterfaceController.h"
#import <SpriteKit/SpriteKit.h>
#import "FaceScene.h"

@implementation InterfaceController

@synthesize singleTapRecognizer;

- (void)awakeWithContext:(id)context {
    // Configure interface objects here.

    /*
        using storyboard with InterfaceController which contains
        mainScene WKINterfaceScene holder object to display FaceScene class
        where all the main logic exists, mostly copied from jules/ViewController
        but instead of Core Animation, using SpriteKit
    */
    
    self.crownSequencer.delegate = self;
    _faceScene = [FaceScene nodeWithFileNamed:@"FaceScene"];
    [self.mainScene presentScene: _faceScene];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user

    _hz_slider = 25;     
    [_hzSlider setValue:_hz_slider];
    [self.crownSequencer focus];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
}

- (void)viewDidLoad
{
    
}

- (void)layoutSubviews
{
        
}

- (void)viewWillLayoutSubviews
{
    
}

- (void) crownDidRotate:(WKCrownSequencer *)crownSequencer rotationalDelta:(double)rotationalDelta {

    /*
        update FaceScene dtheta (used to calculate mHz)
        dtheta is the time delta between updates:

        7 segments per digit and 6 digits
        so to draw all digits is 42 updates
        1.0 hz = 1 cycle / second = 1.0 / 42 = 0.0238

        desired range is 0.25 hz - 2.0 hz

            0.25f < hz < 2.0f      (default = 1.0f)

        _hz_slider is used to update slider in range:

            0 < _hz_slider < 50
    */

    if (rotationalDelta > 0 && _hz_slider < 50) _hz_slider++;
    if (rotationalDelta < 0 && _hz_slider > 1) _hz_slider--;

    float hz_tmp = 0.25f + (2.0f - 0.25f) * (_hz_slider - 0) / (50 - 0);

    [_hzSlider setHidden:0];
    [_hzSlider setValue:_hz_slider];

    [_faceScene setHz: hz_tmp];
    [_faceScene adjustTimers];

    // NSLog(@"****** ROTATE ******");
    // NSLog(@"%1.5f ROTATE: DTHETA", dtheta);
    // NSLog(@"%1.5f ROTATE: HZ_TMP", hz_tmp);
    // NSLog(@"%1.5f ROTATE: ROTATIONAL DELTA", rotationalDelta);
}

- (void) crownDidBecomeIdle:(WKCrownSequencer *)crownSequencer {
    [NSThread sleepForTimeInterval:0.1f];
    [_hzSlider setHidden:1];
}

- (IBAction)singleTapAction:(id)sender {
    NSLog(@"****** TAP ******");

    if (_faceScene.running) {
        [_faceScene pauseTimers];
        [_faceScene setRunning: NO];
    } else {
        [_faceScene resetTimers];
        [_faceScene adjustTimers];
        [_faceScene setRunning: YES];
        [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeNotification];
    }
}
@end
