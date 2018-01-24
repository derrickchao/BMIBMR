//
//  BMIStatusCell.m
//  BMIBMRCalculator
//
//  Created by 趙子超 on 20/01/2018.
//  Copyright © 2018 chao. All rights reserved.
//

#import "BMIStatusCell.h"
#import "Constants.h"

@implementation BMIStatusCell

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)configureCell:(NSIndexPath *)indexPath
           bodyResult:(BodyResult *)result {
    
    self.statusLabel.text = [BMI_STATUS_LOCALIZABLE_ARRAY objectAtIndex:indexPath.row];
    self.statusRangeLabel.text = [BMI_RANGE_ARRAY objectAtIndex:indexPath.row];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
            self.colorView.backgroundColor = [UIColor colorWithRed:1.0/255.0 green:87.0/255.0 blue:155.0/255.0 alpha:1.0];
            break;
        case 1:
            self.colorView.backgroundColor = [UIColor colorWithRed:3.0/255.0 green:155.0/255.0 blue:229.0/255.0 alpha:1.0];
            break;
        case 2:
            self.colorView.backgroundColor = [UIColor colorWithRed:79.0/255.0 green:195.0/255.0 blue:247.0/255.0 alpha:1.0];
            break;
        case 3:
            self.colorView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:230.0/255.0 blue:118.0/255.0 alpha:1.0];
            break;
        case 4:
            self.colorView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:167.0/255.0 blue:38.0/255.0 alpha:1.0];
            break;
        case 5:
            self.colorView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:124.0/255.0 blue:0.0/255.0 alpha:1.0];
            break;
        case 6:
            self.colorView.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:67.0/255.0 blue:54.0/255.0 alpha:1.0];
            break;
        case 7:
            self.colorView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:10.0/255.0 blue:10.0/255.0 alpha:1.0];
            break;
        default:
            break;
    }
    
    if (result) {
        int index = 0;
        for (NSString *status in BMI_STATUS_ARRAY) {
            if ([result.bodyStatus isEqualToString:status]) {
                break;
            }
            index++;
        }
        if (indexPath.row == index) {
            self.backgroundColor = [UIColor lightGrayColor];
        }
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
