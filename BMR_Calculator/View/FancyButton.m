//
//  FancyButton.m
//  BMIBMRCalculator
//
//  Created by 趙子超 on 11/01/2018.
//  Copyright © 2018 chao. All rights reserved.
//

#import "FancyButton.h"

@implementation FancyButton

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.shadowColor = [UIColor colorWithRed:3.0/255.0 green:169.0/255.0 blue:190.0/255.0 alpha:0.6].CGColor;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.0;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.frame.size.height / 2;
}

@end
