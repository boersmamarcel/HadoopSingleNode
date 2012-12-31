//
//  MBMonitor.m
//  Hadoop app
//
//  Created by Marcel Boersma on 12/6/12.
//  Copyright (c) 2012 Marcel Boersma. All rights reserved.
//

#import "MBMonitor.h"
#import "MBMonitorMessages.h"

#define CORNERRADIUS 5

@implementation MBMonitor

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        self.wantsLayer = YES;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = CORNERRADIUS;
        self.layer.borderColor = [[NSColor blackColor] CGColor];
        self.layer.borderWidth = 1;
        self.layer.backgroundColor = [[NSColor redColor] CGColor];
        
    }
    
    return self;
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    
    if (object == [MBMonitorMessages sharedMonitorMessages] && [keyPath isEqualToString:@"message"]) {

        [[self message ] setStringValue:[[MBMonitorMessages sharedMonitorMessages] message]];
        
    }else if(object == [MBMonitorMessages sharedMonitorMessages] && [keyPath isEqualToString:@"description"]){

        [[self description ] setStringValue:[[MBMonitorMessages sharedMonitorMessages] description]];
        
    }
}

-(void)startProgressIndicator:(NSNotification*)aNotification
{
    [[self progress] setHidden:NO];
    [[self progress] startAnimation:nil];
}

-(void)stopProgressIndicator:(NSNotification*)aNotification
{
    [[self progress] stopAnimation:nil];
    [[self progress] setHidden:YES];
    
}


-(void)awakeFromNib
{
    
    [[MBMonitorMessages sharedMonitorMessages] addObserver:self forKeyPath:@"message" options:0 context:nil];
    [[MBMonitorMessages sharedMonitorMessages] addObserver:self forKeyPath:@"description" options:0 context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startProgressIndicator:) name:@"startProgress" object:[MBMonitorMessages sharedMonitorMessages]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopProgressIndicator:) name:@"stopProgress" object:[MBMonitorMessages sharedMonitorMessages]];

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[MBMonitorMessages sharedMonitorMessages] removeObserver:self forKeyPath:@"message"];
    [[MBMonitorMessages sharedMonitorMessages] removeObserver:self forKeyPath:@"description"];

}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    
    [[NSColor colorWithPatternImage:[NSImage imageNamed:@"monitor"]] set];
    NSRectFill(dirtyRect);
 
    
}

@end
