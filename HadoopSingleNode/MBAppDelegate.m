//
//  MBAppDelegate.m
//  HadoopSingleNode
//
//  Created by Marcel Boersma on 12/17/12.
//  Copyright (c) 2012 Marcel Boersma. All rights reserved.
//

#import "MBAppDelegate.h"
#import "MBHadoopController.h"

@implementation MBAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

-(void)applicationWillTerminate:(NSNotification *)notification
{
    
    //quit the hadoop process before shutting down
    [[MBHadoopController sharedHadoop] stopAll];
}

@end
