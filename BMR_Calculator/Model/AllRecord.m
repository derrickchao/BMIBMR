//
//  AllRecord.m
//  BMR_Calculator
//
//  Created by 趙子超 on 6/11/16.
//  Copyright © 2016 chao. All rights reserved.
//

#import "AllRecord.h"

@implementation AllRecord

// Insert code here to add functionality to your managed object subclass

- (void)awakeFromInsert {
    [super awakeFromInsert];
    
    self.timeStamp = [NSDate date];
}

@end
