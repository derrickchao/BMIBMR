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

const CGFloat IPHONE_CELL_HEIGHT = 40.0;
const CGFloat IPAD_CELL_HEIGHT = 55.0;

@interface BMIStatusTableVC () 

@end

@implementation BMIStatusTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = [UIColor colorWithRed:63.0/255.0 green:59.0/255.0 blue:58.0/255.0 alpha:0.7];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Property

- (void)setBodyResult:(BodyResult *)bodyResult {
    _bodyResult = bodyResult;
    if (bodyResult) {
        [self settingSelectedStatusCell:bodyResult.bodyStatus];
    } else {
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionNone animated:false];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [BMI_STATUS_LOCALIZABLE_ARRAY count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular && self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular) {
        return IPAD_CELL_HEIGHT;
    }
    return IPHONE_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BMIStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BMIStatusCell" forIndexPath:indexPath];
    
    [cell configureCell:indexPath bodyResult:self.bodyResult];
    
#ifdef DEBUG
    NSLog(@"cell color: %@, index:%ld", cell.backgroundColor, indexPath.row);
#endif
    
    return cell;
}

- (void)settingSelectedStatusCell:(NSString *)bodyStatus {
    [self.tableView reloadData];
    int index = 0;
    for (NSString *status in BMI_STATUS_ARRAY) {
        if ([bodyStatus isEqualToString:status]) {
            break;
        }
        index++;
    }
    NSLog(@"index: %ld", index);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:true];
    
}

@end
