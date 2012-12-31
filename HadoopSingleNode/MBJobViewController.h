//
//  MBJobViewController.h
//  HadoopSingleNode
//
//  Created by Marcel Boersma on 12/31/12.
//  Copyright (c) 2012 Marcel Boersma. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MBDragJarView.h"

@interface MBJobViewController : NSViewController

@property (strong) IBOutlet NSTextField *argumentsTextfield;
@property (strong) IBOutlet MBDragJarView *dragImageView;
@property (strong) IBOutlet NSButton *runButton;

- (IBAction)runJarOnHadoop:(id)sender;
-(void)loadDragView:(NSNotification*)aNotification;
-(void)loadConfigView:(NSNotification*)aNotification;
-(void)loadLogView:(NSNotification*)aNotification;

@end
