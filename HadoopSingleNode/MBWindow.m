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


#import "MBWindow.h"
#import <AppKit/AppKit.h>
#import "MBHeader.h"
#import <Quartz/Quartz.h>
#import "MBRounderCornerView.h"
#import "MBJobViewController.h"

@implementation MBWindow

@synthesize initialLocation;
@synthesize initialSize;
@synthesize customHeader = _customHeader;
@synthesize jobViewController;

-(void)awakeFromNib{
    
    [super awakeFromNib];

    //settings
    [self setMinSize:NSMakeSize(460.0, 62.0)];
    
    //ad headerview
    NSViewController *vc = [[NSViewController alloc] initWithNibName:@"HeaderView" bundle:nil];

    
    //set contentview for window
    MBRounderCornerView *rounderCorner = [[MBRounderCornerView alloc] initWithFrame:[self frame]];
    
    [self setContentView:rounderCorner];
    
    //add header subview
    [self.contentView addSubview:[vc view]];

}




-(id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
    if(self != nil)
        
    {
        [self setAlphaValue:1.0];
        // Turn off opacity so that the parts of the window that are not drawn into are transparent.
        [self setOpaque:NO];
        
        [self center];
        self.delegate = self;
        
    }
    
    return self;
}

- (BOOL)canBecomeKeyWindow {
    return YES;
}





- (void)mouseDown:(NSEvent *)theEvent {
        
    
    // Get the mouse location in window coordinates.
    self.initialLocation = [theEvent locationInWindow];
}

- (void)mouseDragged:(NSEvent *)theEvent {
    
    //get the screen
    NSRect screen = [[NSScreen mainScreen] visibleFrame];
    //current location
    NSRect windowFrame = [self frame];
    //origin
    CGPoint windowOrigin = windowFrame.origin;
    
    //current mouse location
    NSPoint mouseLocation = [theEvent locationInWindow];
    
    //mouselocation - initial mouse location
    windowOrigin.x += (mouseLocation.x - initialLocation.x);
    windowOrigin.y += (mouseLocation.y - initialLocation.y);
    
    /**
     *
     *  Screen location (0,0) bottom left
     *  Screen location (0,t) top left
     *  Screen location (t,t) top right
     *  Screen location (t,0) bottom left
     *
     *  The maximum height is screen.origin.y + screen.size.height
     *  The current top of the window is windowOrigin.y + windowFrame.size.y
     *  The window top may not be higher than the screen top so if the drag update is higher then the maximum size is
     *  screen height minus the window height.
     *
     */
    
    if((windowOrigin.y + windowFrame.size.height ) > (screen.origin.y + screen.size.height))
    {
        windowOrigin.y = ((screen.origin.y + screen.size.height) - windowFrame.size.height);
    }
    
    
    [self setFrameOrigin:windowOrigin];
    
    
}

-(void)addScrollSubviewWithSize:(NSSize)aSize
{
    //add the scrollview
    [scrollsubview setFrameSize:NSMakeSize(aSize.width-6, aSize.height)];
    [scrollsubview setFrameOrigin:NSMakePoint(3, 3)];
    [self.contentView addSubview:scrollsubview];
    
    [self setInitialSize:self.frame.size];
    
    
    //set job view as main view in the scrollview
    jobViewController = [[MBJobViewController alloc] initWithNibName:@"JobView" bundle:nil];

    [scrollsubview setDocumentView:[jobViewController view]];
    
  
}


-(void)windowDidResize:(NSNotification *)notification
{
    //resize the scrollview in order to fit the window
    [scrollsubview setFrameOrigin:NSMakePoint(3, 3)];
    [scrollsubview setFrameSize:NSMakeSize(scrollsubview.frame.size.width, scrollsubview.frame.size.height + ((self.frame.size.height - self.initialSize.height)))];
    
    [self setInitialSize:self.frame.size];
}



@end
