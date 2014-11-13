//
//  BACompleteTaskViewController.h
//  BrainAlarm
//
//  Created by Nathaniel Mendoza on 10/22/14.
//  Copyright (c) 2014 ___CSE494___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BACompleteTaskViewController : UIViewController

@property int taskType;
@property NSDate *date;

@property UILocalNotification *notification;

-(IBAction)stopAlarm:(id)sender;

@end
