//
//  InterfaceController.h
//  watch WatchKit Extension
//
//  Created by Wei Wang on 2022/1/26.
//  Copyright © 2022 HALMOS. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>
#import <AVFoundation/AVFoundation.h>
#import "FaceScene.h"

@interface InterfaceController : WKInterfaceController <WKCrownDelegate> {
    BOOL paused;
}

@property (weak, nonatomic) FaceScene *faceScene;
@property (weak, nonatomic) IBOutlet WKInterfaceSKScene *mainScene;
@property (strong, nonatomic) IBOutlet WKInterfaceSlider *hzSlider;
@property (strong, nonatomic) IBOutlet WKTapGestureRecognizer *singleTapRecognizer;
@property (nonatomic) int hz_slider;
// Add audio player property
@property (nonatomic, strong) AVAudioPlayer *backgroundMusic;

- (IBAction)singleTapAction:(id)sender;

@end
