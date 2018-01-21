//
//  HistoryTableViewController.m
//  BMR_Calculator
//
//  Created by 趙子超 on 6/11/16.
//  Copyright © 2016 chao. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "HistoryTableViewCell.h"
#import "AllRecord+CoreDataProperties.h"
#import "CoreDataManager.h"

@interface HistoryTableViewController () <CoreDataManagerDelegate>
{
    NSDateFormatter *dateFormater;
}
@property (strong, nonatomic) IBOutlet UIView *noResultsView;
@end

@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    [CoreDataManager shareInstance].delegate = self;
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([[CoreDataManager shareInstance] totalRecords] == 0) {
        // Set Tableview background View when no datas.
        self.tableView.backgroundView = self.noResultsView;
    } else {
        self.tableView.backgroundView = nil;
    }
    
    return [[CoreDataManager shareInstance] totalRecords];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
    
    AllRecord *record = [[CoreDataManager shareInstance] getRecordByIndex:indexPath.row];
    [cell configureCell:record];

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
        AllRecord *recordToDelete = [[CoreDataManager shareInstance] getRecordByIndex:indexPath.row];
        [[CoreDataManager shareInstance] deleteRecord:recordToDelete];
    }
}

#pragma mark - CoreDataManagerDelegate

- (void)willChangedContent {
    [self.tableView beginUpdates];
}

- (void)didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(ResultChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch (type) {
        case Insert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        case Delete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        default:
            break;
    }
}

- (void)didChangedContent {
    [self.tableView endUpdates];
}

@end
