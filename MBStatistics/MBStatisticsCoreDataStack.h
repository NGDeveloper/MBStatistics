//
//  MBStatisticsCoreDataStack.h
//  MBStatistics
//
//  Created by Nikolay Galkin on 31.10.16.
//  Copyright © 2016 MyBook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MBStatisticsCoreDataStack : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (void)saveContext;

@end
