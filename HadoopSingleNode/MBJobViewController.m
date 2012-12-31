//
//  MBJobViewController.m
//  HadoopSingleNode
//
//  Created by Marcel Boersma on 12/31/12.
//  Copyright (c) 2012 Marcel Boersma. All rights reserved.
//

#import "MBJobViewController.h"
#import "MBDragJarView.h"
#import "MBHadoopController.h"

@interface MBJobViewController ()

@end

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
    [[self argumentsTextfield] setHidden:YES];
    [[self runButton] setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadConfigView:) name:@"dragJarFinished" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDragView:) name:@"dragView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadLogView:) name:@"logView" object:nil];

}


- (IBAction)runJarOnHadoop:(id)sender {
    
    
    
}

-(void)loadDragView:(NSNotification*)aNotification
{
    NSLog(@"Dragview");
}

-(void)loadConfigView:(NSNotification*)aNotification
{
    NSLog(@"Config view");
    
    [[MBHadoopController sharedHadoop] setArgs:[NSArray arrayWithObjects:@"jar", [[MBHadoopController sharedHadoop] jarPath], @"WordCount", @"/Users/marcelboersma/Downloads/Hadoop-WordCount/input",@"/Users/marcelboersma/hadoop-storage/ownjar/", nil]];
    
    [[MBHadoopController sharedHadoop] runJob];
  
}

-(void)loadLogView:(NSNotification*)aNotification
{
    NSLog(@"log view");
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
