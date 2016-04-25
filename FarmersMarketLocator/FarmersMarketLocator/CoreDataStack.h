//
//  CoreDataStack.h
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/1/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMLGroceryItem.h"
#import "FMLGroceryList.h"


@interface CoreDataStack : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSMutableArray *groceryItems;
@property (strong, nonatomic) NSMutableArray *groceryLists;

+ (instancetype)sharedStack;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
