//
//  BAJumpingJackTask.h
//  BrainAlarm
//
//  Created by Buv Sethia on 11/4/14.
//  Copyright (c) 2014 ___CSE494___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAJumpingJackTask : NSObject

-(bool)JacksCompleted;
-(NSInteger)JacksDone;
-(void)terminateJJTask;

//Creates a static instance of the JJ Class
+ (BAJumpingJackTask *)sharedInstance;

-(IBAction)stopAlarm:(id)sender;

@end
