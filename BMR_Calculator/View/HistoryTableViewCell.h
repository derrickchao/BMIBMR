//
//  HistoryTableViewCell.h
//  BMR_Calculator
//
//  Created by 趙子超 on 6/11/16.
//  Copyright © 2016 chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllRecord.h"
@interface HistoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bmiRecordLabel;
@property (weak, nonatomic) IBOutlet UILabel *bmrRecordLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyStatusLabel;

- (void)configureCell:(AllRecord *)record;

@end
