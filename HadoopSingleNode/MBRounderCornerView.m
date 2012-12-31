//
//  MBRounderCornerView.m
//  Hadoop app
//
//  Created by Marcel Boersma on 12/6/12.
//  Copyright (c) 2012 Marcel Boersma. All rights reserved.
//

#import "MBRounderCornerView.h"

#define CORNERRADIUS 4


@implementation MBRounderCornerView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        
        
    }
    
    return self;
}


-(void)drawRect:(NSRect)dirtyRect
{
    [[NSColor clearColor] set];
    NSRectFill([self frame]);
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:[self frame] xRadius:CORNERRADIUS yRadius:CORNERRADIUS];
    
    [[NSColor colorWithSRGBRed:(249.0/255) green:(248.0/255) blue:(249.0/255) alpha:1.0] set];
     
    [path fill];
    
    
}








@end
