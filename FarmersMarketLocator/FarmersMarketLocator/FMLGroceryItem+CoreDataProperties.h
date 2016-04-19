//
//  FMLGroceryItem+CoreDataProperties.h
//  FarmersMarketLocator
//
//  Created by Slobodan Kovrlija on 4/18/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FMLGroceryItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMLGroceryItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isChecked;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *quantity;

@end

NS_ASSUME_NONNULL_END
