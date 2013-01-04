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


#import <Cocoa/Cocoa.h>
#import "MBHeader.h"
#import "MBMonitor.h"
#import "MBJobViewController.h"

@interface MBWindow : NSWindow<NSWindowDelegate>
{
    NSPoint initialLocation;
    IBOutlet MBHeader *customHeader;
    IBOutlet NSScrollView *scrollsubview;
}

@property (strong) MBJobViewController *jobViewController;
@property (weak) IBOutlet MBMonitor *monitor;
@property (assign) IBOutlet MBHeader *customHeader;
@property (assign) NSPoint initialLocation;
@property (assign) NSSize initialSize;

-(void)addScrollSubviewWithSize:(NSSize)aSize;

@end
