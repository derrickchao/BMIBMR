//
//  BMIStatusCell.h
//  BMIBMRCalculator
//
//  Created by 趙子超 on 20/01/2018.
//  Copyright © 2018 chao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BodyResult.h"

@interface BMIStatusCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusRangeLabel;

- (void)configureCell:(NSIndexPath *)indexPath bodyResult:(BodyResult *)result;

@end
