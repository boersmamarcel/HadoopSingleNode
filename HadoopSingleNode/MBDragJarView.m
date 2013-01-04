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


#import "MBDragJarView.h"
#import "MBHadoopController.h"
#import "MBMonitorMessages.h"

@implementation MBDragJarView


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
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

            [self setImage:[NSImage imageNamed:@"drag done.png"]];
            
            return YES;
        }
        
                
        return NO;
    }
    
    
    return NO;
}


@end
