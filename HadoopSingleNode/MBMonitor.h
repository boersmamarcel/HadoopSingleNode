//
//  MBMonitor.h
//  Hadoop app
//
//  Created by Marcel Boersma on 12/6/12.
//  Copyright (c) 2012 Marcel Boersma. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MBMonitor : NSView


-(void)startProgressIndicator:(NSNotification*)aNotification;
-(void)stopProgressIndicator:(NSNotification*)aNotification;

@property (strong) IBOutlet NSTextField *message;
@property (strong) IBOutlet NSTextField *description;
@property (strong) IBOutlet NSProgressIndicator *progress;
@end
