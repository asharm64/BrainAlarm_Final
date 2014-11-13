//
//  BAAppDelegate.m
//  BrainAlarm
//
//  Created by Nathaniel Mendoza on 10/22/14.
//  Copyright (c) 2014 ___CSE494___. All rights reserved.
//

#import "BAAppDelegate.h"
#import "BACompleteTaskViewController.h"
#import "BATableViewController.h"

@implementation BAAppDelegate

@synthesize alarmList = _alarmList;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Asks the user to allow notifications
//    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
//        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
//    }
    
//    [Parse setApplicationId:@"8SHcroWpVNTcYKsvkA0Z9HQ3HFXMhlqvksX5Mhlm"
//                  clientKey:@"fFTD4dX802LldEt27E538h4qYaICs7GPB78CiJI6"];

    
    [Parse setApplicationId:@"0H2Yb8Qw7HcfQDgeeoxUaBqGQO9zz5nEaOqZQnMC"
                  clientKey:@"T1C9sOqeMMKfIURv36V6UTkWmYehCyKgyfRPDoez"];
    
    //If a notification is fired, show them the task they need to complete
   UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        BACompleteTaskViewController * notificationViewController = [storyBoard instantiateViewControllerWithIdentifier:@"CompleteTaskViewController"];
        
        notificationViewController.notification = [locationNotification copy];
        
        notificationViewController.date = [locationNotification.fireDate copy];

        [BATableViewController LoadAlarmList];

        self.window.rootViewController = notificationViewController;
    }
    
    //[PFUser enableAutomaticUser];
    
    PFACL *defaultACL = [PFACL ACL];
    self.window.userInteractionEnabled = NO;
    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    __block UIAlertView *connectionAlert = [[UIAlertView alloc] initWithTitle:nil message:@"please wait..." delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    [connectionAlert show];
    
    [PFUser logInWithUsernameInBackground:@"Alarm" password:@"Alarm" block:^(PFUser *user, NSError *error) {
        if (!error) {
            
            self.user = user;
            self.window.userInteractionEnabled = YES;
            
            NSLog(@"user after login = %@", user);
            
            [connectionAlert dismissWithClickedButtonIndex:0 animated:YES];
        }
        else{
            
            self.user = [PFUser user];
            
            self.user.username = @"Alarm";
            self.user.password = @"Alarm";
            self.user.email = @"alarm@alarm.com";
            [self.user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                [connectionAlert dismissWithClickedButtonIndex:0 animated:YES];
                if (!error) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                else{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"error"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            }];
        }
    }];
    
    return YES;
}

//If a notification is fired, show them the task they need to complete
-(void)application:(UIApplication*)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    BACompleteTaskViewController * notificationViewController = [storyBoard instantiateViewControllerWithIdentifier:@"CompleteTaskViewController"];
    
   notificationViewController.notification = [notification copy];
    notificationViewController.date = [notification.fireDate copy];
    
    [BATableViewController LoadAlarmList];

    self.window.rootViewController = notificationViewController;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark- Alarm
//- (void) getAlarms{
//    
//    PFQuery *query = [PFQuery queryWithClassName:@"AlarmDetails" predicate:[NSPredicate predicateWithFormat:@"alarm_date>%@",[NSDate date]]];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            
//            NSLog(@"all alarms = %@", objects);
//            
//            if (APP_DELEGATE.alarmList && objects) {
//                
//                [APP_DELEGATE.alarmList removeAllObjects];
//                [APP_DELEGATE.alarmList addObjectsFromArray:objects];
//                
//                [self.tableView reloadData];
//            }
//            else if(!APP_DELEGATE.alarmList){
//                
//                APP_DELEGATE.alarmList = [[NSMutableArray alloc] init];
//            }
//        }
//        else{
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Unknown error!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
//        }
//    }];
//    
//}
@end
