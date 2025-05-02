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
    
    // Set up and start background music
    [self setupBackgroundMusic];
}
// Add this new method to setup background music
- (void)setupBackgroundMusic {
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *audioURL = [bundle URLForResource:@"jingle" withExtension:@"mp3"];
    if (audioURL) {
        NSError *error = nil;
        
        // Initialize audio session for background playback
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
        if (error) {
            NSLog(@"Error setting audio session category: %@", error.localizedDescription);
        }
        
        // Create audio player
        self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:&error];
        if (error) {
            NSLog(@"Error creating audio player: %@", error.localizedDescription);
            return;
        }
        
        self.backgroundMusic.delegate = (id)self;
        self.backgroundMusic.numberOfLoops = -1; // Infinite looping
        [self.backgroundMusic prepareToPlay];
        [self.backgroundMusic play];
    } else {
        NSLog(@"Background music file not found");
    }
}
- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    // Resume background music when app becomes active
    if (self.backgroundMusic && !paused) {
        [self.backgroundMusic play];
    }
    _hz_slider = 25;
    [_hzSlider setValue:_hz_slider];
    [self.crownSequencer focus];
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    
    if (self.backgroundMusic) {
        [self.backgroundMusic pause];
    }
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
        [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeSuccess];
    } else {
        [_faceScene resetTimers];
        [_faceScene adjustTimers];
        [_faceScene setRunning: YES];
        [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeStart];
    }
}

// AVAudioPlayerDelegate method
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    // This will be called when audio finishes playing (if not looping)
    NSLog(@"Audio finished playing");
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"Audio player decode error: %@", error.localizedDescription);
}

@end
