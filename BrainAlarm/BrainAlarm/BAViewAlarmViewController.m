//
//  BAViewAlarmViewController.m
//  BrainAlarm
//
//  Created by Nathaniel Mendoza on 10/22/14.
//  Copyright (c) 2014 ___CSE494___. All rights reserved.
//

#import "BAViewAlarmViewController.h"
#import "BATableViewController.h"
#import "BAAlarmModel.h"

@interface BAViewAlarmViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *taskLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerViewAlarmSound;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)deleteAlarmButton:(id)sender;
- (IBAction)saveChanges:(UIButton *)sender;

@property NSArray *taskChoices;
@property NSArray *alarmSoundChoices;

@property BAAlarmModel *alarm;

@end

@implementation BAViewAlarmViewController

@synthesize alarmObject = _alarmObject;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Get the alarm selected from the table
    NSLog(@"array is %@",APP_DELEGATE.alarmList);
//    self.alarm = [BATableViewController alarms][self.alarmIndex];
    PFObject *object = APP_DELEGATE.alarmList[self.alarmIndex];
    
    //Show the user the alarm time
//    self.datePicker.date = [self.alarm alarmTime];
    self.datePicker.date = object[@"alarm_date"];
    
    self.pickerView.delegate = self;
    self.pickerViewAlarmSound.delegate = self;
    [self.pickerView reloadAllComponents];
    [self.pickerViewAlarmSound reloadAllComponents];
    
//    NSLog(@"AlarmType: %d", [self.alarm type]);
    
    //Show the user the task type
    switch([object[@"type"] integerValue])
    {
        case JJ:
            self.taskLabel.text = @"Jumping Jacks";
            break;
        case Math:
            self.taskLabel.text = @"Math";
            break;
    }
    
    self.taskChoices        = [[NSArray alloc] initWithObjects:@"Jumping Jacks", @"Math", nil];
    self.alarmSoundChoices  = [[NSArray alloc] initWithObjects:@"Alarm1", @"Alarm2", nil];
    
    [self.pickerView selectedRowInComponent:[object[@"type"] integerValue]];
    
}

//If the user wants to delete the alarm
- (IBAction)deleteAlarmButton:(id)sender
{
    
    PFObject *object = APP_DELEGATE.alarmList[self.alarmIndex];
        
    NSLog(@"object id = %@", object.objectId);
    
    [MBProgressHUD showHUDAddedTo:APP_DELEGATE.window animated:YES];
    
    //Find and remove the alarm from the alarm list
    for(BAAlarmModel *a in [BATableViewController alarms])
    {
        if([self.alarm isEqual:a])
        {
            [[BATableViewController alarms] removeObject:a];
            break;
        }
    }
    
    [BATableViewController SaveAlarmList];
    
    //Remove notifications pertaining to the alarm
    NSArray *notificationList = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for(UILocalNotification *not in notificationList)
    {
        if([self.alarm.alarmTime isEqual:object[@"alarm_date"]])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:not];
        }
    }
    
    
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:APP_DELEGATE.window animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)saveChanges:(UIButton *)sender
{
    
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    if (editBtn.selected)
    {
        
        NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
        
        PFObject *alarm = [APP_DELEGATE.alarmList objectAtIndex:_alarmIndex];
        
        NSLog(@"Sch not : %@", notifications);
        
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        [gregorian setTimeZone:[NSTimeZone localTimeZone]];
        
        NSDateComponents *comps = [gregorian
                                   components:NSYearCalendarUnit|NSMonthCalendarUnit|
                                   NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|
                                   NSTimeZoneCalendarUnit fromDate:alarm[@"alarm_date"]];
        [comps setTimeZone:[NSTimeZone localTimeZone]];
        
        NSDateComponents *dateComponent = [[NSDateComponents alloc]init];
        dateComponent.year = comps.year;
        dateComponent.month = comps.month;
        dateComponent.day = comps.day;
        dateComponent.hour = comps.hour;
        dateComponent.minute = comps.minute;
        dateComponent.second = 0;
        
        NSDate *date = [gregorian dateFromComponents:dateComponent];
        
        NSLog(@"Alarm time = %@", date);
        
        
        NSPredicate *predicate = [ NSPredicate predicateWithFormat:@"fireDate=%@",date];
        NSArray *filtered = [notifications filteredArrayUsingPredicate:predicate];
        
        for (int i = 0; filtered && i < filtered.count; i ++) {
            
            [[UIApplication sharedApplication] cancelLocalNotification:[filtered objectAtIndex:i]];
        }
        
        NSLog(@"Filtered notifications = %@", filtered);
        
        
        [editBtn setTitle:@"Edit this Alarm" forState:UIControlStateNormal];
        PFObject *object        = APP_DELEGATE.alarmList[self.alarmIndex];
        
        comps = [gregorian
                 components:NSYearCalendarUnit|NSMonthCalendarUnit|
                 NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|
                 NSTimeZoneCalendarUnit fromDate:self.datePicker.date];
        [comps setTimeZone:[NSTimeZone localTimeZone]];
        
        dateComponent = [[NSDateComponents alloc]init];
        dateComponent.year = comps.year;
        dateComponent.month = comps.month;
        dateComponent.day = comps.day;
        dateComponent.hour = comps.hour;
        dateComponent.minute = comps.minute;
        dateComponent.second = 0;
        
        date = [gregorian dateFromComponents:dateComponent];
        
        object[@"alarm_date"]   = date;
        object[@"type"]  = [NSNumber numberWithInt:[self.pickerView selectedRowInComponent:0]];
        
        [MBProgressHUD showHUDAddedTo:APP_DELEGATE.window animated:YES];
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            [MBProgressHUD hideAllHUDsForView:APP_DELEGATE.window animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        editBtn.selected = NO;
        self.datePicker.userInteractionEnabled = NO;
        self.pickerView.userInteractionEnabled = NO;
        self.pickerViewAlarmSound.userInteractionEnabled = NO;
        
        
        /**/
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = date;
        notification.repeatInterval = NSCalendarUnitMinute;
        notification.soundName = [NSString stringWithFormat:@"%@.wav",[self.alarmSoundChoices objectAtIndex:[self.pickerViewAlarmSound selectedRowInComponent:0]]];
        NSDictionary *infoDict = [NSDictionary dictionaryWithObject:date forKey:@"Name"];
        notification.userInfo = infoDict;
        NSString *alarmString;
        switch([object[@"type"] integerValue])
        {
            case Math:
                alarmString = @"Math task to be done!";
                break;
            case JJ:
                alarmString = @"Jumping Jacks to be done!";
                break;
            default: ;
        }
        notification.alertBody = alarmString;
        
        
        //subscribe the notification
        [[UIApplication sharedApplication] scheduleLocalNotification: notification];
        
        
        
        
    }
    else
    {
        [editBtn setTitle:@"Save" forState:UIControlStateNormal];
        editBtn.selected = YES;
        self.datePicker.userInteractionEnabled = YES;
        self.pickerView.userInteractionEnabled = YES;
        self.pickerViewAlarmSound.userInteractionEnabled = YES;
    }
}


-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView == self.pickerView)
        return self.taskChoices.count;
    else if (pickerView == self.pickerViewAlarmSound)
        return self.alarmSoundChoices.count;
    else
        return 0;
}

-(NSString* )pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView == self.pickerView)
        return self.taskChoices[row];
    else if (pickerView == self.pickerViewAlarmSound)
        return self.alarmSoundChoices[row];
    else
        return nil;
}



@end
