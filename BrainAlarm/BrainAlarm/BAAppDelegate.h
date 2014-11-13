//
//  BAAppDelegate.h
//  BrainAlarm
//
//  Created by Nathaniel Mendoza on 10/22/14.
//  Copyright (c) 2014 ___CSE494___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "MBProgressHUD.h"

@interface BAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *alarmList;
//@property (strong, nonatomic) NSString *soundName;

@property (strong, nonatomic) PFUser *user;

@end
