//
//  f91wViewController.h
//  f91w
//
//  Created by e on 5/29/13.
//  Copyright (c) 2013 HALMOS. All rights reserved.
//

//#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "f91w.h"

@interface f91wViewController : UIViewController{
    display *f91wDisplay;
    f91w *myf91w;
    float displayWidth;
    float displayHeight;
    bool hzSetMode;
    
//    __weak IBOutlet UILabel *hzLabel2;
}
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UILabel *hzLabel2;
@property (nonatomic, strong) AVAudioPlayer *backgroundMusic;

- (IBAction)panAction:(UIPanGestureRecognizer *)sender;

- (IBAction)tapAction:(UITapGestureRecognizer *)sender;

- (IBAction)longPressAction:(UILongPressGestureRecognizer *)sender;

@end
