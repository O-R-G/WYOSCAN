//
//  NotificationController.m
//  watch WatchKit Extension
//
//  Created by Wei Wang on 2022/1/26.
//  Copyright © 2022 HALMOS. All rights reserved.
//

#import "NotificationController.h"


@interface NotificationController ()

@end


@implementation NotificationController

- (instancetype)init {
    self = [super init];
    if (self){
        // Initialize variables here.
        // Configure interface objects here.
        
    }
    return self;
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
}

- (void)didReceiveNotification:(UNNotification *)notification {
    // This method is called when a notification needs to be presented.
    // Implement it if you use a dynamic notification interface.
    // Populate your dynamic notification interface as quickly as possible.
}

@end



