//
//  MBWindow.h
//  Hadoop app
//
//  Created by Marcel Boersma on 12/5/12.
//  Copyright (c) 2012 Marcel Boersma. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MBHeader.h"
#import "MBMonitor.h"


@interface MBWindow : NSWindow<NSWindowDelegate>
{
    NSPoint initialLocation;
    IBOutlet MBHeader *customHeader;
    IBOutlet NSScrollView *scrollsubview;
}

@property (weak) IBOutlet MBMonitor *monitor;
@property (assign) IBOutlet MBHeader *customHeader;
@property (assign) NSPoint initialLocation;
@property (assign) NSSize initialSize;

-(void)addScrollSubviewWithSize:(NSSize)aSize;

@end
