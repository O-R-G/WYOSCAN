//
//  FaceScene.m
//  watch WatchKit Extension
//
//  Created by Wei Wang on 2022/1/27.
//  Copyright © 2022 HALMOS. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <TargetConditionals.h>
#import <UIKit/UIKit.h>
#import "msp430.h"
#import "LCD.h"
#import "dexterSinister.h"
#import "dexterSinister_UI.h"
#import "rtc.h"
#import "FaceScene.h"


/*
    rtc.h
*/

@implementation FaceScene

float strokeScale = 1;
//float aspect = 740/230;//360;
float aspect = 740/230;//360;
float scale;
float frameWidth;

@synthesize counter;
@synthesize size;
@synthesize wyoscanArea;
@synthesize dotRect;
@synthesize dotPoint;
//@synthesize myImage;
//@synthesize context;

/*
    @implementation display from f91w.m
*/

- (instancetype)initWithCoder:(NSCoder *)coder {
//- (id)initWithFrame:(CGRect)frame {
    NSLog(@"initWithCoder");
    float extraHeight = size.height - displayHeight;
    CGRect displayArea = CGRectMake(0,extraHeight/2, displayWidth , displayHeight);
    self = [super initWithCoder:coder];
    if (self){
        wyoscanArea = [WKInterfaceDevice currentDevice].screenBounds;
        size = self.size;
        self.backgroundColor = [SKColor blackColor];
        frameWidth = size.width;
        scale = frameWidth/740.f;
//        scale = 1;
        strokeScale = scale;
        
        memMap = [[NSMutableArray alloc] initWithCapacity:12];
        [memMap addObject:[[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil]];         // byte 0
        [memMap addObject:[[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil]];         // byte 1
        [memMap addObject:[[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil]];        // byte 2
        [memMap addObject:[[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil]];        // byte 3
        [memMap addObject:[[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil]];        // byte 4
        [memMap addObject:[[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil]];        // byte 5
        [memMap addObject:[[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil]];         // byte 6
        [memMap addObject:[[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil]];        // byte 7
        [memMap addObject:[[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil]];         // byte 8
        [memMap addObject:[[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil]];         // byte 9
        [memMap addObject:[[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil]];        // byte 10
        [memMap addObject:[[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil]];         // byte 11
        
//        memMap2 = [[NSMutableArray alloc] initWithCapacity:12];

//        [self setBackgroundColor:[UIColor blackColor]];
//        [self buildDisplay:scale x:20 y:20];
//        [self addSubview: self];
        [self initScene:scale x:20 y:20];
//        SKShapeNode *ball = [[SKShapeNode alloc] init];
//        CGMutablePathRef myPath = CGPathCreateMutable();
//        CGPathAddArc(myPath, NULL, 0,0, 15, 0, M_PI*2, YES);
//        ball.path = myPath;
//        ball.lineWidth = 1.0;
//        ball.fillColor = [SKColor blueColor];
//        ball.strokeColor = [SKColor whiteColor];
//        ball.glowWidth = 0.5;
//        [self addChild:ball];
//        PathClassName* seg = [[memMap objectAtIndex:6]objectAtIndex:3];
//        ball.path = seg.CGPath;
//        ball.fillColor = [SKColor blueColor];
//        [self drawMyCircle];
//        [self drawMyLine];
        self.delegate = self;
    }

    
//    SKShapeNode *ball = [ SKShapeNode shapeNodeWithCircleOfRadius:10.0 ];
   
//    [self initScene];
//    [self buildDisplay];
    return self;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    // Force to fill the parent once the view is about to be shown.
//    self.frame = self.superview.bounds;
//}
//- (void)drawRect:(CGRect)rect
//{
//    NSLog(@"drawRect");
//    [self update];
//}

//-(void)setupLayer:(NSString *)layerName
//{
//    SKCropNode *myLayer = [SKCropNode node];
//    myLayer.name = layerName;
//    SKSpriteNode *tick = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(1, shortTickHeight)];
//
//    tick.position = CGPointZero;
//
//
//}
-(void)drawCircle{
    NSLog(@"circle");
    SKShapeNode *ball = [[SKShapeNode alloc] init];
    CGMutablePathRef myPath = CGPathCreateMutable();
    CGPathAddArc(myPath, NULL, 0,0, 15, 0, M_PI*2, YES);
    ball.path = myPath;
    ball.lineWidth = 1.0;
    ball.fillColor = [SKColor blueColor];
    ball.strokeColor = [SKColor whiteColor];
//    ball.glowWidth = 0.5;
}
- (void)update:(NSTimeInterval)currentTime forScene:(SKScene *)scene
{
//    updateFrame / updateDisplay
//    NSLog(@"update");
    
//    ColorClassName* stroke = [ColorClassName colorWithRed: 0 green: 0 blue: 0 alpha: 1];
//    ColorClassName* onFill = [ColorClassName colorWithRed: 1 green: 1 blue: 1 alpha: 1];
//    ColorClassName* offFill = [ColorClassName colorWithRed: .1 green: .1 blue: .1 alpha: 1];
    
//    UIGraphicsBeginImageContext(size);
//    context = UIGraphicsGetCurrentContext();

    // loop through LCDMEM and see which bits are on
    
    // loop through the bytes
    for(int i = 0; i < 12; i++){
        // get the byte
        unsigned char myByte = LCDMEM[i];
        
        // loop through the bits
        
        for(int j = 0; j<7; j++){
            
            // make sure we have a path defined for this memory address
            if([[memMap objectAtIndex:i]objectAtIndex:j] != [NSNull null]){
                
                // pull the bit
                unsigned char myBit = myByte & (1<<j);
//                NSLog(@"%d", myBit);
                /*if((i == 8) && (j == 1)){
                    NSLog(@"secs: %d", (int)myBit);
                    
                }*/
//                NSLog(@"i = %d j =%d ", i, j);
                
//                NSLog(@"context");
                if(myBit > 0){
                    // bit is set
                    
//                    PathClassName* seg = [[memMap objectAtIndex:i]objectAtIndex:j];
                    NSMutableArray* seg = [[memMap objectAtIndex:i]objectAtIndex:j];
                    [self drawMyLine:seg];
//                    [onFill setFill];
//                    [seg fill];
//                    [stroke setStroke];
//                    seg.lineWidth = 2;
//                    [seg stroke];
                    
                } else {
//                  // bit is not set
//                    PathClassName* seg = [[memMap objectAtIndex:i]objectAtIndex:j];
                    NSMutableArray* seg = [[memMap objectAtIndex:i]objectAtIndex:j];
//                    [self drawMyLine:seg];
                    [self drawMyLineOff:seg];
//                    [offFill setFill];
//                    [seg fill];
//                    [stroke setStroke];
//                    seg.lineWidth = 2;
//                    [seg stroke];
//
                }
                
                
            } else {
                // null object
//                NSLog(@"null");
                
            }
            
                        
        }// j
    }// i
//    UIGraphicsEndImageContext();
}

- (void) initScene:(float)scale x:(float)xOffset y:(float)yOffset
{
    //    buildDisplay
    NSLog(@"initScene");
    // HOUR DIGIT A
    NSMutableArray* HAsegA = [self makeLargeHSegArr:scale x:scale*(10+xOffset) y:scale*(yOffset) ];
    NSMutableArray* HAsegB = [self makeLargeVSegArr:scale x:scale*(80+xOffset) y:scale*(10+yOffset) ];
    NSMutableArray* HAsegC = [self makeLargeVSegArr:scale x:scale*(80+xOffset) y:scale*(90+yOffset) ];
    NSMutableArray* HAsegAD = [self makeLargeHSegArr:scale x:scale*(10+xOffset) y:scale*(160+yOffset) ];
//    [HAsegAD appendPath:HAsegA]; // a and d are tied in this digit
    NSMutableArray* HAsegE = [self makeLargeVSegArr:scale x:scale*(xOffset) y:scale*(90+yOffset) ];
    NSMutableArray* HAsegF = [self makeLargeVSegArr:scale x:scale*(xOffset) y:scale*(10+yOffset) ];
    NSMutableArray* HAsegG = [self makeLargeHSegArr:scale x:scale*(10+xOffset) y:scale*(80+yOffset) ];
    /* memmap
     09:1 - HAA
     09:6 - HAB
     09:4 - HAC
     09:1 - HAD
     09:0 - HAE
     09:2 - HAF
     09:5 - HAG
     */
    [[memMap objectAtIndex:9]replaceObjectAtIndex:1 withObject:HAsegAD];
    [[memMap objectAtIndex:9]replaceObjectAtIndex:6 withObject:HAsegB];
    [[memMap objectAtIndex:9]replaceObjectAtIndex:4 withObject:HAsegC];
    [[memMap objectAtIndex:9]replaceObjectAtIndex:0 withObject:HAsegE];
    [[memMap objectAtIndex:9]replaceObjectAtIndex:2 withObject:HAsegF];
    [[memMap objectAtIndex:9]replaceObjectAtIndex:5 withObject:HAsegG];
    
    
    // HOUR DIGIT B
    xOffset += 120;
    NSMutableArray* HBsegA = [self makeLargeHSegArr:scale x:scale*(10+xOffset) y:scale*(yOffset) ];
    NSMutableArray* HBsegB = [self makeLargeVSegArr:scale x:scale*(80+xOffset) y:scale*(10+yOffset) ];
    NSMutableArray* HBsegC = [self makeLargeVSegArr:scale x:scale*(80+xOffset) y:scale*(90+yOffset) ];
    NSMutableArray* HBsegD = [self makeLargeHSegArr:scale x:scale*(10+xOffset) y:scale*(160+yOffset) ];
    NSMutableArray* HBsegE = [self makeLargeVSegArr:scale x:scale*(xOffset) y:scale*(90+yOffset) ];
    NSMutableArray* HBsegF = [self makeLargeVSegArr:scale x:scale*(xOffset) y:scale*(10+yOffset) ];
    NSMutableArray* HBsegG = [self makeLargeHSegArr:scale x:scale*(10+xOffset) y:scale*(80+yOffset) ];
    /* memmap
     10:2 - HBA
     10:6 - HBB
     10:5 - HBC
     10:4 - HBD
     10:0 - HBE
     08:5 - HBF
     10:1 - HBG
     */
    [[memMap objectAtIndex:10]replaceObjectAtIndex:2 withObject:HBsegA];
    [[memMap objectAtIndex:10]replaceObjectAtIndex:6 withObject:HBsegB];
    [[memMap objectAtIndex:10]replaceObjectAtIndex:5 withObject:HBsegC];
    [[memMap objectAtIndex:10]replaceObjectAtIndex:4 withObject:HBsegD];
    [[memMap objectAtIndex:10]replaceObjectAtIndex:0 withObject:HBsegE];
    [[memMap objectAtIndex: 8]replaceObjectAtIndex:5 withObject:HBsegF];
    [[memMap objectAtIndex:10]replaceObjectAtIndex:1 withObject:HBsegG];

    //SECONDS COLON
    // LCDMEM[8]:0x02;
    xOffset += 110;
//    PathClassName* secDot = [self makeSecDot:scale x:scale*(10+xOffset) y:scale*(42+yOffset) ];
//    PathClassName* secDot2 = [self makeSecDot:scale x:scale*(10+xOffset) y:scale*(120+yOffset) ];
//    [secDot appendPath:secDot2];
//    [[memMap objectAtIndex:8]replaceObjectAtIndex:1 withObject:secDot];
    
    // MIN DIGIT A
    xOffset += 50;
    NSMutableArray* MAsegA = [self makeLargeHSegArr:scale x:scale*(10+xOffset) y:scale*(yOffset) ];
    NSMutableArray* MAsegB = [self makeLargeVSegArr:scale x:scale*(80+xOffset) y:scale*(10+yOffset) ];
    NSMutableArray* MAsegC = [self makeLargeVSegArr:scale x:scale*(80+xOffset) y:scale*(90+yOffset) ];
    NSMutableArray* MAsegAD = [self makeLargeHSegArr:scale x:scale*(10+xOffset) y:scale*(160+yOffset) ];
//    [MAsegAD appendPath:MAsegA]; // a and d are tied in this digit
    NSMutableArray* MAsegE = [self makeLargeVSegArr:scale x:scale*(xOffset) y:scale*(90+yOffset) ];
    NSMutableArray* MAsegF = [self makeLargeVSegArr:scale x:scale*(xOffset) y:scale*(10+yOffset) ];
    NSMutableArray* MAsegG = [self makeLargeHSegArr:scale x:scale*(10+xOffset) y:scale*(80+yOffset) ];
    /* memmap
    11:0 - MAA+D
    11:6 - MAB
    11:4 - MAC
    11:0 - MAA+D
    11:1 - MAE
    11:2 - MAF
    11:5 - MAG
     */
    [[memMap objectAtIndex:11]replaceObjectAtIndex:0 withObject:MAsegAD];
    [[memMap objectAtIndex:11]replaceObjectAtIndex:6 withObject:MAsegB];
    [[memMap objectAtIndex:11]replaceObjectAtIndex:4 withObject:MAsegC];
    [[memMap objectAtIndex:11]replaceObjectAtIndex:1 withObject:MAsegE];
    [[memMap objectAtIndex:11]replaceObjectAtIndex:2 withObject:MAsegF];
    [[memMap objectAtIndex:11]replaceObjectAtIndex:5 withObject:MAsegG];
    
    // MIN DIGIT B
    xOffset += 120;
    NSMutableArray* MBsegA = [self makeLargeHSegArr:scale x:scale*(10+xOffset) y:scale*(yOffset) ];
    NSMutableArray* MBsegB = [self makeLargeVSegArr:scale x:scale*(80+xOffset) y:scale*(10+yOffset) ];
    NSMutableArray* MBsegC = [self makeLargeVSegArr:scale x:scale*(80+xOffset) y:scale*(90+yOffset) ];
    NSMutableArray* MBsegD = [self makeLargeHSegArr:scale x:scale*(10+xOffset) y:scale*(160+yOffset) ];
    NSMutableArray* MBsegE = [self makeLargeVSegArr:scale x:scale*(xOffset) y:scale*(90+yOffset) ];
    NSMutableArray* MBsegF = [self makeLargeVSegArr:scale x:scale*(xOffset) y:scale*(10+yOffset) ];
    NSMutableArray* MBsegG = [self makeLargeHSegArr:scale x:scale*(10+xOffset) y:scale*(80+yOffset) ];

    /*
    00:6 - MBA
    05:2 - MBB
    00:4 - MBC
    00:0 - MBD
    00:1 - MBE
    00:2 - MBF
    00:5 - MBG
    */
    [[memMap objectAtIndex:0]replaceObjectAtIndex:6 withObject:MBsegA];
    [[memMap objectAtIndex:5]replaceObjectAtIndex:2 withObject:MBsegB];
    [[memMap objectAtIndex:0]replaceObjectAtIndex:4 withObject:MBsegC];
    [[memMap objectAtIndex:0]replaceObjectAtIndex:0 withObject:MBsegD];
    [[memMap objectAtIndex:0]replaceObjectAtIndex:1 withObject:MBsegE];
    [[memMap objectAtIndex:0]replaceObjectAtIndex:2 withObject:MBsegF];
    [[memMap objectAtIndex:0]replaceObjectAtIndex:5 withObject:MBsegG];
    
    // SEC DIGIT A
    xOffset += 130;
    yOffset += 45;
    NSMutableArray* SAsegA = [self makeMediumHSegArr:scale x:scale*(7.5+xOffset) y:scale*(yOffset) ];
    NSMutableArray* SAsegB = [self makeMediumVSegArr:scale x:scale*(60+xOffset) y:scale*(7.5+yOffset) ];
    NSMutableArray* SAsegC = [self makeMediumVSegArr:scale x:scale*(60+xOffset) y:scale*(67.5+yOffset) ];
    NSMutableArray* SAsegD = [self makeMediumHSegArr:scale x:scale*(7.5+xOffset) y:scale*(120+yOffset) ];
    NSMutableArray* SAsegE = [self makeMediumVSegArr:scale x:scale*(xOffset) y:scale*(67.5+yOffset) ];
    NSMutableArray* SAsegF = [self makeMediumVSegArr:scale x:scale*(xOffset) y:scale*(7.5+yOffset) ];
    NSMutableArray* SAsegG = [self makeMediumHSegArr:scale x:scale*(7.5+xOffset) y:scale*(60+yOffset) ];
    /*
     1:2 - SAA
     1:6 - SAB
     2:0 - SAC
     1:4 - SAD
     1:0 - SAE
     1:1 - SAF
     1:5 - SAG
     */
    [[memMap objectAtIndex:1]replaceObjectAtIndex:2 withObject:SAsegA];
    [[memMap objectAtIndex:1]replaceObjectAtIndex:6 withObject:SAsegB];
    [[memMap objectAtIndex:2]replaceObjectAtIndex:0 withObject:SAsegC];
    [[memMap objectAtIndex:1]replaceObjectAtIndex:4 withObject:SAsegD];
    [[memMap objectAtIndex:1]replaceObjectAtIndex:0 withObject:SAsegE];
    [[memMap objectAtIndex:1]replaceObjectAtIndex:1 withObject:SAsegF];
    [[memMap objectAtIndex:1]replaceObjectAtIndex:5 withObject:SAsegG];
    
    // SEC DIGIT B
    xOffset += 90;
    NSMutableArray* SBsegA = [self makeMediumHSegArr:scale x:scale*(7.5+xOffset) y:scale*(yOffset) ];
    NSMutableArray* SBsegB = [self makeMediumVSegArr:scale x:scale*(60+xOffset) y:scale*(7.5+yOffset) ];
    NSMutableArray* SBsegC = [self makeMediumVSegArr:scale x:scale*(60+xOffset) y:scale*(67.5+yOffset) ];
    NSMutableArray* SBsegD = [self makeMediumHSegArr:scale x:scale*(7.5+xOffset) y:scale*(120+yOffset) ];
    NSMutableArray* SBsegE = [self makeMediumVSegArr:scale x:scale*(xOffset) y:scale*(67.5+yOffset) ];
    NSMutableArray* SBsegF = [self makeMediumVSegArr:scale x:scale*(xOffset) y:scale*(7.5+yOffset) ];
    NSMutableArray* SBsegG = [self makeMediumHSegArr:scale x:scale*(7.5+xOffset) y:scale*(60+yOffset) ];
    /*
     2:2 - SBA
     2:6 - SBB
     3:1 - SBC
     3:0 - SBD
     2:4 - SBE
     2:1 - SBF
     2:5 - SBG
     */
    [[memMap objectAtIndex:2]replaceObjectAtIndex:2 withObject:SBsegA];
    [[memMap objectAtIndex:2]replaceObjectAtIndex:6 withObject:SBsegB];
    [[memMap objectAtIndex:3]replaceObjectAtIndex:1 withObject:SBsegC];
    [[memMap objectAtIndex:3]replaceObjectAtIndex:0 withObject:SBsegD];
    [[memMap objectAtIndex:2]replaceObjectAtIndex:4 withObject:SBsegE];
    [[memMap objectAtIndex:2]replaceObjectAtIndex:1 withObject:SBsegF];
    [[memMap objectAtIndex:2]replaceObjectAtIndex:5 withObject:SBsegG];
    
//    NSMutableArray* testArray = [self makeMediumVSegArr:scale x:scale*(7.5+xOffset) y:scale*(yOffset)];
//    NSMutableArray* testArray = [[memMap objectAtIndex:2]objectAtIndex:2];
//    [[memMap objectAtIndex:2]replaceObjectAtIndex:6 withObject:testArray];
    
//    [self drawMyLine:testArray];
    NSLog(@"end initScene");
}

- (void) initSceneKeep:(float)scale x:(float)xOffset y:(float)yOffset
{
    //    buildDisplay
    NSLog(@"initScene");
    // HOUR DIGIT A
    PathClassName* HAsegA = [self makeLargeHSeg:scale x:scale*(10+xOffset) y:scale*(yOffset) ];
    PathClassName* HAsegB = [self makeLargeVSeg:scale x:scale*(80+xOffset) y:scale*(10+yOffset) ];
    PathClassName* HAsegC = [self makeLargeVSeg:scale x:scale*(80+xOffset) y:scale*(90+yOffset) ];
    PathClassName* HAsegAD = [self makeLargeHSeg:scale x:scale*(10+xOffset) y:scale*(160+yOffset) ];
    [HAsegAD appendPath:HAsegA]; // a and d are tied in this digit
    PathClassName* HAsegE = [self makeLargeVSeg:scale x:scale*(xOffset) y:scale*(90+yOffset) ];
    PathClassName* HAsegF = [self makeLargeVSeg:scale x:scale*(xOffset) y:scale*(10+yOffset) ];
    PathClassName* HAsegG = [self makeLargeHSeg:scale x:scale*(10+xOffset) y:scale*(80+yOffset) ];
    /* memmap
     09:1 - HAA
     09:6 - HAB
     09:4 - HAC
     09:1 - HAD
     09:0 - HAE
     09:2 - HAF
     09:5 - HAG
     */
    [[memMap objectAtIndex:9]replaceObjectAtIndex:1 withObject:HAsegAD];
    [[memMap objectAtIndex:9]replaceObjectAtIndex:6 withObject:HAsegB];
    [[memMap objectAtIndex:9]replaceObjectAtIndex:4 withObject:HAsegC];
    [[memMap objectAtIndex:9]replaceObjectAtIndex:0 withObject:HAsegE];
    [[memMap objectAtIndex:9]replaceObjectAtIndex:2 withObject:HAsegF];
    [[memMap objectAtIndex:9]replaceObjectAtIndex:5 withObject:HAsegG];
    
    
    // HOUR DIGIT B
    xOffset += 120;
    PathClassName* HBsegA = [self makeLargeHSeg:scale x:scale*(10+xOffset) y:scale*(yOffset) ];
    PathClassName* HBsegB = [self makeLargeVSeg:scale x:scale*(80+xOffset) y:scale*(10+yOffset) ];
    PathClassName* HBsegC = [self makeLargeVSeg:scale x:scale*(80+xOffset) y:scale*(90+yOffset) ];
    PathClassName* HBsegD = [self makeLargeHSeg:scale x:scale*(10+xOffset) y:scale*(160+yOffset) ];
    PathClassName* HBsegE = [self makeLargeVSeg:scale x:scale*(xOffset) y:scale*(90+yOffset) ];
    PathClassName* HBsegF = [self makeLargeVSeg:scale x:scale*(xOffset) y:scale*(10+yOffset) ];
    PathClassName* HBsegG = [self makeLargeHSeg:scale x:scale*(10+xOffset) y:scale*(80+yOffset) ];
    /* memmap
     10:2 - HBA
     10:6 - HBB
     10:5 - HBC
     10:4 - HBD
     10:0 - HBE
     08:5 - HBF
     10:1 - HBG
     */
    [[memMap objectAtIndex:10]replaceObjectAtIndex:2 withObject:HBsegA];
    [[memMap objectAtIndex:10]replaceObjectAtIndex:6 withObject:HBsegB];
    [[memMap objectAtIndex:10]replaceObjectAtIndex:5 withObject:HBsegC];
    [[memMap objectAtIndex:10]replaceObjectAtIndex:4 withObject:HBsegD];
    [[memMap objectAtIndex:10]replaceObjectAtIndex:0 withObject:HBsegE];
    [[memMap objectAtIndex: 8]replaceObjectAtIndex:5 withObject:HBsegF];
    [[memMap objectAtIndex:10]replaceObjectAtIndex:1 withObject:HBsegG];

    //SECONDS COLON
    // LCDMEM[8]:0x02;
    xOffset += 110;
    PathClassName* secDot = [self makeSecDot:scale x:scale*(10+xOffset) y:scale*(42+yOffset) ];
    PathClassName* secDot2 = [self makeSecDot:scale x:scale*(10+xOffset) y:scale*(120+yOffset) ];
    [secDot appendPath:secDot2];
    [[memMap objectAtIndex:8]replaceObjectAtIndex:1 withObject:secDot];
    
    // MIN DIGIT A
    xOffset += 50;
    PathClassName* MAsegA = [self makeLargeHSeg:scale x:scale*(10+xOffset) y:scale*(yOffset) ];
    PathClassName* MAsegB = [self makeLargeVSeg:scale x:scale*(80+xOffset) y:scale*(10+yOffset) ];
    PathClassName* MAsegC = [self makeLargeVSeg:scale x:scale*(80+xOffset) y:scale*(90+yOffset) ];
    PathClassName* MAsegAD = [self makeLargeHSeg:scale x:scale*(10+xOffset) y:scale*(160+yOffset) ];
    [MAsegAD appendPath:MAsegA]; // a and d are tied in this digit
    PathClassName* MAsegE = [self makeLargeVSeg:scale x:scale*(xOffset) y:scale*(90+yOffset) ];
    PathClassName* MAsegF = [self makeLargeVSeg:scale x:scale*(xOffset) y:scale*(10+yOffset) ];
    PathClassName* MAsegG = [self makeLargeHSeg:scale x:scale*(10+xOffset) y:scale*(80+yOffset) ];
    /* memmap
    11:0 - MAA+D
    11:6 - MAB
    11:4 - MAC
    11:0 - MAA+D
    11:1 - MAE
    11:2 - MAF
    11:5 - MAG
     */
    [[memMap objectAtIndex:11]replaceObjectAtIndex:0 withObject:MAsegAD];
    [[memMap objectAtIndex:11]replaceObjectAtIndex:6 withObject:MAsegB];
    [[memMap objectAtIndex:11]replaceObjectAtIndex:4 withObject:MAsegC];
    [[memMap objectAtIndex:11]replaceObjectAtIndex:1 withObject:MAsegE];
    [[memMap objectAtIndex:11]replaceObjectAtIndex:2 withObject:MAsegF];
    [[memMap objectAtIndex:11]replaceObjectAtIndex:5 withObject:MAsegG];
    
    // MIN DIGIT B
    xOffset += 120;
    PathClassName* MBsegA = [self makeLargeHSeg:scale x:scale*(10+xOffset) y:scale*(yOffset) ];
    PathClassName* MBsegB = [self makeLargeVSeg:scale x:scale*(80+xOffset) y:scale*(10+yOffset) ];
    PathClassName* MBsegC = [self makeLargeVSeg:scale x:scale*(80+xOffset) y:scale*(90+yOffset) ];
    PathClassName* MBsegD = [self makeLargeHSeg:scale x:scale*(10+xOffset) y:scale*(160+yOffset) ];
    PathClassName* MBsegE = [self makeLargeVSeg:scale x:scale*(xOffset) y:scale*(90+yOffset) ];
    PathClassName* MBsegF = [self makeLargeVSeg:scale x:scale*(xOffset) y:scale*(10+yOffset) ];
    PathClassName* MBsegG = [self makeLargeHSeg:scale x:scale*(10+xOffset) y:scale*(80+yOffset) ];

    /*
    00:6 - MBA
    05:2 - MBB
    00:4 - MBC
    00:0 - MBD
    00:1 - MBE
    00:2 - MBF
    00:5 - MBG
    */
    [[memMap objectAtIndex:0]replaceObjectAtIndex:6 withObject:MBsegA];
    [[memMap objectAtIndex:5]replaceObjectAtIndex:2 withObject:MBsegB];
    [[memMap objectAtIndex:0]replaceObjectAtIndex:4 withObject:MBsegC];
    [[memMap objectAtIndex:0]replaceObjectAtIndex:0 withObject:MBsegD];
    [[memMap objectAtIndex:0]replaceObjectAtIndex:1 withObject:MBsegE];
    [[memMap objectAtIndex:0]replaceObjectAtIndex:2 withObject:MBsegF];
    [[memMap objectAtIndex:0]replaceObjectAtIndex:5 withObject:MBsegG];
    
    // SEC DIGIT A
    xOffset += 130;
    yOffset += 45;
    PathClassName* SAsegA = [self makeMediumHSeg:scale x:scale*(7.5+xOffset) y:scale*(yOffset) ];
    PathClassName* SAsegB = [self makeMediumVSeg:scale x:scale*(60+xOffset) y:scale*(7.5+yOffset) ];
    PathClassName* SAsegC = [self makeMediumVSeg:scale x:scale*(60+xOffset) y:scale*(67.5+yOffset) ];
    PathClassName* SAsegD = [self makeMediumHSeg:scale x:scale*(7.5+xOffset) y:scale*(120+yOffset) ];
    PathClassName* SAsegE = [self makeMediumVSeg:scale x:scale*(xOffset) y:scale*(67.5+yOffset) ];
    PathClassName* SAsegF = [self makeMediumVSeg:scale x:scale*(xOffset) y:scale*(7.5+yOffset) ];
    PathClassName* SAsegG = [self makeMediumHSeg:scale x:scale*(7.5+xOffset) y:scale*(60+yOffset) ];
    /*
     1:2 - SAA
     1:6 - SAB
     2:0 - SAC
     1:4 - SAD
     1:0 - SAE
     1:1 - SAF
     1:5 - SAG
     */
    [[memMap objectAtIndex:1]replaceObjectAtIndex:2 withObject:SAsegA];
    [[memMap objectAtIndex:1]replaceObjectAtIndex:6 withObject:SAsegB];
    [[memMap objectAtIndex:2]replaceObjectAtIndex:0 withObject:SAsegC];
    [[memMap objectAtIndex:1]replaceObjectAtIndex:4 withObject:SAsegD];
    [[memMap objectAtIndex:1]replaceObjectAtIndex:0 withObject:SAsegE];
    [[memMap objectAtIndex:1]replaceObjectAtIndex:1 withObject:SAsegF];
    [[memMap objectAtIndex:1]replaceObjectAtIndex:5 withObject:SAsegG];
    
    // SEC DIGIT B
    xOffset += 90;
    PathClassName* SBsegA = [self makeMediumHSeg:scale x:scale*(7.5+xOffset) y:scale*(yOffset) ];
    PathClassName* SBsegB = [self makeMediumVSeg:scale x:scale*(60+xOffset) y:scale*(7.5+yOffset) ];
    PathClassName* SBsegC = [self makeMediumVSeg:scale x:scale*(60+xOffset) y:scale*(67.5+yOffset) ];
    PathClassName* SBsegD = [self makeMediumHSeg:scale x:scale*(7.5+xOffset) y:scale*(120+yOffset) ];
    PathClassName* SBsegE = [self makeMediumVSeg:scale x:scale*(xOffset) y:scale*(67.5+yOffset) ];
    PathClassName* SBsegF = [self makeMediumVSeg:scale x:scale*(xOffset) y:scale*(7.5+yOffset) ];
    PathClassName* SBsegG = [self makeMediumHSeg:scale x:scale*(7.5+xOffset) y:scale*(60+yOffset) ];
    /*
     2:2 - SBA
     2:6 - SBB
     3:1 - SBC
     3:0 - SBD
     2:4 - SBE
     2:1 - SBF
     2:5 - SBG
     */
    [[memMap objectAtIndex:2]replaceObjectAtIndex:2 withObject:SBsegA];
    [[memMap objectAtIndex:2]replaceObjectAtIndex:6 withObject:SBsegB];
    [[memMap objectAtIndex:3]replaceObjectAtIndex:1 withObject:SBsegC];
    [[memMap objectAtIndex:3]replaceObjectAtIndex:0 withObject:SBsegD];
    [[memMap objectAtIndex:2]replaceObjectAtIndex:4 withObject:SBsegE];
    [[memMap objectAtIndex:2]replaceObjectAtIndex:1 withObject:SBsegF];
    [[memMap objectAtIndex:2]replaceObjectAtIndex:5 withObject:SBsegG];
    
    NSMutableArray* testArray = [self makeMediumVSegArr:scale x:scale*(7.5+xOffset) y:scale*(yOffset)];
//    [[memMap objectAtIndex:2]replaceObjectAtIndex:6 withObject:testArray];
    
    [self drawMyLine:testArray];
    NSLog(@"end initScene");
}


- (PathClassName*) makeLargeHSeg:(float)scale x:(float)xOffset y:(float)yOffset
{

    //// Bezier Drawing
    PathClassName* bezierPath = [PathClassName bezierPath];
    [bezierPath moveToPoint: CGPointMake((0*scale)+xOffset, (10*scale)+yOffset)];
    [bezierPath addLineToPoint: CGPointMake((10*scale)+xOffset, (0*scale)+yOffset)];
    [bezierPath addLineToPoint: CGPointMake((70*scale)+xOffset, (0*scale)+yOffset)];
    [bezierPath addLineToPoint: CGPointMake((80*scale)+xOffset, (10*scale)+yOffset)];
    [bezierPath addLineToPoint: CGPointMake((70*scale)+xOffset, (20*scale)+yOffset)];
    [bezierPath addLineToPoint: CGPointMake((10*scale)+xOffset, (20*scale)+yOffset)];
    [bezierPath addLineToPoint: CGPointMake((0*scale)+xOffset, (10*scale)+yOffset)];
    [bezierPath closePath];
    return bezierPath;
}
- (PathClassName*) makeLargeVSeg:(float)scale x:(float)xOffset y:(float)yOffset
{
    PathClassName* bezierPath = [PathClassName bezierPath];
    [bezierPath moveToPoint: CGPointMake((10*scale)+xOffset, (0*scale)+yOffset)];
    [bezierPath addLineToPoint: CGPointMake((20*scale)+xOffset, (10*scale)+yOffset)];
    [bezierPath addLineToPoint: CGPointMake((20*scale)+xOffset, (70*scale)+yOffset)];
    [bezierPath addLineToPoint: CGPointMake((10*scale)+xOffset, (80*scale)+yOffset)];
    [bezierPath addLineToPoint: CGPointMake((0*scale)+xOffset, (70*scale)+yOffset)];
    [bezierPath addLineToPoint: CGPointMake((0*scale)+xOffset, (10*scale)+yOffset)];
    [bezierPath addLineToPoint: CGPointMake((10*scale)+xOffset, (0*scale)+yOffset)];
    [bezierPath closePath];
    return bezierPath;

}

- (PathClassName*) makeMediumHSeg:(float)scale x:(float)xOffset y:(float)yOffset
{
    //// Bezier Drawing
    PathClassName* bezierPath = [PathClassName bezierPath];
//    NSLog(@"makeMediumHSeg");
//    NSLog(@"%f, %f, %f", scale, xOffset, yOffset);
    [bezierPath moveToPoint: CGPointMake((0*scale)+xOffset, (7.5*scale)+yOffset)];
    [bezierPath addLineToPoint: CGPointMake((7.5*scale)+xOffset, (0*scale)+yOffset)];
    [bezierPath addLineToPoint: CGPointMake((52.5*scale)+xOffset, (0*scale)+yOffset)];
    [bezierPath addLineToPoint: CGPointMake((60*scale)+xOffset, (7.5*scale)+yOffset)];
    [bezierPath addLineToPoint: CGPointMake((52.5*scale)+xOffset, (15*scale)+yOffset)];
    [bezierPath addLineToPoint: CGPointMake((7.5*scale)+xOffset, (15*scale)+yOffset)];
    [bezierPath addLineToPoint: CGPointMake((0*scale)+xOffset, (7.5*scale)+yOffset)];
    [bezierPath closePath];
    return bezierPath;

}

- (PathClassName*) makeMediumVSeg:(float)scale x:(float)xOffset y:(float)yOffset
{
    //// Bezier Drawing
    PathClassName* bezierPath = [PathClassName bezierPath];
    [bezierPath moveToPoint: CGPointMake((7.5*scale)+xOffset, (0*scale)+yOffset)];
    [bezierPath addLineToPoint: CGPointMake((15*scale)+xOffset, (7.5*scale)+yOffset)];
    [bezierPath addLineToPoint: CGPointMake((15*scale)+xOffset, (52.5*scale)+yOffset)];
    [bezierPath addLineToPoint: CGPointMake((7.5*scale)+xOffset, (60*scale)+yOffset)];
    [bezierPath addLineToPoint: CGPointMake((0*scale)+xOffset, (52.5*scale)+yOffset)];
    [bezierPath addLineToPoint: CGPointMake((0*scale)+xOffset, (7.5*scale)+yOffset)];
    [bezierPath addLineToPoint: CGPointMake((7.5*scale)+xOffset, (0*scale)+yOffset)];
    [bezierPath closePath];
    return bezierPath;
    
}

- (NSMutableArray*) makeLargeHSegArr:(float)scale x:(float)xOffset y:(float)yOffset
{
    //// Bezier Drawing
    NSMutableArray * path = [[NSMutableArray alloc] initWithCapacity:7];
    xOffset = xOffset - size.width/2;
//    yOffset = yOffset - size.height/2;
    
    NSValue *pointValue1 = [NSValue valueWithCGPoint:CGPointMake((0*scale)+xOffset, (10*scale)+yOffset)];
    [path addObject:pointValue1];
    NSValue *pointValue2 = [NSValue valueWithCGPoint:CGPointMake((10*scale)+xOffset, (0*scale)+yOffset)];
    [path addObject:pointValue2];
    NSValue *pointValue3 = [NSValue valueWithCGPoint:CGPointMake((70*scale)+xOffset, (0*scale)+yOffset)];
    [path addObject:pointValue3];
    NSValue *pointValue4 = [NSValue valueWithCGPoint:CGPointMake((80*scale)+xOffset, (10*scale)+yOffset)];
    [path addObject:pointValue4];
    NSValue *pointValue5 = [NSValue valueWithCGPoint:CGPointMake((70*scale)+xOffset, (20*scale)+yOffset)];
    [path addObject:pointValue5];
    NSValue *pointValue6 = [NSValue valueWithCGPoint:CGPointMake((10*scale)+xOffset, (20*scale)+yOffset)];
    [path addObject:pointValue6];
    NSValue *pointValue7 = [NSValue valueWithCGPoint:CGPointMake((0*scale)+xOffset, (10*scale)+yOffset)];
    [path addObject:pointValue7];
    
    return path;
}
- (NSMutableArray*) makeLargeVSegArr:(float)scale x:(float)xOffset y:(float)yOffset
{
    //// Bezier Drawing
    NSMutableArray * path = [[NSMutableArray alloc] initWithCapacity:7];
    xOffset = xOffset - size.width/2;
//    yOffset = yOffset - size.height/2;
    
    NSValue *pointValue1 = [NSValue valueWithCGPoint:CGPointMake((10*scale)+xOffset, (0*scale)+yOffset)];
    [path addObject:pointValue1];
    NSValue *pointValue2 = [NSValue valueWithCGPoint:CGPointMake((20*scale)+xOffset, (10*scale)+yOffset)];
    [path addObject:pointValue2];
    NSValue *pointValue3 = [NSValue valueWithCGPoint:CGPointMake((20*scale)+xOffset, (70*scale)+yOffset)];
    [path addObject:pointValue3];
    NSValue *pointValue4 = [NSValue valueWithCGPoint:CGPointMake((10*scale)+xOffset, (80*scale)+yOffset)];
    [path addObject:pointValue4];
    NSValue *pointValue5 = [NSValue valueWithCGPoint:CGPointMake((0*scale)+xOffset, (70*scale)+yOffset)];
    [path addObject:pointValue5];
    NSValue *pointValue6 = [NSValue valueWithCGPoint:CGPointMake((0*scale)+xOffset, (10*scale)+yOffset)];
    [path addObject:pointValue6];
    NSValue *pointValue7 = [NSValue valueWithCGPoint:CGPointMake((10*scale)+xOffset, (0*scale)+yOffset)];
    [path addObject:pointValue7];
    
    return path;
}

- (NSMutableArray*) makeMediumHSegArr:(float)scale x:(float)xOffset y:(float)yOffset
{
    //// Bezier Drawing
    NSMutableArray * path = [[NSMutableArray alloc] initWithCapacity:7];
    xOffset = xOffset - size.width/2;
//    yOffset = yOffset - size.height/2;
    
    NSValue *pointValue1 = [NSValue valueWithCGPoint:CGPointMake((0*scale)+xOffset, (7.5*scale)+yOffset)];
    [path addObject:pointValue1];
    NSValue *pointValue2 = [NSValue valueWithCGPoint:CGPointMake((7.5*scale)+xOffset, (0*scale)+yOffset)];
    [path addObject:pointValue2];
    NSValue *pointValue3 = [NSValue valueWithCGPoint:CGPointMake((52.5*scale)+xOffset, (0*scale)+yOffset)];
    [path addObject:pointValue3];
    NSValue *pointValue4 = [NSValue valueWithCGPoint:CGPointMake((60*scale)+xOffset, (7.5*scale)+yOffset)];
    [path addObject:pointValue4];
    NSValue *pointValue5 = [NSValue valueWithCGPoint:CGPointMake((52.5*scale)+xOffset, (15*scale)+yOffset)];
    [path addObject:pointValue5];
    NSValue *pointValue6 = [NSValue valueWithCGPoint:CGPointMake((7.5*scale)+xOffset, (15*scale)+yOffset)];
    [path addObject:pointValue6];
    NSValue *pointValue7 = [NSValue valueWithCGPoint:CGPointMake((0*scale)+xOffset, (7.5*scale)+yOffset)];
    [path addObject:pointValue7];
    
    return path;
}

- (NSMutableArray*) makeMediumVSegArr:(float)scale x:(float)xOffset y:(float)yOffset
{
    //// Bezier Drawing
    NSMutableArray * path = [[NSMutableArray alloc] initWithCapacity:7];
    xOffset = xOffset - size.width/2;
//    yOffset = yOffset - size.height/2;
    
    NSValue *pointValue1 = [NSValue valueWithCGPoint:CGPointMake((7.5*scale)+xOffset, (0*scale)+yOffset)];
    [path addObject:pointValue1];
    NSValue *pointValue2 = [NSValue valueWithCGPoint:CGPointMake((15*scale)+xOffset, (7.5*scale)+yOffset)];
    [path addObject:pointValue2];
    NSValue *pointValue3 = [NSValue valueWithCGPoint:CGPointMake((15*scale)+xOffset, (52.5*scale)+yOffset)];
    [path addObject:pointValue3];
    NSValue *pointValue4 = [NSValue valueWithCGPoint:CGPointMake((7.5*scale)+xOffset, (60*scale)+yOffset)];
    [path addObject:pointValue4];
    NSValue *pointValue5 = [NSValue valueWithCGPoint:CGPointMake((0*scale)+xOffset, (52.5*scale)+yOffset)];
    [path addObject:pointValue5];
    NSValue *pointValue6 = [NSValue valueWithCGPoint:CGPointMake((0*scale)+xOffset, (7.5*scale)+yOffset)];
    [path addObject:pointValue6];
    NSValue *pointValue7 = [NSValue valueWithCGPoint:CGPointMake((7.5*scale)+xOffset, (0*scale)+yOffset)];
    [path addObject:pointValue7];
    
//    NSLog(@"NSValue = %@", pointValue1);
//    NSLog(@"NSValue = %@", pointValue2);
//    NSLog(@"NSValue = %@", pointValue3);
//    NSLog(@"NSValue = %@", pointValue4);
//    NSLog(@"NSValue = %@", pointValue5);
//    NSLog(@"NSValue = %@", pointValue6);
//    NSLog(@"NSValue = %@", pointValue7);
    
    return path;
}

- (void)drawMyLineKeep:(float)scale x:(float)xOffset y:(float)yOffset {
    NSLog(@"draw my line");
    NSLog(@"size.width = %f", size.width);
    // Bezier Drawing
//    CGSize sizee = CGSizeMake(500, 500);
    UIGraphicsBeginImageContext(size);
    CGContextRef contextt = UIGraphicsGetCurrentContext();
//    [contextt setStrokeColor:[SKColor blueColor].CGColor];
    CGContextSetStrokeColorWithColor(contextt, [SKColor blueColor].CGColor);
    CGContextSetLineWidth(contextt, 4.0);
    
    CGContextBeginPath (contextt);
    CGContextMoveToPoint(contextt, (7.5*scale)+xOffset, (0*scale)+yOffset);
    CGContextAddLineToPoint(contextt, (15*scale)+xOffset, (7.5*scale)+yOffset);
    CGContextAddLineToPoint(contextt, (15*scale)+xOffset, (52.5*scale)+yOffset);
    CGContextAddLineToPoint(contextt, (7.5*scale)+xOffset, (60*scale)+yOffset);
    CGContextAddLineToPoint(contextt, (0*scale)+xOffset, (52.5*scale)+yOffset);
    CGContextAddLineToPoint(contextt, (0*scale)+xOffset, (7.5*scale)+yOffset);
//    CGContextMoveToPoint(contextt, 0, 100);
    CGContextAddLineToPoint(contextt, (7.5*scale)+xOffset, (0*scale)+yOffset);
    CGContextStrokePath(contextt);
    CGImageRef cgimage = CGBitmapContextCreateImage(contextt);
    UIImage* uiimage = [UIImage imageWithCGImage:cgimage];
    
//    CGContextRelease(contextt);
    UIGraphicsEndImageContext();
    
//    [self.myImage setImage:uiimage]; doesn't need image here
}

- (void)drawMyCircle {
//    works
    NSLog(@"draw my circle");
    SKShapeNode *circle = [[SKShapeNode alloc] init];
     
    CGMutablePathRef myPath = CGPathCreateMutable();
    CGPathAddArc(myPath, NULL, 0,0, 50, 0, M_PI*2, YES);
    circle.path = myPath;
     
    circle.lineWidth = 1.0;
    circle.fillColor = [SKColor blueColor];
    circle.strokeColor = [SKColor whiteColor];
    circle.glowWidth = 0.5;
    
    [self addChild:circle];
}

- (void)drawMyLine:(NSMutableArray*) inputArr {
//    works
//    NSLog(@"draw my line-to-point");
//    CGPoint points[] = {
//        CGPointMake(-50.0,  50.0),
//        CGPointMake(50.0,  50.0),
//        CGPointMake(50.0,  -50.0),
//        CGPointMake(-50.0,  -50.0)
//    };
    CGPoint pointsFromNSArray[] = {
        [[inputArr objectAtIndex:0] CGPointValue],
        [[inputArr objectAtIndex:1] CGPointValue],
        [[inputArr objectAtIndex:2] CGPointValue],
        [[inputArr objectAtIndex:3] CGPointValue],
        [[inputArr objectAtIndex:4] CGPointValue],
        [[inputArr objectAtIndex:5] CGPointValue],
        [[inputArr objectAtIndex:6] CGPointValue]
    };
    SKShapeNode *line = [[SKShapeNode alloc] init];
     
    CGMutablePathRef myPath = CGPathCreateMutable();
    CGPathAddLines(myPath, NULL, pointsFromNSArray, 7);
//    CGPathAddLineToPoint(myPath, NULL, 50,50);
    line.path = myPath;
     
    line.lineWidth = 2.0;
    line.fillColor = [SKColor whiteColor];
    line.strokeColor = [SKColor blackColor];
//    circle.glowWidth = 0.5;
    
    [self addChild:line];
}
- (void)drawMyLineOff:(NSMutableArray*) inputArr {
//    works
    
    CGPoint pointsFromNSArray[] = {
        [[inputArr objectAtIndex:0] CGPointValue],
        [[inputArr objectAtIndex:1] CGPointValue],
        [[inputArr objectAtIndex:2] CGPointValue],
        [[inputArr objectAtIndex:3] CGPointValue],
        [[inputArr objectAtIndex:4] CGPointValue],
        [[inputArr objectAtIndex:5] CGPointValue],
        [[inputArr objectAtIndex:6] CGPointValue]
    };
    SKShapeNode *line = [[SKShapeNode alloc] init];
     
    CGMutablePathRef myPath = CGPathCreateMutable();
    CGPathAddLines(myPath, NULL, pointsFromNSArray, 7);
//    CGPathAddLineToPoint(myPath, NULL, 50,50);
    line.path = myPath;
     
//    circle.lineWidth = 2.0;
    line.fillColor = [SKColor blackColor];
//    circle.strokeColor = [SKColor whiteColor];
//    circle.glowWidth = 0.5;
    
    [self addChild:line];
}

- (PathClassName*) makeSecDot:(float)scale x:(float)xOffset y:(float)yOffset
{
    PathClassName* bezierPath = [PathClassName bezierPath];
    [bezierPath moveToPoint: CGPointMake((20*scale)+xOffset, (10*scale)+yOffset)];
    [bezierPath addCurveToPoint: CGPointMake((10*scale)+xOffset, (0*scale)+yOffset) controlPoint1: CGPointMake((20*scale)+xOffset, (4.47*scale)+yOffset) controlPoint2: CGPointMake((15.52*scale)+xOffset, (0*scale)+yOffset)];
    [bezierPath addCurveToPoint: CGPointMake((0*scale)+xOffset, (10*scale)+yOffset) controlPoint1: CGPointMake((4.48*scale)+xOffset, (0*scale)+yOffset) controlPoint2: CGPointMake((0*scale)+xOffset, (4.47*scale)+yOffset)];
    [bezierPath addCurveToPoint: CGPointMake((10*scale)+xOffset, (20*scale)+yOffset) controlPoint1: CGPointMake((0*scale)+xOffset, (15.53*scale)+yOffset) controlPoint2: CGPointMake((4.48*scale)+xOffset, (20*scale)+yOffset)];
    [bezierPath addCurveToPoint: CGPointMake((20*scale)+xOffset, (10*scale)+yOffset) controlPoint1: CGPointMake((15.52*scale)+xOffset, (20*scale)+yOffset) controlPoint2: CGPointMake((20*scale)+xOffset, (15.53*scale)+yOffset)];
    [bezierPath closePath];
    bezierPath.miterLimit = 4;
    return bezierPath;
}



- (void) drawFrame {
    NSLog(@"drawFrame");
//    int g;
//
//    [self addChild: [self dotNode]];
//
//    // update values for next frame
//    theta += dtheta;
//    dotPoint.x = scalar * sin(xFactor*theta);   // does not include + size.width / 2;
//    dotPoint.y = scalar * sin(yFactor*theta);   // and + size.height / 2;

    /*
     * source: http://stackoverflow.com/questions/9620324/how-to-calculate-the-period-of-a-lissajous-curve

     * the frequency of the lissajous is GCF(xFactor, yFactor) / 2*PI
     * but, this is assuming that one second = one second, which is not always
     * when we change how much to jump ahead on the curve each time. we start
     * out incrementing t by 1/30 (the frame rate) but allow the user to
     * increment t by a greater or lesser amount, thus we have to multiply
     * by the dtheta (ie, dt) adjustment and divide by the frame rate
     *
     * nb that it is not guaranteed that the lissajous even *has* a frequency
     * (ok, well, technically, yes, it is guaranteed because xFactor and yFactor
     * are both floating-point numbers and therefore xFactor / yFactor is
     * is rational so at some point the curve must close, but if we do not
     * truncate them (by multiplying by hzGranularity, eg 10^3 and casting to
     * int) the curve might not close for a lonnnnnng time, and still in the
     * case of truncating to the first three decimal places, will only close
     * after approx 10^3 seconds.
     */
//    g = gcf((int)(hzGranularity*xFactor), (int)(hzGranularity*yFactor));
//    mHz = dtheta*frameRate*((float)g)/M_2_PI*pow(10, orderOfMagnitude);
//    counter++;
}

- (SKSpriteNode *)dotNode {

    SKSpriteNode *dotNode = [SKSpriteNode spriteNodeWithImageNamed:@"dot-100.png"];
    dotNode.size = dotRect.size;
    dotNode.position = dotPoint;

    return dotNode;
}





//- (id) initWithDisplay:(display*)aDisplay
//{
//    if (self = [super init]){
//        f91wDisplay = aDisplay;
//        self.f91wSpeed = 2;
//        [self initTimers];
//         ds_init();
//    }
//    return self;
//}

- (void) initTimers
{
    
    msp430Timer = [NSTimer timerWithTimeInterval:1.f/21.f
                                    target:self
                                  selector:@selector(msp430TimerCallback)
                                  userInfo:nil
                                   repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:msp430Timer forMode:NSDefaultRunLoopMode];
    
    
    /*displayTimer = [NSTimer timerWithTimeInterval:kScheduledTimerInSeconds
                                          target:self
                                        selector:@selector(displayTimerCallback)
                                        userInfo:nil
                                         repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:displayTimer forMode:NSDefaultRunLoopMode];*/
    
    
}

- (void) msp430TimerCallback
{

  
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    
    NSInteger hour= [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    // run the c code
    RTCSEC = int2bcd((char)second);
    RTCMIN = int2bcd((char)minute);
    RTCHOUR = int2bcd((char)hour);

    ds_animateRTC(0,0,0);
//    [self update];
    
}
- (void) displayTimerCallback
{
//    [self update];
    
}

- (float) f91wSpeed
{
    return f91wSpeed;

}
- (void) setF91wSpeed:(float)newSpeed
{
    //NSLog(@"New Speed: %f", newSpeed);
    f91wSpeed = newSpeed;
    f91wHz = 1.0f/f91wSpeed;
    
    NSTimeInterval timerLength = 1.0f/(f91wHz*21.0f);
     NSLog(@"New Hz: %f", f91wHz);
     NSLog(@"New tl: %f", (float)timerLength);
    
    [msp430Timer invalidate];
    msp430Timer = nil;
    
    
    msp430Timer = [NSTimer timerWithTimeInterval:timerLength target:self selector:@selector(msp430TimerCallback) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:msp430Timer forMode:NSDefaultRunLoopMode];
    
   
}


- (NSString *)intToBinary:(int)number
{
    // Number of bits
    //int bits =  sizeof(number) * 8;
    int bits= 8;
    
    // Create mutable string to hold binary result
    NSMutableString *binaryStr = [NSMutableString string];
    
    // For each bit, determine if 1 or 0
    // Bitwise shift right to process next number
    for (; bits > 0; bits--, number >>= 1)
    {
        // Use bitwise AND with 1 to get rightmost bit
        // Insert 0 or 1 at front of the string
        [binaryStr insertString:((number & 1) ? @"1" : @"0") atIndex:0];
    }
    
    return (NSString *)binaryStr;
}

@end
