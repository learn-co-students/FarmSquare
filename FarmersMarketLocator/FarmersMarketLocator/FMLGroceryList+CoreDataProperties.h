//
//  FMLGroceryList+CoreDataProperties.h
//  FarmersMarketLocator
//
//  Created by Slobodan Kovrlija on 4/18/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FMLGroceryList.h"
#import "FMLGroceryItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMLGroceryList (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *listName;
@property (nullable, nonatomic, retain) NSDate *dateModified;
@property (nullable, nonatomic, retain) NSNumber *numberOfItems;
@property (nullable, nonatomic, retain) NSNumber *totalCost;
@property (nullable, nonatomic, retain) NSOrderedSet<FMLGroceryItem *> *itemsInList;

@end

@interface FMLGroceryList (CoreDataGeneratedAccessors)

- (void)insertObject:(FMLGroceryItem *)value inItemsInListAtIndex:(NSUInteger)idx;
- (void)removeObjectFromItemsInListAtIndex:(NSUInteger)idx;
- (void)insertItemsInList:(NSArray<FMLGroceryItem *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeItemsInListAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInItemsInListAtIndex:(NSUInteger)idx withObject:(FMLGroceryItem *)value;
- (void)replaceItemsInListAtIndexes:(NSIndexSet *)indexes withItemsInList:(NSArray<FMLGroceryItem *> *)values;
- (void)addItemsInListObject:(FMLGroceryItem *)value;
- (void)removeItemsInListObject:(FMLGroceryItem *)value;
- (void)addItemsInList:(NSOrderedSet<FMLGroceryItem *> *)values;
- (void)removeItemsInList:(NSOrderedSet<FMLGroceryItem *> *)values;

@end

NS_ASSUME_NONNULL_END
