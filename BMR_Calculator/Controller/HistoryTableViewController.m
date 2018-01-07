//
//  HistoryTableViewController.m
//  BMR_Calculator
//
//  Created by 趙子超 on 6/11/16.
//  Copyright © 2016 chao. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "MyCoreDataManager.h"
#import "HistoryTableViewCell.h"
#import "AllRecord+CoreDataProperties.h"
#import "MyTabBarController.h"

#define BMIRECORD_KEY @"bmiRecord"
#define BMRRECORD_KEY @"bmrRecord"
#define TIMESTAMP_KEY @"timeStamp"

@interface HistoryTableViewController ()
{
    MyCoreDataManager *dataManager;
}
@end

@implementation HistoryTableViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    dataManager = ((MyTabBarController *)self.tabBarController).dataManager;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataManager totalItems];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSManagedObject *object = [dataManager getByIndex:indexPath.row];
    NSString *timeStamp = [NSString stringWithFormat:@"%@", [dateFormater stringFromDate:[object valueForKey:TIMESTAMP_KEY]]];
    
    cell.bmiRecordLabel.text = [NSString stringWithFormat:@"BMI: %.1f",[[object valueForKey:BMIRECORD_KEY] floatValue]];
    cell.bmrRecordLabel.text = [NSString stringWithFormat:@"BMR: %.1f cals/day",[[object valueForKey:BMRRECORD_KEY] floatValue]];
    cell.timeStampLabel.text = timeStamp;

    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSManagedObject *object = [dataManager getByIndex:indexPath.row];
        
        [dataManager deleteItem:object];
        
        [dataManager save];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
