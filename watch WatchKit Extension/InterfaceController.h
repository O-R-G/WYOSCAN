//
//  InterfaceController.h
//  watch WatchKit Extension
//
//  Created by Wei Wang on 2022/1/26.
//  Copyright © 2022 HALMOS. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import "FaceScene.h"
//#import "f91w.h"

@interface InterfaceController : WKInterfaceController

@property (strong, nonatomic) IBOutlet WKInterfaceSKScene *mainScene;

@end
