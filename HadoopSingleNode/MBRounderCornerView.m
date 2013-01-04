//# Licensed to the Apache Software Foundation (ASF) under one or more
//# contributor license agreements.  See the NOTICE file distributed with
//# this work for additional information regarding copyright ownership.
//# The ASF licenses this file to You under the Apache License, Version 2.0
//# (the "License"); you may not use this file except in compliance with
//# the License.  You may obtain a copy of the License at
//#
//#     http://www.apache.org/licenses/LICENSE-2.0
//#
//# Unless required by applicable law or agreed to in writing, software
//# distributed under the License is distributed on an "AS IS" BASIS,
//# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//# See the License for the specific language governing permissions and
//# limitations under the License.

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
