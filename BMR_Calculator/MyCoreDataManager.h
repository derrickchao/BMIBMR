//
//  MyCoreDataManager.h
//  BMR_Calculator
//
//  Created by 趙子超 on 6/11/16.
//  Copyright © 2016 chao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MyCoreDataManager : NSObject

- (instancetype) initWithMomd:(NSString *)momdName
                   dbFileName:(NSString *)dbName
                dbFilePathURL:(NSURL *)dbPathURL
                      sortKey:(NSString *)sortField
                   entityName:(NSString *)entity;

- (NSInteger) totalItems;
- (NSManagedObject *) createNewItem;
- (NSManagedObject *) getByIndex:(NSInteger) index;
- (void) deleteItem: (NSManagedObject *) targetItem;
- (void) save;

@end
