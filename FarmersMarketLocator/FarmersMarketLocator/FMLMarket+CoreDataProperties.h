//
//  FMLMarket+CoreDataProperties.h
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/1/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FMLMarket.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMLMarket (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *googleMapLink;
@property (nullable, nonatomic, retain) NSString *scheduleString;
@property (nullable, nonatomic, retain) NSString *latitude;
@property (nullable, nonatomic, retain) NSString *longitude;
@property (nullable, nonatomic, retain) NSString *produceList;

@end

NS_ASSUME_NONNULL_END
