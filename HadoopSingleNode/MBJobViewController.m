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


#import "MBJobViewController.h"
#import "MBDragJarView.h"
#import "MBHadoopController.h"



@implementation MBJobViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
    }
    
    return self;
}


-(void)awakeFromNib
{

}



- (IBAction)openLogs:(id)sender {
    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://localhost:50030/"]];
    
}

- (IBAction)runJarOnHadoop:(id)sender {
    
    
    if([[MBHadoopController sharedHadoop] jarPath]){
        [[self dragTextField] setTextColor:[NSColor grayColor]];
        [[self dragTextField] setFont:[NSFont systemFontOfSize:18]];
        
        
        NSArray *arguments = [[[self argumentsTextfield] stringValue] componentsSeparatedByString:@" "];
        
        
        [[MBHadoopController sharedHadoop] setArgs:arguments];
        
        [[self dragImageView] setHidden:YES];
        [[self argumentsTextfield] setHidden:YES];
        [[self runButton] setHidden:YES];
        [[self dragTextField] setHidden:YES];

        
        [[self logButton] setHidden:NO];
        [[self loadNewJobView] setHidden:NO];
        

        [[MBHadoopController sharedHadoop] runJob];
        
        
        
    }else{
        
        [[self dragTextField] setTextColor:[NSColor redColor]];
        [[self dragTextField] setFont:[NSFont boldSystemFontOfSize:18]];
    }
    
    
    
}

- (IBAction)newJobView:(id)sender {
    
    [[self argumentsTextfield] setStringValue:@""];
    
    
    [[self dragTextField] setHidden:NO];
    [[self dragImageView] setHidden:NO];
    [[self dragImageView] setImage:[NSImage imageNamed:@"drag here.png"]];
    [[self argumentsTextfield] setHidden:NO];
    [[self runButton] setHidden:NO];
    
    [[self logButton] setHidden:YES];
    [[self loadNewJobView] setHidden:YES];
}




@end
