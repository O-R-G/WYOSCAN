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
#import "FaceScene.h"

@interface InterfaceController : WKInterfaceController <WKCrownDelegate> {
    BOOL paused;
}

@property (weak, nonatomic) FaceScene *faceScene;
@property (weak, nonatomic) IBOutlet WKInterfaceSKScene *mainScene;
@property (strong, nonatomic) IBOutlet WKInterfaceSlider *hzSlider;
@property (nonatomic) int hz_slider;

@end
