//
//  BAJumpingJackTask.m
//  BrainAlarm
//
//  Created by Buv Sethia on 11/4/14.
//  Copyright (c) 2014 ___CSE494___. All rights reserved.
//

#import "BAJumpingJackTask.h"
@import CoreMotion;

@interface BAJumpingJackTask ()

// How often should we update our position and velocity?
@property (nonatomic,strong) NSTimer *accelerometerUpdate;

// This will allow us to read our accelerometer values
@property (nonatomic,strong) CMMotionManager *motionManager;

//JJs done by the user
@property NSInteger numberOfJacks;

//Number of JJs user needs to do
@property NSInteger jacksToComplete;

@end

@implementation BAJumpingJackTask

//Used to check different points of the JJ to determine if a full one is done
bool xOkay1;
bool xOkay2;
bool yOkay;
bool zOkay;

static BAJumpingJackTask *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (BAJumpingJackTask *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}


-(id)init
{
    self = [super init];
    if(self)
    {
        //create an accelerometer manager
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.accelerometerUpdateInterval = .05;
        [self.motionManager startAccelerometerUpdates];
        self.accelerometerUpdate = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(update:) userInfo:Nil repeats:YES];
        
        //JJ initialization stuff
        self.numberOfJacks = 0;
        self.jacksToComplete = 10;
        xOkay1 = false;
        xOkay2 = false;
        yOkay = false;
        zOkay = false;
    }
    
    return self;
}

//Timer method
-(void)update:(NSTimer *)theTimer
{
    // get the current accelerometer data
    CMAccelerometerData *accelerometerData = self.motionManager.accelerometerData;
    
    
    //Check if different parts of the JJ have been done
    if(fabs(accelerometerData.acceleration.x) >= 1)
    {
        xOkay1 = true;
        NSLog(@"X1 Met");
    }
    if(fabs(accelerometerData.acceleration.x) <= .1)
    {
        xOkay2 = true;
        NSLog(@"X2 Met");
    }
    if (fabs(accelerometerData.acceleration.y) >= 1.90)
    {
        yOkay = true;
        NSLog(@"Y1 Met");
    }
    if (fabs(accelerometerData.acceleration.z) >= .5)
    {
        zOkay = true;
        NSLog(@"Z1 Met");
    }
    
    //If a full JJ has been done, increment the number done and reset to check for another
    if(xOkay1 && xOkay2 && yOkay && zOkay)
    {
        self.numberOfJacks++;
        NSLog(@"1 Jack completed");
        xOkay1 = false;
        xOkay2 = false;
        yOkay = false;
        zOkay = false;
    }
    
}





//Stop accelerometer and reset the shared instance for the next alarm
-(void)terminateJJTask
{
    [self.motionManager stopAccelerometerUpdates];
    if ([self.accelerometerUpdate isValid])
    {
        [self.accelerometerUpdate invalidate];
        self.accelerometerUpdate = nil;
    }
    self.numberOfJacks = 0;
    xOkay1 = false;
    xOkay2 = false;
    yOkay = false;
    zOkay = false;
    sharedInstance = nil;
}

//If the user has done the required amount of JJs
-(bool)JacksCompleted
{
    return (int) self.numberOfJacks  >= (int) self.jacksToComplete;
}

//Number of JJs done
-(NSInteger)JacksDone
{
    return self.numberOfJacks;
}

@end
