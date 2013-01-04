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


#import "MBHadoopController.h"
#include <unistd.h>
#import "MBMonitorMessages.h"

static MBHadoopController *controller;

typedef void (^asyncTask)(void);

@interface MBHadoopController (Hidden)
-(void)setHadoopIsRunning:(BOOL)aBool;
@end

@implementation MBHadoopController
@synthesize jarPath, args, logOutput;

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
        
        
        //NSArray *arguments = [[NSArray alloc] initWithArray:[self args]];
        
        NSMutableArray *arguments = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:@"jar", [self jarPath], nil]];
        
        [arguments addObjectsFromArray:[self args]];
        
        
        NSTask *job = [[NSTask alloc] init];
        [job setLaunchPath:hadoopExecutablePath];
        [job setArguments:arguments];
        
        

        [job launch];
        [job waitUntilExit];
      
        dispatch_async(dispatch_get_main_queue(), ^{
            //due to threading and KVC the setValue needs to be called in the main thread
            
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
        
        NSString *hadoop = [hadoopBundle pathForResource:@"bin/start-mapred.sh" ofType:nil];
        

        NSDictionary *defaultEnvironment = [[NSProcessInfo processInfo] environment];
        NSMutableDictionary *environment = [[NSMutableDictionary alloc] initWithDictionary:defaultEnvironment];
      
        [environment setObject:[hadoopBundle resourcePath]  forKey:@"HADOOP_HOME"];
        [environment setObject:@"/usr/libexec/java_home" forKey:@"JAVA_HOME"];
     
        
        
        [runHadoop setEnvironment:environment];
        [runHadoop setLaunchPath:hadoop];
        
             
        [runHadoop launch];
         [runHadoop waitUntilExit];
             
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
            
            NSString *hadoop = [hadoopBundle pathForResource:@"bin/stop-mapred.sh" ofType:nil];
            
            
            NSDictionary *defaultEnvironment = [[NSProcessInfo processInfo] environment];
            NSMutableDictionary *environment = [[NSMutableDictionary alloc] initWithDictionary:defaultEnvironment];
            
            [environment setObject:[hadoopBundle resourcePath]  forKey:@"HADOOP_HOME"];
            [environment setObject:@"/usr/libexec/java_home" forKey:@"JAVA_HOME"];
            
            
            
            [stopHadoopTask setEnvironment:environment];
            [stopHadoopTask setLaunchPath:hadoop];
            
                     
            [stopHadoopTask launch];
            [stopHadoopTask waitUntilExit];
         
            dispatch_async(dispatch_get_main_queue(), ^{
                [[MBMonitorMessages sharedMonitorMessages] setMessage:@""];
                [[MBMonitorMessages sharedMonitorMessages] stopProgressIndicator];
                [[MBMonitorMessages sharedMonitorMessages] setDescription:@""];
            });
            
            [self setHadoopIsRunning:NO];

        };
        
        dispatch_async(hadoopQueue, stopHadoop);
    }
    
    return YES;
}

@end
