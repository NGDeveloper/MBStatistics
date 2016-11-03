//
//  MBStatisticsCoreDataStack.m
//  MBStatistics
//
//  Created by Nikolay Galkin on 31.10.16.
//  Copyright © 2016 MyBook. All rights reserved.
//

#import "MBStatisticsCoreDataStack.h"

static NSString *const kMBStatisticsModelName = @"MBStatisticsModel";

@interface MBStatisticsCoreDataStack ()

@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@end

@implementation MBStatisticsCoreDataStack

#pragma mark - Self Methods
#pragma mark Public

- (void)saveContext {
    if (self.managedObjectContext.hasChanges) {
        NSError *error = nil;
        [self.managedObjectContext save:&error];
        if (error) {
            NSLog(@"Error saving context: %@", error);
        }
    }
}

#pragma mark Private

- (NSURL *)applicationDocumentsDirectory {
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return urls.lastObject;
}

#pragma mark - Accessors

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSURL *url = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:kMBStatisticsModelName];
        NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @(YES) };
        NSError *error = nil;
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:url
                                                        options:options
                                                          error:&error];
        if (error) {
            NSLog(@"Error adding persistent store: %@", error);
        }
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kMBStatisticsModelName withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

@end
