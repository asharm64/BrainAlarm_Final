//
//  ParseServer.m
//  CheersApp
//
//  Created by Sumit Gupta on 9/1/14.
//  Copyright (c) 2014 Sumit Gupta. All rights reserved.
//

#import "ParseServer.h"

@implementation ParseServer


-(void)createUser
{
    PFUser *user = [PFUser user];
    user.username = @"my name2";
    user.password = @"my pass";
    user.email = @"email12@example.com";
    user[@"location"]=@"abc";
    // other fields can be set if you want to save more information
    user[@"phone"] = @"650-555-0000";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
        }
    }];
}
@end
