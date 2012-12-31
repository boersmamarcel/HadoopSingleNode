//
//  MBDragJarView.m
//  HadoopSingleNode
//
//  Created by Marcel Boersma on 12/31/12.
//  Copyright (c) 2012 Marcel Boersma. All rights reserved.
//

#import "MBDragJarView.h"
#import "MBHadoopController.h"
#import "MBMonitorMessages.h"
#import "MBJobViewController.h"

@implementation MBDragJarView


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        NSLog(@"Drag drop support");
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];

    }
    
    return self;
}



-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
    
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
    
    
    
    if ( [[pboard types] containsObject:NSFilenamesPboardType] && [[MBHadoopController sharedHadoop] getHadoopIsRunning]) {
        if (sourceDragMask & NSDragOperationLink) {
            return NSDragOperationLink;
        } else if (sourceDragMask & NSDragOperationCopy) {
            return NSDragOperationCopy;
        }
    }
    
    return NSDragOperationNone;
    
}

-(BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
    
    pboard = [sender draggingPasteboard];
    sourceDragMask = [sender draggingSourceOperationMask];
    
    if ([[pboard types] containsObject:NSFilenamesPboardType] && [[MBHadoopController sharedHadoop] getHadoopIsRunning]) {
        
        NSURL *url = [NSURL URLFromPasteboard:pboard];
        
        
        [[MBMonitorMessages sharedMonitorMessages] setDescription:@"Loading jar file.."];
        
        if(![[url path] isEqualTo:@""]){
            
            [[MBHadoopController sharedHadoop] setJarPath:[url path]];
           
            //notify others that the config view is ready to load
            [[NSNotificationCenter  defaultCenter] postNotificationName:@"dragJarFinished" object:nil];
            
            
            return YES;
        }
        
                
        return NO;
    }
    
    
    return NO;
}


@end
