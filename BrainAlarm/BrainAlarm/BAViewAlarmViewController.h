//
//  BAViewAlarmViewController.h
//  BrainAlarm
//
//  Created by Nathaniel Mendoza on 10/22/14.
//  Copyright (c) 2014 ___CSE494___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BAViewAlarmViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UIButton *editBtn;
    
}

@property(strong, nonatomic) PFObject *alarmObject;

@property int alarmIndex;


@end
