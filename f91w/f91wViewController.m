//
//  f91wViewController.m
//  f91w
//
//  Created by e on 5/29/13.
//  Copyright (c) 2013 HALMOS. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "f91wViewController.h"
#import <QuartzCore/QuartzCore.h>
//#import "SVGKit.h"
//#import "SVGKFastImageView.h"
#import "display.h"
#import "f91w.h"


@interface f91wViewController ()

@end

float aspect = 740/230;//360;

@implementation f91wViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
        
    [self.view setBackgroundColor:[UIColor blackColor]];
    hzSetMode = NO;
    displayWidth = 740;//self.view.frame.size.width-50;
    displayHeight = displayWidth/aspect;
    //float extraWidth = self.view.frame.size.width - displayWidth;
    float extraHeight = self.view.frame.size.height - displayHeight;
    
    CGRect displayArea = CGRectMake(0,extraHeight/2, displayWidth , displayHeight);

    f91wDisplay = [[display alloc] initWithFrame:displayArea];
    [self.view addSubview: f91wDisplay];
    myf91w = [[f91w alloc] initWithDisplay:f91wDisplay];
    
    // load last speed setting
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    float oldSpeed = [prefs  floatForKey:@"keyToSpeed"];
    if(oldSpeed > 0){
        myf91w.f91wSpeed = oldSpeed;
    }
    // Set up and start background music
    [self setupBackgroundMusic];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

- (void)layoutSubviews
{
        
}

- (void)viewWillLayoutSubviews
{
    
      
    displayWidth = self.view.bounds.size.width-50;
    displayHeight = displayWidth/aspect;
    
    //float f91wDisplayWidth = f91wDisplay.frame.size.width;
    
    float scale = displayWidth  / 750.f;
    
    CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
    
    f91wDisplay.transform = transform;

    
    f91wDisplay.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    /*recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
     recognizer.view.center.y + translation.y);*/
    
    NSLog(@"x: %d y: %d", (int)translation.x, (int)translation.y);
    
    //[recognizer setTranslation:CGPointMake(0, 0) inView:self.view];

   
    
}



- (IBAction)panAction:(UIPanGestureRecognizer *)sender {
    if(hzSetMode == YES){
        //_hzLabel2.alpha = 1.f;
        
        float incrementSize = 500.f;
        
        CGPoint translation = [sender translationInView:self.view];
        
        float newSpeed = myf91w.f91wSpeed + ((translation.y / incrementSize));
        // speed 1.5/sec to 3x/sec
        // Hz = 1/1.5 = .6Hz to .3Hz
        
        if(newSpeed > 3) newSpeed = 3.f;
        if(newSpeed < 1.5) newSpeed = 1.5;
        
        float newHz = 1.f/newSpeed;
        
        if(newHz > .66) newHz = .66;
        if(newHz < .33) newHz = .33;
        
       
        _hzLabel2.text = [[NSString alloc] initWithFormat:@"%.2f Hz", (float)newHz];
        
        //NSLog(@"newHz: %f", newHz);
        
        //NSLog(@"x: %d y: %d", (int)translation.x, (int)translation.y);
        
        
        if(sender.state == UIGestureRecognizerStateEnded)
        {
            //All fingers are lifted.
             myf91w.f91wSpeed = newSpeed;
            //_hzLabel2.alpha = 0.f;
            
            //hzSetMode = NO;
            
            // save the new speed in preferences
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setFloat:myf91w.f91wSpeed forKey:@"keyToSpeed"];

        }
    }
    
}

- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    if(hzSetMode == NO){
        hzSetMode = YES;
        _hzLabel2.alpha = 1.f;
    } else {
        hzSetMode = NO;
        _hzLabel2.alpha = 0.f;
    }
    
}



- (IBAction)longPressAction:(UILongPressGestureRecognizer *)sender {
    
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        if(hzSetMode == NO){
            hzSetMode = YES;
            _hzLabel2.alpha = 1.f;
        } else {
            hzSetMode = NO;
            _hzLabel2.alpha = 0.f;
        }
    }
}

-(BOOL)prefersStatusBarHidden{
    return YES;
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

- (void)handleDidBecomeActive {
    if (self.backgroundMusic && !self.backgroundMusic.isPlaying) {
        [self.backgroundMusic play];
    }
}

- (void)handleWillResignActive {
    if (self.backgroundMusic && self.backgroundMusic.isPlaying) {
        [self.backgroundMusic pause];
    }
}

@end
