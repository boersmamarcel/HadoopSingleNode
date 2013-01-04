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


#import "MBHeader.h"
#import "MBHadoopController.h"
#import "MBWindow.h"

#define RGB(r,g,b) [NSColor colorWithSRGBRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
#define CORNERRADIUS 4
#define TRANSITION 180


@implementation MBHeader

@synthesize popover;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        
        self.autoresizingMask = NSViewWidthSizable;
        isMinimized = YES;
        
    }
    
    return self;
}

-(void)awakeFromNib
{
    
    [self.close.image setSize:NSMakeSize(8, 8)];
    
    oldFrame = NSMakeRect(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 360);
    
    [self addTrackingRect:[self bounds] owner:self userData:nil assumeInside:YES];

}

-(void)mouseEntered:(NSEvent *)theEvent
{

    [[self.hadoopLogo animator] setHidden:YES];
    [[self.play animator] setHidden:NO];

}


-(void)mouseExited:(NSEvent *)theEvent
{
    if(!hadoopIsRunning){
        [[self.hadoopLogo animator] setHidden:NO];
        [[self.play animator] setHidden:YES];
    }
}


- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    
    
    if(isMinimized){
    
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:CORNERRADIUS yRadius:CORNERRADIUS];
        NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:RGB(238, 238, 238) endingColor:RGB(196, 196, 196)];
        [gradient drawInBezierPath:path angle:270];
    
    }else{
        
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:CORNERRADIUS yRadius:CORNERRADIUS];
        NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:RGB(238, 238, 238) endingColor:RGB(196, 196, 196)];
        [gradient drawInBezierPath:path angle:270];
        
        NSRect rectSeparator = NSMakeRect(dirtyRect.origin.x, dirtyRect.origin.y, dirtyRect.size.width, 1.0);
        
        [RGB(172,172, 172) set];
        NSRectFill(rectSeparator);
        
        NSRect fill = NSMakeRect(dirtyRect.origin.x , dirtyRect.origin.y+1, dirtyRect.size.width, 2.0);
        [RGB(197,197,197) set];
        NSRectFill(fill);
        
       
    }
    
    
}


- (IBAction)close:(id)sender {
    
    [[NSApplication sharedApplication] terminate:sender];
    
}

- (IBAction)toggleHadoop:(id)sender {
    
    
    if(hadoopIsRunning)
    {
        //terminate hadoop
        hadoopIsRunning = ![[MBHadoopController sharedHadoop] stopAll];
        
        [self fromRunViewToStartView];
        
    }else{
        [self fromStartViewToRunView];
        //start hadoop
        hadoopIsRunning = [[MBHadoopController sharedHadoop] startAll];
        
    }
    
    
}

- (IBAction)showSettings:(id)sender {

    [[self popover] showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxYEdge];
    
}

- (void) fromRunViewToStartView
{
    //if the window isn't minimized, then minimize the window first
    if(!isMinimized)
        [self windowMinimize:self];
    
    //put the play button back in the middle
    [self.play.animator setFrame:NSMakeRect(self.play.frame.origin.x + TRANSITION, self.play.frame.origin.y , self.play.frame.size.width, self.play.frame.size.height)];
    
    //give the button the play icon
    [self.play.animator setImage:[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:@"play.png"]]];
    
    //hide the monitor
    [self.monitor.animator setHidden:YES];
    //hide the toggle view button
    [self.toggleViewButton.animator setHidden:YES];

}

- (void) fromStartViewToRunView
{

    //move the play button to the left
    [self.play.animator setFrame:NSMakeRect(self.play.frame.origin.x - TRANSITION, self.play.frame.origin.y , self.play.frame.size.width, self.play.frame.size.height)];
    //change the play icon to stop
    [self.play.animator setImage:[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:@"stop.png"]]];
    
    //show the monitor
    [self.monitor.animator setHidden:NO];
    //show the toggle view button
    [self.toggleViewButton.animator setHidden:NO];

}


- (IBAction)windowMinimize:(id)sender {
    
    //if is minimized then maximize the view
    if(isMinimized)
    {
        //current origin
        oldFrame.origin = self.window.frame.origin;
        
        //save old frame and substract the oldframe height and size
        oldFrame.origin = NSMakePoint(self.window.frame.origin.x, (self.window.frame.origin.y - oldFrame.size.height + self.frame.size.height));
        
        //reset var before drawRect is called
        isMinimized = !isMinimized;
        
        //animate the change
        [self.window setFrame:oldFrame display:YES animate:YES];
        
        //set maxSize
        [self.window setMinSize:NSMakeSize(self.frame.size.width, self.frame.size.height + 300)];
        [self.window setMaxSize:NSMakeSize(self.frame.size.width, [[NSScreen mainScreen] frame].size.height)];
        //set window to be resizeable
        [self.window setStyleMask:NSResizableWindowMask];
        
        //add scrollview in maximized view
        [(MBWindow*)self.window addScrollSubviewWithSize:NSMakeSize(oldFrame.size.width, oldFrame.size.height - self.frame.size.height)];
        
        
    }else{
        
        isMinimized = !isMinimized;
        
        //set back to old size with animation
        oldFrame = self.window.frame;
        [self.window setFrame:NSMakeRect(self.window.frame.origin.x, (self.window.frame.origin.y + (self.window.frame.size.height - self.frame.size.height)), self.window.frame.size.width, self.frame.size.height) display:YES animate:YES];
    }
    

    

    
}

-(void)dealloc
{
    
}

@end
