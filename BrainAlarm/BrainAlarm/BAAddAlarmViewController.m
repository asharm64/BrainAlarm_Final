//
//  BAAddAlarmViewController.m
//  BrainAlarm
//
//  Created by Nathaniel Mendoza on 10/22/14.
//  Copyright (c) 2014 ___CSE494___. All rights reserved.
//

#import "BAAddAlarmViewController.h"
#import "BAAlarmModel.h"
#import "BATableViewController.h"

@interface BAAddAlarmViewController ()

//properties for UI elements
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerViewAlarmSound;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


//array for choices (source for picker view)
@property NSArray *taskChoices;
@property NSArray *alarmSoundChoices;

@end

@implementation BAAddAlarmViewController

//picker view methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //initialize the array for picker view choices
    self.taskChoices        = [[NSArray alloc] initWithObjects:@"Jumping Jacks", @"Math", nil];
    self.alarmSoundChoices  = [[NSArray alloc] initWithObjects:@"Alarm1", @"Alarm2", nil];
    
    self.scrollView.contentSize = self.pickerView.superview.frame.size;
}

//add a new alarm button
- (IBAction)addAlarmAction:(id)sender
{
    //instantiate a new alarm object
    BAAlarmModel *newAlarm = [[BAAlarmModel alloc]init];
    
    //set the new alarm time to right now
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd hh:mm"];
    [dateFormater setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDateComponents *comps = [gregorian
                               components:NSYearCalendarUnit|NSMonthCalendarUnit|
                               NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|
                               NSTimeZoneCalendarUnit fromDate:self.datePicker.date];
    [comps setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDateComponents *dateComponent = [[NSDateComponents alloc]init];
    dateComponent.year = comps.year;
    dateComponent.month = comps.month;
    dateComponent.day = comps.day;
    dateComponent.hour = comps.hour;
    dateComponent.minute = comps.minute;
    dateComponent.second = 0;
    
    NSDate *date = [gregorian dateFromComponents:dateComponent];
    
    /**/
    
    /**/
    
    newAlarm.alarmTime = date;
    NSLog(@"alarm time %@",newAlarm.alarmTime);
    //set the type to whatever the picker view says
    newAlarm.type = (int) [self.pickerView selectedRowInComponent:0];
    NSLog(@"Add New: %d", newAlarm.type);
    
    
    //add the new alarm to the list
    [[BATableViewController alarms] addObject: newAlarm];
    
    //instantiate the local notification
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    //change all of the parameters for the notification
    notification.fireDate = newAlarm.alarmTime;
    notification.repeatInterval = NSCalendarUnitMinute;
    //Need to test
//    ((BAAppDelegate *)APP_DELEGATE).soundType = [self.pickerViewAlarmSound selectedRowInComponent:0];
    
    notification.soundName = [NSString stringWithFormat:@"%@.wav",[self.alarmSoundChoices objectAtIndex:[self.pickerViewAlarmSound selectedRowInComponent:0]]];
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:newAlarm.alarmTime forKey:@"Name"];
    notification.userInfo = infoDict;
    NSString *alarmString;
    
    //depending on which type, change the type of task to be done
    switch(newAlarm.type)
    {
        case Math:
            alarmString = @"Math task to be done!";
            break;
        case JJ:
            alarmString = @"Jumping Jacks to be done!";
            break;
        default: ;
    }
    
    
    //change the alert body of the notification
    notification.alertBody = alarmString;
    
    
    //subscribe the notification
    [[UIApplication sharedApplication] scheduleLocalNotification: notification];
    
    //[notification release];
    
    //save the alarm list using nscoding
    [BATableViewController SaveAlarmList];
    
    //pop back to tableviewcontroller
    [self.navigationController popViewControllerAnimated:YES];
    
    PFObject *object = [[PFObject alloc] initWithClassName:@"Alarms"];
    object[@"alarm_date"] = date;
    object[@"type"] = [NSNumber numberWithInt:newAlarm.type];
    object[@"is_deleted"] = [NSNumber numberWithBool:NO];
    
    NSLog(@"----------- %@", APP_DELEGATE.user);
    
    object[@"user_email"] = APP_DELEGATE.user[@"email"];
    
    
    [UIView animateWithDuration:.5f animations:^{
        
        [MBProgressHUD showHUDAddedTo:APP_DELEGATE.window animated:NO];
    } completion:^(BOOL finished) {
        
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            [MBProgressHUD hideAllHUDsForView:APP_DELEGATE.window animated:NO];
            if (!error) {
                
                NSLog(@"success");
            }
            else{
                
                UIAlertView *userAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Unknown error found!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [userAlert show];
            }
        }];
    }];
    
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
