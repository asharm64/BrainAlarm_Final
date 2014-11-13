//
//  BAAlarmModel.h
//  BrainAlarm
//
//  Created by Nathaniel Mendoza on 10/22/14.
//  Copyright (c) 2014 ___CSE494___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAAlarmModel : NSObject

//enum for type of task
typedef enum
{
    JJ,
    Math
} TaskType;

//enum for days of week (unused for now)
typedef enum
{
    Sun,
    Mon,
    Tue,
    Wed,
    Thu,
    Fri,
    Sat
   
} Days;

//alarm time object for alarms
@property NSDate *alarmTime;

//type of task for alarms
@property TaskType type;
//@property NSArray *daysActive;




@end
