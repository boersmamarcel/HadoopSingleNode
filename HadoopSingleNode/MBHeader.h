//
//  MBHeader.h
//  Hadoop app
//
//  Created by Marcel Boersma on 12/5/12.
//  Copyright (c) 2012 Marcel Boersma. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MBMonitor.h"

@interface MBHeader : NSView
{
    bool isMinimized;
    NSRect oldFrame;
    bool hadoopIsRunning;
}
@property (weak) IBOutlet NSButton *toggleViewButton;
@property (weak) IBOutlet NSButton *play;
@property (weak) IBOutlet MBMonitor *monitor;
@property (weak) IBOutlet NSImageView *hadoopLogo;

@property (weak) IBOutlet NSButton *close;
@property (strong) IBOutlet NSPopover *popover;

- (void) fromRunViewToStartView;
- (void) fromStartViewToRunView;
- (IBAction)close:(id)sender;
- (IBAction)toggleHadoop:(id)sender;
- (IBAction)showSettings:(id)sender;
- (IBAction)windowMinimize:(id)sender;

@end
