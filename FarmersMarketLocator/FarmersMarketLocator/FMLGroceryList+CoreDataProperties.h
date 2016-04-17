//
//  FMLGroceryList+CoreDataProperties.h
//  FarmersMarketLocator
//
//  Created by Slobodan Kovrlija on 4/17/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FMLGroceryList.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMLGroceryList (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *listName;
@property (nullable, nonatomic, retain) NSDate *dateModified;
@property (nullable, nonatomic, retain) NSNumber *numberOfItems;
@property (nullable, nonatomic, retain) NSNumber *totalCost;

@end

NS_ASSUME_NONNULL_END
