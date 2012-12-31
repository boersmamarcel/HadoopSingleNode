//
//  MBHadoopController.h
//  Hadoop app
//
//  Created by Marcel Boersma on 12/8/12.
//  Copyright (c) 2012 Marcel Boersma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBHadoopController : NSObject
{
    dispatch_queue_t hadoopQueue;
    
    bool hadoopIsRunning;

}

@property (atomic) NSString *jarPath;
@property (atomic) NSArray *args;

-(bool)getHadoopIsRunning;
+(MBHadoopController*)sharedHadoop;
-(void)formatNamenode;
-(void)runExample;
-(BOOL)startAll;
-(BOOL)stopAll;

-(void)runJobWithPath:(NSString*)aPath andArguments:(NSArray*)args;

-(void)runJob;

@end
