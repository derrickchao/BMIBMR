//
//  CoreDataManager.h
//  BMIBMRCalculator
//
//  Created by 趙子超 on 07/01/2018.
//  Copyright © 2018 chao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AllRecord.h"

typedef NS_ENUM(NSUInteger, ResultChangeType) {
    Insert = 1,
    Delete = 2,
    Move = 3,
    Update = 4
};

@protocol CoreDataManagerDelegate <NSObject>

@optional
- (void)willChangedContent;
- (void)didChangedContent;
- (void)didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(ResultChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
- (void)didChangeSectionAtIndex:(NSUInteger)index forChangeType:(ResultChangeType)type;


@end

@interface CoreDataManager : NSObject

@property (nonatomic, readonly) NSFetchedResultsController *fetchResultController;
@property (nonatomic, weak) id<CoreDataManagerDelegate> delegate;

+ (instancetype)shareInstance;
- (BOOL)createNewRecordWithBMI:(NSString *)bmi bmr:(NSString *)bmr timeStamp:(NSDate *)timestamp;
- (BOOL)deleteRecord:(AllRecord *)record;
- (NSUInteger)totalRecords;
- (AllRecord *)getRecordByIndex:(NSUInteger)index;

@end
