//
//  HistoryTableViewCell.m
//  BMR_Calculator
//
//  Created by 趙子超 on 6/11/16.
//  Copyright © 2016 chao. All rights reserved.
//

#import "HistoryTableViewCell.h"

@interface HistoryTableViewCell ()

@end

@implementation HistoryTableViewCell

+ (NSString *)createTimestamp:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return  [dateFormatter stringFromDate:date];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)configureCell:(AllRecord *)record {
    
    self.bmiRecordLabel.text = [NSString stringWithFormat:@"BMI: %.1f",[record.bmiRecord floatValue]];
    self.bmrRecordLabel.text = [NSString stringWithFormat:@"BMR: %.f cals/day",[record.bmrRecord floatValue]];
    self.timeStampLabel.text = [HistoryTableViewCell createTimestamp:record.timeStamp];
    self.bodyStatusLabel.text = [NSString stringWithFormat:@"Status: %@",record.bodyStatus];
    
}

@end
