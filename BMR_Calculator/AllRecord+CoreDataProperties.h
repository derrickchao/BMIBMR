//
//  AllRecord+CoreDataProperties.h
//  BMR_Calculator
//
//  Created by 趙子超 on 6/11/16.
//  Copyright © 2016 chao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "AllRecord.h"

NS_ASSUME_NONNULL_BEGIN

@interface AllRecord (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *bmiRecord;
@property (nullable, nonatomic, retain) NSNumber *bmrRecord;
@property (nullable, nonatomic, retain) NSDate *timeStamp;

@end

NS_ASSUME_NONNULL_END
