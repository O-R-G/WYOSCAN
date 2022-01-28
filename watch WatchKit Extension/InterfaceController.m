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

- (void)awakeWithContext:(id)context {
    // Configure interface objects here.

    /*
        using storyboard with InterfaceController which contains
        mainScene WKINterfaceScene holder object to display FaceScene class
        where all the main logic exists, mostly copied from jules/ViewController
        but instead of Core Animation, using SpriteKit
    */
    
    FaceScene *mainScene = [FaceScene nodeWithFileNamed:@"FaceScene"];
    [self.mainScene presentScene: mainScene];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
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

@end



