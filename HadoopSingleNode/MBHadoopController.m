//
//  MBHadoopController.m
//  Hadoop app
//
//  Created by Marcel Boersma on 12/8/12.
//  Copyright (c) 2012 Marcel Boersma. All rights reserved.
//

#import "MBHadoopController.h"
#include <unistd.h>
#import "MBMonitorMessages.h"

static MBHadoopController *controller;

typedef void (^asyncTask)(void);
typedef void (^asyncJob)(NSDictionary *dict);

@interface MBHadoopController (Hidden)
-(void)setHadoopIsRunning:(BOOL)aBool;
@end

@implementation MBHadoopController
@synthesize jarPath, args;

+(MBHadoopController*)sharedHadoop
{
    @synchronized(self)
    {
        if(controller == nil)
        {
            controller = [[MBHadoopController alloc] init];
        }
    }
    
    return controller;
}

-(void)setHadoopIsRunning:(BOOL)aBool
{
    @synchronized(self)
    {
        hadoopIsRunning = aBool;
    }
}

-(bool)getHadoopIsRunning
{
    @synchronized(self)
    {
        return hadoopIsRunning;
    }
}



-(void)runExample
{
        
}


-(void)runJobWithPath:(NSString*)aPath andArguments:(NSArray*)someArgs
{
    
    [self setJarPath:aPath];
    [self setArgs:someArgs];
    [self runJob];
    
}

-(void)runJob{
    
    [[MBMonitorMessages sharedMonitorMessages] setMessage:@"Running custom jar.."];
    [[MBMonitorMessages sharedMonitorMessages] setDescription:@"Loading setup"];
    
    hadoopQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    
    asyncTask  runJob = ^(void){
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[MBMonitorMessages sharedMonitorMessages] setDescription:@"Starting job.."];
            [[MBMonitorMessages sharedMonitorMessages] startProgressIndicator];
        });
        
        
        
        NSString *hadoopBundlePath = [[NSBundle mainBundle] pathForResource:@"hadoop" ofType:@"bundle"];
        
        NSBundle *hadoopBundle = [NSBundle bundleWithPath:hadoopBundlePath];
        
        NSString *hadoopExecutablePath = [hadoopBundle pathForResource:@"bin/hadoop" ofType:nil];
        
        
        NSArray *arguments = [[NSArray alloc] initWithArray:[self args]];
        
        NSTask *example = [[NSTask alloc] init];
        [example setLaunchPath:hadoopExecutablePath];
        [example setArguments:arguments];
        
        
        NSPipe *pipe = [[NSPipe alloc] init];
        [example setStandardOutput:pipe];
        
        
        [example launch];
        
        
        NSFileHandle *file = [pipe fileHandleForReading];
        
        NSData *output = [file readDataToEndOfFile];
        
        NSString *outputString = [[NSString alloc] initWithData:output encoding:NSUTF8StringEncoding];
        NSLog (@"Jar is %s:\n", [outputString UTF8String]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[MBMonitorMessages sharedMonitorMessages] setDescription:@"Done" ];
            [[MBMonitorMessages sharedMonitorMessages] stopProgressIndicator];
        });

    };
    
    dispatch_async(hadoopQueue, runJob);
}


-(BOOL)startAll
{
    [[MBMonitorMessages sharedMonitorMessages] setMessage:@"Starting hadoop.."];
    [[MBMonitorMessages sharedMonitorMessages] startProgressIndicator];
   
    hadoopQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
     asyncTask startHadoop = ^(void){
    
        //Load Hadoop bundle
        NSString *hadoopBundlePath = [[NSBundle mainBundle] pathForResource:@"hadoop" ofType:@"bundle"];

        
        NSBundle *hadoopBundle = [NSBundle bundleWithPath:hadoopBundlePath];
     
        //create a taks to run hadoop
        NSTask *runHadoop = [[NSTask alloc] init];
        
        NSString *hadoop = [hadoopBundle pathForResource:@"bin/start-all.sh" ofType:nil];
        

        NSDictionary *defaultEnvironment = [[NSProcessInfo processInfo] environment];
        NSMutableDictionary *environment = [[NSMutableDictionary alloc] initWithDictionary:defaultEnvironment];
      
        [environment setObject:[hadoopBundle resourcePath]  forKey:@"HADOOP_HOME"];
        [environment setObject:@"/usr/libexec/java_home" forKey:@"JAVA_HOME"];
     
        
        
        [runHadoop setEnvironment:environment];
        [runHadoop setLaunchPath:hadoop];
        
        
        NSPipe *pipe = [NSPipe pipe];
        [runHadoop setStandardOutput:pipe];
        
        NSFileHandle *file = [pipe fileHandleForReading];
        
        [runHadoop launch];
        
        NSData *output = [file readDataToEndOfFile];
        
        NSString *string;
        string = [[NSString alloc] initWithData: output encoding: NSUTF8StringEncoding];
        NSLog (@"hadoop returned:\n%@", string);
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [[MBMonitorMessages sharedMonitorMessages] setMessage:@"Hadoop is up and running"];
             [[MBMonitorMessages sharedMonitorMessages] stopProgressIndicator];
         });
         
         
         [self setHadoopIsRunning:YES];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [[MBMonitorMessages sharedMonitorMessages] setDescription:@"Try running your own jar.."];
         });
    };
    
    dispatch_async(hadoopQueue, startHadoop);
    
    
    return YES;
}

-(BOOL)stopAll
{
    
    if([self getHadoopIsRunning])
    {
        
        [[MBMonitorMessages sharedMonitorMessages] setMessage:@"Stopping hadoop.."];
        [[MBMonitorMessages sharedMonitorMessages] startProgressIndicator];
        
        hadoopQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        asyncTask stopHadoop = ^{
            
            //Load Hadoop bundle
            NSString *hadoopBundlePath = [[NSBundle mainBundle] pathForResource:@"hadoop" ofType:@"bundle"];
            
            
            NSBundle *hadoopBundle = [NSBundle bundleWithPath:hadoopBundlePath];
            
            //create a taks to run hadoop
            NSTask *stopHadoopTask = [[NSTask alloc] init];
            
            NSString *hadoop = [hadoopBundle pathForResource:@"bin/stop-all.sh" ofType:nil];
            
            
            NSDictionary *defaultEnvironment = [[NSProcessInfo processInfo] environment];
            NSMutableDictionary *environment = [[NSMutableDictionary alloc] initWithDictionary:defaultEnvironment];
            
            [environment setObject:[hadoopBundle resourcePath]  forKey:@"HADOOP_HOME"];
            [environment setObject:@"/usr/libexec/java_home" forKey:@"JAVA_HOME"];
            
            
            
            [stopHadoopTask setEnvironment:environment];
            [stopHadoopTask setLaunchPath:hadoop];
            
            
            NSPipe *pipe = [NSPipe pipe];
            [stopHadoopTask setStandardOutput:pipe];
            
            NSFileHandle *file = [pipe fileHandleForReading];
            
            [stopHadoopTask launch];
            
            NSData *output = [file readDataToEndOfFile];
            
            NSString *string;
            string = [[NSString alloc] initWithData: output encoding: NSUTF8StringEncoding];
            NSLog (@"hadoop stopping returned:\n%@", string);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[MBMonitorMessages sharedMonitorMessages] setMessage:@""];
                [[MBMonitorMessages sharedMonitorMessages] stopProgressIndicator];
            });
            
            [self setHadoopIsRunning:NO];

        };
        
        dispatch_async(hadoopQueue, stopHadoop);
    }
    
    return YES;
}

@end
