//
//  CoreDataManager.m
//  BMIBMRCalculator
//
//  Created by 趙子超 on 07/01/2018.
//  Copyright © 2018 chao. All rights reserved.
//

#import "CoreDataManager.h"
#import "Constants.h"
#import <UIKit/UIKit.h>

@interface CoreDataManager() <NSFetchedResultsControllerDelegate> {
    AllRecord *newRecord;
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic ,readwrite) NSFetchedResultsController *fetchResultController;

@end

@implementation CoreDataManager

+ (instancetype)shareInstance {
    
    static CoreDataManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

#pragma mark - Public Methods

- (BOOL)createNewRecord:(BodyResult *)bodyResult {
    
    newRecord = [NSEntityDescription insertNewObjectForEntityForName:DEFAULT_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
    
    newRecord.age = @(bodyResult.age);
    newRecord.gender = bodyResult.gender;
    newRecord.heightInCm = @(bodyResult.heightInCm);
    newRecord.weightInKg = @(bodyResult.weightInKg);
    newRecord.heightInFeet = @(bodyResult.heightInFeet);
    newRecord.heightInInch = @(bodyResult.heightInInch);
    newRecord.weightInLb = @(bodyResult.weightInLb);
    newRecord.bmiRecord = @(bodyResult.bmiValue);
    newRecord.bmrRecord = @(bodyResult.bmrValue);
    newRecord.bodyStatus = bodyResult.bodyStatus;
    newRecord.suggestUpperWeight = @(bodyResult.suggestUpperWeight);
    newRecord.suggestLowerWeight = @(bodyResult.suggestLowerWeight);
    
    return [self save];
}

- (void)updateRecord:(AllRecord *)record
              values:(NSDictionary *)values {
    
    for (NSString *key in values) {
        [record setValue:[values objectForKey:key] forKey:key];
    }
    
    [self.managedObjectContext refreshObject:record mergeChanges:true];
}

- (BOOL)deleteRecord:(AllRecord *)record {
    
    [self.managedObjectContext deleteObject:record];
    
    return [self save];
}

- (NSUInteger)totalRecords {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchResultController sections][0];
    
    return [sectionInfo numberOfObjects];
}

- (AllRecord *)getRecordByIndex:(NSUInteger)index {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    return [self.fetchResultController objectAtIndexPath:indexPath];
}

#pragma mark - Property

- (NSFetchedResultsController *)fetchResultController {
    
    if (_fetchResultController == nil) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:DEFAULT_ENTITY_NAME];
        NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"timeStamp" ascending:NO];
        [fetchRequest setSortDescriptors:@[timeSort]];
        
        _fetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _fetchResultController.delegate = self;
        
        NSError *error = nil;
        if (![_fetchResultController performFetch:&error]) {
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return _fetchResultController;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(CoreDataManagerDelegate)] && [self.delegate respondsToSelector:@selector(willChangedContent)]) {
        [self.delegate willChangedContent];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(CoreDataManagerDelegate)] && [self.delegate respondsToSelector:@selector(didChangeObject:atIndexPath:forChangeType:newIndexPath:)]) {
        
        ResultChangeType resultType;
        switch (type) {
            case NSFetchedResultsChangeInsert:
                resultType = Insert;
                break;
            case NSFetchedResultsChangeDelete:
                resultType = Delete;
                break;
            case NSFetchedResultsChangeMove:
                resultType = Move;
                break;
            case NSFetchedResultsChangeUpdate:
                resultType = Update;
                break;
            default:
                break;
        }
        
        [self.delegate didChangeObject:anObject atIndexPath:indexPath forChangeType:resultType newIndexPath:newIndexPath];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(CoreDataManagerDelegate)] && [self.delegate respondsToSelector:@selector(didChangeSectionAtIndex:forChangeType:)]) {
        
        ResultChangeType resultType;
        switch (type) {
            case NSFetchedResultsChangeInsert:
                resultType = Insert;
                break;
            case NSFetchedResultsChangeDelete:
                resultType = Delete;
                break;
            case NSFetchedResultsChangeMove:
                resultType = Move;
                break;
            case NSFetchedResultsChangeUpdate:
                resultType = Update;
                break;
            default:
                break;
        }
        
        [self.delegate didChangeSectionAtIndex:sectionIndex forChangeType:resultType];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(CoreDataManagerDelegate)] && [self.delegate respondsToSelector:@selector(didChangedContent)]) {
        [self.delegate didChangedContent];
    }
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.chao.HelloCoreData" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:OBJECT_MODEL_NAME withExtension:nil];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:DB_FILE_NAME];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    // Add Lightweight Migration options
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
        if (_managedObjectContext != nil) {
            return _managedObjectContext;
        }
    
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (!coordinator) {
            return nil;
        }
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (BOOL)save {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
            return false;
        } else {
            return true;
        }
    } else {
        return false;
    }
}

@end
