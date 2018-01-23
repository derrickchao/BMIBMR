//
//  HistoryTableViewCell.m
//  BMR_Calculator
//
//  Created by 趙子超 on 6/11/16.
//  Copyright © 2016 chao. All rights reserved.
//

#import "HistoryTableViewCell.h"
#import "BodyResult.h"
#import "Constants.h"
#import "CoreDataManager.h"

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
    
    // For Data Model v1 users.
    if (record.bodyStatus == nil) {
        NSString *newBodyStatus = [BodyResult getBodyStatus:[record.bmiRecord floatValue]];
        [[CoreDataManager shareInstance] updateRecord:record values:@{COLUMN_NAME_BODY_STATUS: newBodyStatus}];
    }
    
    self.bodyStatusLabel.text = record.bodyStatus;
    
    // Set Status Label Color
    if ([record.bodyStatus isEqualToString:[BMI_STATUS_ARRAY objectAtIndex:0]]) {
        self.bodyStatusLabel.textColor = [UIColor colorWithRed:1.0/255.0 green:87.0/255.0 blue:155.0/255.0 alpha:1.0];
    } else if ([record.bodyStatus isEqualToString:[BMI_STATUS_ARRAY objectAtIndex:1]]) {
        self.bodyStatusLabel.textColor = [UIColor colorWithRed:3.0/255.0 green:155.0/255.0 blue:229.0/255.0 alpha:1.0];
    } else if ([record.bodyStatus isEqualToString:[BMI_STATUS_ARRAY objectAtIndex:2]]) {
        self.bodyStatusLabel.textColor = [UIColor colorWithRed:79.0/255.0 green:195.0/255.0 blue:247.0/255.0 alpha:1.0];
    } else if ([record.bodyStatus isEqualToString:[BMI_STATUS_ARRAY objectAtIndex:3]]) {
        self.bodyStatusLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:230.0/255.0 blue:118.0/255.0 alpha:1.0];
    } else if ([record.bodyStatus isEqualToString:[BMI_STATUS_ARRAY objectAtIndex:4]]) {
        self.bodyStatusLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:167.0/255.0 blue:38.0/255.0 alpha:1.0];
    } else if ([record.bodyStatus isEqualToString:[BMI_STATUS_ARRAY objectAtIndex:5]]) {
        self.bodyStatusLabel.textColor = [UIColor colorWithRed:245.0/255.0 green:124.0/255.0 blue:0.0/255.0 alpha:1.0];
    } else if ([record.bodyStatus isEqualToString:[BMI_STATUS_ARRAY objectAtIndex:6]]) {
        self.bodyStatusLabel.textColor = [UIColor colorWithRed:244.0/255.0 green:67.0/255.0 blue:54.0/255.0 alpha:1.0];
    } else if ([record.bodyStatus isEqualToString:[BMI_STATUS_ARRAY objectAtIndex:7]]) {
        self.bodyStatusLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:10.0/255.0 blue:10.0/255.0 alpha:1.0];
    }
}

@end
