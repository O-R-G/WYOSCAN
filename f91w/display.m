//
//  display.m
//  f91w
//
//  Created by e on 6/3/13.
//  Copyright (c) 2013 HALMOS. All rights reserved.
//



#import "display.h"



@implementation display



float strokeScale = 1;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self){
        
        float frameWidth = frame.size.width;
        float scale = frameWidth/740.f;
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

        
        [self setBackgroundColor:[UIColor blackColor]];
        
        [self buildDisplay:scale x:20 y:20];
    }
    return self;
}

- (void)viewDidLoad
{
    // View setup
    
    // Ensure the view will keep filling its parent
    // when the parent view resizes (e.g. device rotation).
       
}
- (void)viewWillAppear:(BOOL)animated
{
    // Force to fill the parent once the view is about to be shown.
    self.frame = self.superview.bounds;
}

- (void)drawRect:(CGRect)rect
{
    [self updateDisplay];
}

- (void)updateDisplay
{

//    CGContextRef context = UIGraphicsGetCurrentContext();
    
    ColorClassName* stroke = [ColorClassName colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    ColorClassName* onFill = [ColorClassName colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    ColorClassName* offFill = [ColorClassName colorWithRed: .1 green: .1 blue: .1 alpha: 1];
    
    // loop through LCDMEM and see which bits are on
    
    // loop through the bytes
    for(int i = 0; i < 12; i++){
        // get the byte
        unsigned char myByte = LCDMEM[i];
      
        // debug
        // NSLog(@"%c", myByte);

        // loop through the bits
        for(int j = 0; j<8; j++){
            
            // make sure we have a path defined for this memory address
            if([[memMap objectAtIndex:i]objectAtIndex:j] != [NSNull null]){
                
                // pull the bit
                unsigned char myBit = myByte & (1<<j);
                
                /*if((i == 8) && (j == 1)){
                    NSLog(@"secs: %d", (int)myBit);
                    
                }*/
                
                if(myBit > 0){
                    // bit is set
                    
                    PathClassName* seg = [[memMap objectAtIndex:i]objectAtIndex:j];
                    [onFill setFill];
                    [seg fill];
                    [stroke setStroke];
                    seg.lineWidth = 2;
                    [seg stroke];
                    
                } else {
                    // bit is not set
                    PathClassName* seg = [[memMap objectAtIndex:i]objectAtIndex:j];
                    [offFill setFill];
                    [seg fill];
                    [stroke setStroke];
                    seg.lineWidth = 2;
                    [seg stroke];

                    
                }
            } else {
                // null object
                
            }
            
                        
        }// j
    }// i
    
    [self setNeedsDisplay];
    [self setNeedsLayout];
    
}

- (void) buildDisplay:(float)scale x:(float)xOffset y:(float)yOffset
{
  
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

@end
