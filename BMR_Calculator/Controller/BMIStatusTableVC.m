//
//  BMIStatusTableVC.m
//  BMIBMRCalculator
//
//  Created by 趙子超 on 20/01/2018.
//  Copyright © 2018 chao. All rights reserved.
//

#import "BMIStatusTableVC.h"
#import "BMIStatusCell.h"
#import "Constants.h"

@interface BMIStatusTableVC () {
    BMIStatusCell *_selectedCell;
}
@end

@implementation BMIStatusTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = [UIColor colorWithRed:63.0/255.0 green:59.0/255.0 blue:58.0/255.0 alpha:0.7];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [BMI_STATUS_ARRAY count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BMIStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BMIStatusCell" forIndexPath:indexPath];
    
    [cell configureCell:indexPath bodyResult:self.bodyResult];
    
    return cell;
}

@end
