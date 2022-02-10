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

@synthesize size;
@synthesize wyoscanArea;

/*
    @implementation display from f91w.m
*/

- (instancetype)initWithCoder:(NSCoder *)coder {
    NSLog(@"initWithCoder");
    self = [super initWithCoder:coder];
    if (self){
        self.backgroundColor = [SKColor blackColor];
        SKNodeArray = [[NSMutableArray alloc] initWithCapacity:12];
        [SKNodeArray addObject:[[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil]];         // byte 0
        [SKNodeArray addObject:[[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil]];         // byte 1
        [SKNodeArray addObject:[[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil]];        // byte 2
        [SKNodeArray addObject:[[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil]];        // byte 3
        [SKNodeArray addObject:[[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil]];        // byte 4
        [SKNodeArray addObject:[[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil]];        // byte 5
        [SKNodeArray addObject:[[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil]];         // byte 6
        [SKNodeArray addObject:[[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil]];        // byte 7
        [SKNodeArray addObject:[[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil]];         // byte 8
        [SKNodeArray addObject:[[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil]];         // byte 9
        [SKNodeArray addObject:[[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil]];        // byte 10
        [SKNodeArray addObject:[[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil]];         // byte 11
        
        self.delegate = self;
    }
    [self initScene:scale x:20 y:20];
    [self initTimers];
    return self;
}


- (void)update:(NSTimeInterval)currentTime forScene:(SKScene *)scene
{
    /*
        loop through LCDMEM and see which bits are on
        loop through the bytes
    */
    
    for(int i = 0; i < 12; i++){
        
        // get the byte
        unsigned char myByte = LCDMEM[i];

        // debug
        // NSLog(@"%c", myByte);
        
        // loop through the bits
        for(int j = 0; j<8; j++){
            
            // make sure we have a path defined for this memory address
            if([[SKNodeArray objectAtIndex:i]objectAtIndex:j] != [NSNull null]){

                // pull the bit
                unsigned char myBit = myByte & (1<<j);
                // NSLog(@"%d", myBit);
                /*
                if((i == 8) && (j == 1)){
                    NSLog(@"secs: %d", (int)myBit);
                    
                }
                */
                if(myBit > 0){
                    // bit is set
                    [(SKShapeNode*)[[SKNodeArray objectAtIndex:i]objectAtIndex:j] setFillColor:[SKColor whiteColor]];
                } else {
                    // bit is not set
                    [(SKShapeNode*)[[SKNodeArray objectAtIndex:i]objectAtIndex:j] setFillColor:[UIColor colorWithRed: .1f green: .1f blue: .1f alpha: 1.0f]];
                }
            } else {
                // null object
                // NSLog(@"null");
            }
        }   // j
    }   // i
    // NSLog(@"ROTATE (FaceScene) ---> %f", _hz);
}

- (void) initScene:(float)scale x:(float)xOffset y:(float)yOffset
{
    wyoscanArea = [WKInterfaceDevice currentDevice].screenBounds;
    size = wyoscanArea.size;
    scale = size.width/740.f;
    strokeScale = scale;
    
    xOffset = xOffset - size.width/2/scale;
    yOffset = yOffset - 160/2;
    
    // NSLog(@"size.width = %f", size.width);
    // NSLog(@"size.height = %f", size.height);
    // NSLog(@"scale = %f", scale);
    
    // buildDisplay
    // NSLog(@"initScene");

    // HOUR DIGIT A
    NSMutableArray* HAsegA = [self makeLargeHSegArr:scale x:scale*(10+xOffset) y:scale*(yOffset) ];
    NSMutableArray* HAsegB = [self makeLargeVSegArr:scale x:scale*(80+xOffset) y:scale*(10+yOffset) ];
    NSMutableArray* HAsegC = [self makeLargeVSegArr:scale x:scale*(80+xOffset) y:scale*(90+yOffset) ];
    NSMutableArray* HAsegAD = [self makeLargeHSegArr:scale x:scale*(10+xOffset) y:scale*(160+yOffset) ];
    [HAsegAD addObject:HAsegA]; // a and d are tied in this digit
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
    
    [[SKNodeArray objectAtIndex:9]replaceObjectAtIndex:1 withObject:[self createSeg:HAsegAD]];
    [[SKNodeArray objectAtIndex:9]replaceObjectAtIndex:6 withObject:[self createSeg:HAsegB]];
    [[SKNodeArray objectAtIndex:9]replaceObjectAtIndex:4 withObject:[self createSeg:HAsegC]];
    [[SKNodeArray objectAtIndex:9]replaceObjectAtIndex:0 withObject:[self createSeg:HAsegE]];
    [[SKNodeArray objectAtIndex:9]replaceObjectAtIndex:2 withObject:[self createSeg:HAsegF]];
    [[SKNodeArray objectAtIndex:9]replaceObjectAtIndex:5 withObject:[self createSeg:HAsegG]];
    // [[SKNodeArray objectAtIndex:9]replaceObjectAtIndex:3 withObject:[self createSeg:HAsegA]];
    
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
    
    [[SKNodeArray objectAtIndex:10]replaceObjectAtIndex:2 withObject:[self createSeg:HBsegA]];
    [[SKNodeArray objectAtIndex:10]replaceObjectAtIndex:6 withObject:[self createSeg:HBsegB]];
    [[SKNodeArray objectAtIndex:10]replaceObjectAtIndex:5 withObject:[self createSeg:HBsegC]];
    [[SKNodeArray objectAtIndex:10]replaceObjectAtIndex:4 withObject:[self createSeg:HBsegD]];
    [[SKNodeArray objectAtIndex:10]replaceObjectAtIndex:0 withObject:[self createSeg:HBsegE]];
    [[SKNodeArray objectAtIndex: 8]replaceObjectAtIndex:5 withObject:[self createSeg:HBsegF]];
    [[SKNodeArray objectAtIndex:10]replaceObjectAtIndex:1 withObject:[self createSeg:HBsegG]];

    //SECONDS COLON
    // LCDMEM[8]:0x02;
    xOffset += 110;
    [[SKNodeArray objectAtIndex:8]replaceObjectAtIndex:1 withObject:[self makeSecDot:scale x:scale*(10+xOffset) y:scale*yOffset]];
    
    // MIN DIGIT A
    xOffset += 50;
    NSMutableArray* MAsegA = [self makeLargeHSegArr:scale x:scale*(10+xOffset) y:scale*(yOffset) ];
    NSMutableArray* MAsegB = [self makeLargeVSegArr:scale x:scale*(80+xOffset) y:scale*(10+yOffset) ];
    NSMutableArray* MAsegC = [self makeLargeVSegArr:scale x:scale*(80+xOffset) y:scale*(90+yOffset) ];
    NSMutableArray* MAsegAD = [self makeLargeHSegArr:scale x:scale*(10+xOffset) y:scale*(160+yOffset) ];
    [MAsegAD addObject:MAsegA]; // a and d are tied in this digit
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
    
    [[SKNodeArray objectAtIndex:11]replaceObjectAtIndex:0 withObject:[self createSeg:MAsegAD]];
    [[SKNodeArray objectAtIndex:11]replaceObjectAtIndex:6 withObject:[self createSeg:MAsegB]];
    [[SKNodeArray objectAtIndex:11]replaceObjectAtIndex:4 withObject:[self createSeg:MAsegC]];
    [[SKNodeArray objectAtIndex:11]replaceObjectAtIndex:1 withObject:[self createSeg:MAsegE]];
    [[SKNodeArray objectAtIndex:11]replaceObjectAtIndex:2 withObject:[self createSeg:MAsegF]];
    [[SKNodeArray objectAtIndex:11]replaceObjectAtIndex:5 withObject:[self createSeg:MAsegG]];
    // [[SKNodeArray objectAtIndex:11]replaceObjectAtIndex:3 withObject:[self createSeg:MAsegA]];
    
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
    
    [[SKNodeArray objectAtIndex:0]replaceObjectAtIndex:6 withObject:[self createSeg:MBsegA]];
    [[SKNodeArray objectAtIndex:5]replaceObjectAtIndex:2 withObject:[self createSeg:MBsegB]];
    [[SKNodeArray objectAtIndex:0]replaceObjectAtIndex:4 withObject:[self createSeg:MBsegC]];
    [[SKNodeArray objectAtIndex:0]replaceObjectAtIndex:0 withObject:[self createSeg:MBsegD]];
    [[SKNodeArray objectAtIndex:0]replaceObjectAtIndex:1 withObject:[self createSeg:MBsegE]];
    [[SKNodeArray objectAtIndex:0]replaceObjectAtIndex:2 withObject:[self createSeg:MBsegF]];
    [[SKNodeArray objectAtIndex:0]replaceObjectAtIndex:5 withObject:[self createSeg:MBsegG]];

    
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
    
    [[SKNodeArray objectAtIndex:1]replaceObjectAtIndex:2 withObject:[self createSeg:SAsegA]];
    [[SKNodeArray objectAtIndex:1]replaceObjectAtIndex:6 withObject:[self createSeg:SAsegB]];
    [[SKNodeArray objectAtIndex:2]replaceObjectAtIndex:0 withObject:[self createSeg:SAsegC]];
    [[SKNodeArray objectAtIndex:1]replaceObjectAtIndex:4 withObject:[self createSeg:SAsegD]];
    [[SKNodeArray objectAtIndex:1]replaceObjectAtIndex:0 withObject:[self createSeg:SAsegE]];
    [[SKNodeArray objectAtIndex:1]replaceObjectAtIndex:1 withObject:[self createSeg:SAsegF]];
    [[SKNodeArray objectAtIndex:1]replaceObjectAtIndex:5 withObject:[self createSeg:SAsegG]];
    
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
    
    [[SKNodeArray objectAtIndex:2]replaceObjectAtIndex:2 withObject:[self createSeg:SBsegA]];
    [[SKNodeArray objectAtIndex:2]replaceObjectAtIndex:6 withObject:[self createSeg:SBsegB]];
    [[SKNodeArray objectAtIndex:3]replaceObjectAtIndex:1 withObject:[self createSeg:SBsegC]];
    [[SKNodeArray objectAtIndex:3]replaceObjectAtIndex:0 withObject:[self createSeg:SBsegD]];
    [[SKNodeArray objectAtIndex:2]replaceObjectAtIndex:4 withObject:[self createSeg:SBsegE]];
    [[SKNodeArray objectAtIndex:2]replaceObjectAtIndex:1 withObject:[self createSeg:SBsegF]];
    [[SKNodeArray objectAtIndex:2]replaceObjectAtIndex:5 withObject:[self createSeg:SBsegG]];
    
    NSLog(@"end initScene");
}

- (NSMutableArray*) makeLargeHSegArr:(float)scale x:(float)xOffset y:(float)yOffset
{
    // Bezier Drawing
    NSMutableArray * path = [[NSMutableArray alloc] initWithCapacity:8];
    // xOffset = xOffset - size.width/2;
    // yOffset = yOffset - size.height/2;
    
    NSValue *pointValue1 = [NSValue valueWithCGPoint:CGPointMake((0*scale)+xOffset, -(10*scale)-yOffset)];
    [path addObject:pointValue1];
    NSValue *pointValue2 = [NSValue valueWithCGPoint:CGPointMake((10*scale)+xOffset, -(0*scale)-yOffset)];
    [path addObject:pointValue2];
    NSValue *pointValue3 = [NSValue valueWithCGPoint:CGPointMake((70*scale)+xOffset, -(0*scale)-yOffset)];
    [path addObject:pointValue3];
    NSValue *pointValue4 = [NSValue valueWithCGPoint:CGPointMake((80*scale)+xOffset, -(10*scale)-yOffset)];
    [path addObject:pointValue4];
    NSValue *pointValue5 = [NSValue valueWithCGPoint:CGPointMake((70*scale)+xOffset, -(20*scale)-yOffset)];
    [path addObject:pointValue5];
    NSValue *pointValue6 = [NSValue valueWithCGPoint:CGPointMake((10*scale)+xOffset, -(20*scale)-yOffset)];
    [path addObject:pointValue6];
    NSValue *pointValue7 = [NSValue valueWithCGPoint:CGPointMake((0*scale)+xOffset, -(10*scale)-yOffset)];
    [path addObject:pointValue7];
    
    return path;
}

- (NSMutableArray*) makeLargeVSegArr:(float)scale x:(float)xOffset y:(float)yOffset
{
    // Bezier Drawing
    NSMutableArray * path = [[NSMutableArray alloc] initWithCapacity:8];
    
    NSValue *pointValue1 = [NSValue valueWithCGPoint:CGPointMake((10*scale)+xOffset, -(0*scale)-yOffset)];
    [path addObject:pointValue1];
    NSValue *pointValue2 = [NSValue valueWithCGPoint:CGPointMake((20*scale)+xOffset, -(10*scale)-yOffset)];
    [path addObject:pointValue2];
    NSValue *pointValue3 = [NSValue valueWithCGPoint:CGPointMake((20*scale)+xOffset, -(70*scale)-yOffset)];
    [path addObject:pointValue3];
    NSValue *pointValue4 = [NSValue valueWithCGPoint:CGPointMake((10*scale)+xOffset, -(80*scale)-yOffset)];
    [path addObject:pointValue4];
    NSValue *pointValue5 = [NSValue valueWithCGPoint:CGPointMake((0*scale)+xOffset, -(70*scale)-yOffset)];
    [path addObject:pointValue5];
    NSValue *pointValue6 = [NSValue valueWithCGPoint:CGPointMake((0*scale)+xOffset, -(10*scale)-yOffset)];
    [path addObject:pointValue6];
    NSValue *pointValue7 = [NSValue valueWithCGPoint:CGPointMake((10*scale)+xOffset, -(0*scale)-yOffset)];
    [path addObject:pointValue7];
    
    return path;
}

- (NSMutableArray*) makeMediumHSegArr:(float)scale x:(float)xOffset y:(float)yOffset
{
    // Bezier Drawing
    NSMutableArray * path = [[NSMutableArray alloc] initWithCapacity:8];
    
    NSValue *pointValue1 = [NSValue valueWithCGPoint:CGPointMake((0*scale)+xOffset, -(7.5*scale)-yOffset)];
    [path addObject:pointValue1];
    NSValue *pointValue2 = [NSValue valueWithCGPoint:CGPointMake((7.5*scale)+xOffset, -(0*scale)-yOffset)];
    [path addObject:pointValue2];
    NSValue *pointValue3 = [NSValue valueWithCGPoint:CGPointMake((52.5*scale)+xOffset, -(0*scale)-yOffset)];
    [path addObject:pointValue3];
    NSValue *pointValue4 = [NSValue valueWithCGPoint:CGPointMake((60*scale)+xOffset, -(7.5*scale)-yOffset)];
    [path addObject:pointValue4];
    NSValue *pointValue5 = [NSValue valueWithCGPoint:CGPointMake((52.5*scale)+xOffset, -(15*scale)-yOffset)];
    [path addObject:pointValue5];
    NSValue *pointValue6 = [NSValue valueWithCGPoint:CGPointMake((7.5*scale)+xOffset, -(15*scale)-yOffset)];
    [path addObject:pointValue6];
    NSValue *pointValue7 = [NSValue valueWithCGPoint:CGPointMake((0*scale)+xOffset, -(7.5*scale)-yOffset)];
    [path addObject:pointValue7];
    
    return path;
}

- (NSMutableArray*) makeMediumVSegArr:(float)scale x:(float)xOffset y:(float)yOffset
{
    // Bezier Drawing
    NSMutableArray * path = [[NSMutableArray alloc] initWithCapacity:8];
    
    NSValue *pointValue1 = [NSValue valueWithCGPoint:CGPointMake((7.5*scale)+xOffset, -(0*scale)-yOffset)];
    [path addObject:pointValue1];
    NSValue *pointValue2 = [NSValue valueWithCGPoint:CGPointMake((15*scale)+xOffset, -(7.5*scale)-yOffset)];
    [path addObject:pointValue2];
    NSValue *pointValue3 = [NSValue valueWithCGPoint:CGPointMake((15*scale)+xOffset, -(52.5*scale)-yOffset)];
    [path addObject:pointValue3];
    NSValue *pointValue4 = [NSValue valueWithCGPoint:CGPointMake((7.5*scale)+xOffset, -(60*scale)-yOffset)];
    [path addObject:pointValue4];
    NSValue *pointValue5 = [NSValue valueWithCGPoint:CGPointMake((0*scale)+xOffset, -(52.5*scale)-yOffset)];
    [path addObject:pointValue5];
    NSValue *pointValue6 = [NSValue valueWithCGPoint:CGPointMake((0*scale)+xOffset, -(7.5*scale)-yOffset)];
    [path addObject:pointValue6];
    NSValue *pointValue7 = [NSValue valueWithCGPoint:CGPointMake((7.5*scale)+xOffset, -(0*scale)-yOffset)];
    [path addObject:pointValue7];
    
    return path;
}

- (SKShapeNode*)createSeg:(NSMutableArray*)inputArr {
    CGPoint pointsFromNSArray[] = {
        [[inputArr objectAtIndex:0] CGPointValue],
        [[inputArr objectAtIndex:1] CGPointValue],
        [[inputArr objectAtIndex:2] CGPointValue],
        [[inputArr objectAtIndex:3] CGPointValue],
        [[inputArr objectAtIndex:4] CGPointValue],
        [[inputArr objectAtIndex:5] CGPointValue],
        [[inputArr objectAtIndex:6] CGPointValue]
    };
    SKShapeNode *shape = [[SKShapeNode alloc] init];
     
    CGMutablePathRef myPath = CGPathCreateMutable();
    CGPathAddLines(myPath, NULL, pointsFromNSArray, 7);
    
    if([inputArr count] == 8)
    {
        CGPoint pointsFromNSArray2[] = {
            [[[inputArr objectAtIndex:7] objectAtIndex:0] CGPointValue],
            [[[inputArr objectAtIndex:7] objectAtIndex:1] CGPointValue],
            [[[inputArr objectAtIndex:7] objectAtIndex:2] CGPointValue],
            [[[inputArr objectAtIndex:7] objectAtIndex:3] CGPointValue],
            [[[inputArr objectAtIndex:7] objectAtIndex:4] CGPointValue],
            [[[inputArr objectAtIndex:7] objectAtIndex:5] CGPointValue],
            [[[inputArr objectAtIndex:7] objectAtIndex:6] CGPointValue]
        };
        CGPathAddLines(myPath, NULL, pointsFromNSArray2, 7);
    }

    shape.path = myPath;
    shape.lineWidth = 2.0 * strokeScale;
    shape.fillColor = [UIColor colorWithRed: .1f green: .1f blue: .1f alpha: 1.0f];
    shape.strokeColor = [SKColor blackColor];

    [self addChild:shape];

    return shape;
}

- (SKShapeNode*) makeSecDot:(float)scale x:(float)xOffset y:(float)yOffset
{
    SKShapeNode *shape = [[SKShapeNode alloc] init];
    
    CGMutablePathRef dot1 = CGPathCreateMutable();
    CGPathAddArc(dot1, NULL, xOffset + 10 * scale, -(yOffset + (120+10) * scale), 10 * scale, 0, M_PI*2, YES);
    CGMutablePathRef dot2 = CGPathCreateMutable();
    CGPathAddArc(dot2, NULL, xOffset + 10 * scale, -(yOffset + (42+10) * scale), 10 * scale, 0, M_PI*2, YES);
    CGPathAddPath(dot1, NULL, dot2);

    shape.path = dot1;
    shape.lineWidth = 2.0 * strokeScale;
    shape.fillColor = [UIColor colorWithRed: .1f green: .1f blue: .1f alpha: 1.0f];
    shape.strokeColor = [SKColor blackColor];
    
    [self addChild:shape];
    
    return shape;
}

- (void) initTimers
{

    /*
        7 segments per digit and 6 digits
        so to draw all digits is 42 updates
        1.0 hz = 1 cycle / second = 1.0 / 42 = 0.0238

        @property _hz keeps track
    */

    _hz = 1.0;
    startTime = [NSDate date];
    msp430Timer = [NSTimer timerWithTimeInterval:_hz/42.f target:self selector:@selector(msp430TimerCallback) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:msp430Timer forMode:NSDefaultRunLoopMode];
}

- (void) msp430TimerCallback
{
    /* 
        stopwatch
        
        C struct div_t returned by div()
        contains two values, quotient and remainder
        https://stackoverflow.com/questions/7971807/nstimeinterval-to-nsdate
    */

    NSTimeInterval elapsed = [startTime timeIntervalSinceNow] * -1;

    div_t h = div(elapsed, 3600);
    NSInteger hour = h.quot;
    div_t m = div(h.rem, 60);
    NSInteger minute = m.quot;
    NSInteger second = m.rem;

    /*
        clock

        unused for now, maybe a mode

    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    */

    // run the C code
    RTCSEC = int2bcd((char)second);
    RTCMIN = int2bcd((char)minute);
    RTCHOUR = int2bcd((char)hour);

    // NSLog(@"DEBUG : RTCSEC = %c", RTCSEC);
    // fprintf(stderr, "DEBUG : RTCSEC: %c \n", RTCSEC);       // C-specific logging
    // NSLog(@"DEBUG : %d:%d:%d", hour, minute, second);
    
    ds_animateRTC(0,0,0);    
}

- (void) adjustTimers
{
    /*
        update _hz, kill and restart timer
    */

    if ([msp430Timer isValid]) {
        [msp430Timer invalidate];
        msp430Timer = nil;
        msp430Timer = [NSTimer timerWithTimeInterval:_hz/42.f target:self selector:@selector(msp430TimerCallback) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:msp430Timer forMode:NSDefaultRunLoopMode];
    } 
}

@end
