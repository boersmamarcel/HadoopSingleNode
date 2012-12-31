//
//  MBMonitorMessages.m
//  HadoopSingleNode
//
//  Created by Marcel Boersma on 12/17/12.
//  Copyright (c) 2012 Marcel Boersma. All rights reserved.
//

#import "MBMonitorMessages.h"

static MBMonitorMessages* instance;

@implementation MBMonitorMessages


+(MBMonitorMessages*)sharedMonitorMessages
{
    @synchronized(self){
        if(instance == nil)
        {
            instance = [[MBMonitorMessages alloc] init];
        }
    }
    return instance;
}


-(void)startProgressIndicator
{
     
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startProgress" object:[MBMonitorMessages sharedMonitorMessages]];
}

-(void)stopProgressIndicator
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopProgress" object:[MBMonitorMessages sharedMonitorMessages]];

}

@end
