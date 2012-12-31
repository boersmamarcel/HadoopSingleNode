//
//  MBMonitorMessages.h
//  HadoopSingleNode
//
//  Created by Marcel Boersma on 12/17/12.
//  Copyright (c) 2012 Marcel Boersma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBMonitorMessages : NSObject
{
    
}

+(MBMonitorMessages*)sharedMonitorMessages;
@property (weak) NSString* message;
@property (weak) NSString* description;

-(void)startProgressIndicator;
-(void)stopProgressIndicator;

@end
