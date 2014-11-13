//
//  BATableViewController.m
//  BrainAlarm
//
//  Created by Nathaniel Mendoza on 10/22/14.
//  Copyright (c) 2014 ___CSE494___. All rights reserved.
//

#import "BATableViewController.h"
#import "BAViewAlarmViewController.h"
#import "BAAlarmModel.h"

@interface BATableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BATableViewController


//static object for the alarm list
static NSMutableArray *alarmList;

//returns the list of alarms
+ (NSMutableArray *)alarms
{
    if (!alarmList)
        alarmList = [[NSMutableArray alloc] init];
    
    return alarmList;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

//reload the table view
-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
    NSLog(@"Reload");
    
    [self getAlarms];
}


- (void) getAlarms{
    
    [MBProgressHUD showHUDAddedTo:((BAAppDelegate *)APP_DELEGATE).window animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"Alarms" predicate:[NSPredicate predicateWithFormat:@"alarm_date>%@",[NSDate date]]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:((BAAppDelegate *)APP_DELEGATE).window animated:YES];
        if (!error) {
            
            NSLog(@"all alarms = %@", objects);
            
            if (APP_DELEGATE.alarmList && objects) {
                
                [APP_DELEGATE.alarmList removeAllObjects];
                [APP_DELEGATE.alarmList addObjectsFromArray:objects];
                
                [self.tableView reloadData];
            }
            else if(!APP_DELEGATE.alarmList){
                
                APP_DELEGATE.alarmList = [[NSMutableArray alloc] init];
            }
        }
        else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Unknown error!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        [MBProgressHUD hideAllHUDsForView:APP_DELEGATE.window animated:YES];
    }];
    
}

//when the table view first loads
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //load the alarm list from nscoding
//    [BATableViewController LoadAlarmList];
//    
//    [self.tableView reloadData];
    
    [self getAlarms];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    int numberOfRows = 0;
    
    if (APP_DELEGATE.alarmList) {
        
        numberOfRows = APP_DELEGATE.alarmList.count;
    }
    
    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"hh:mm a EEE, MMM dd";
    
    PFObject *alarmObject = [APP_DELEGATE.alarmList objectAtIndex:indexPath.row];
    
    NSString *formattedDate = [formatter stringFromDate:alarmObject[@"alarm_date"]];
    
    
    cell.textLabel.text = formattedDate;
    
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //if the segue is a segue to the view alarm screen
    if ([segue.identifier isEqualToString:@"tableViewSegue"])
    {
        UITableViewCell *cell = sender;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        BAViewAlarmViewController *dest = [segue destinationViewController];
        // send the index of the alarm to the view alarm screen
        dest.alarmIndex = (int) indexPath.row;
        
        NSLog(@"Segue TableView: %d", dest.alarmIndex);
        
    }
}


#pragma mark - persistence functions
+ (NSString *)documentsDirectory
{
    // for those of you familiar with command prompt this will make sense
    // for those of you not familiar a tilde usually refers to your "home"
    // so we ask for a path to <our applications home>/Documents
    return [@"~/Documents" stringByExpandingTildeInPath];
}
+(NSString *)dataFilePath
{
    // this will return <our applications home>/Documents/Checklist.plist
    // if we write here the system will generate a new file in the Documents folder
    // if we wanted to save many files we could just append different files to the path
    NSLog(@"%@",[self documentsDirectory]);
    return [[self documentsDirectory] stringByAppendingPathComponent:@"TestFile.plist"];
    
}

+(void)LoadAlarmList
{
    NSString *path = [self dataFilePath];
    
    //do we have anything in our documents directory?  If we have anything then load it up
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        //load the alarm from the list
        alarmList = [unarchiver decodeObjectForKey:@"AlarmList"];
        [unarchiver finishDecoding];
    }
    else
    {
        //instantiate a new alarm object
        alarmList = [[NSMutableArray alloc]init];
    }
}

+(void)SaveAlarmList
{
    // create a generic data storage object
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //encode the object (list of alarms)
    [archiver encodeObject: alarmList forKey:@"AlarmList"];
    
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
