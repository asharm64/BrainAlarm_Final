//
//  BAAlarmModel.m
//  BrainAlarm
//
//  Created by Nathaniel Mendoza on 10/22/14.
//  Copyright (c) 2014 ___CSE494___. All rights reserved.
//

#import "BAAlarmModel.h"

@implementation BAAlarmModel

//encoder methods for NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.alarmTime forKey:@"alarmTime"];
    [aCoder encodeInt:self.type forKey:@"type"];
}


//grab object instance variables
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.alarmTime = [aDecoder decodeObjectForKey:@"alarmTime"];
    self.type = [aDecoder decodeIntForKey:@"type"];
    
    return self;
}
@end
