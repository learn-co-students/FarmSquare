//
//  FMLMarket+CoreDataProperties.h
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/8/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FMLMarket.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMLMarket (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *googleMapLink;
@property (nullable, nonatomic, retain) NSString *latitude;
@property (nullable, nonatomic, retain) NSString *longitude;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *produceList;
@property (nullable, nonatomic, retain) NSString *scheduleString;
@property (nullable, nonatomic, retain) NSNumber *snap;
@property (nullable, nonatomic, retain) NSNumber *wic;
@property (nullable, nonatomic, retain) NSNumber *wicCash;
@property (nullable, nonatomic, retain) NSNumber *sfmnp;
@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSString *street;
@property (nullable, nonatomic, retain) NSString *zipCode;
@property (nullable, nonatomic, retain) NSString *state;
@property (nullable, nonatomic, retain) NSString *website;
@property (nullable, nonatomic, retain) NSString *facebook;
@property (nullable, nonatomic, retain) NSString *twitter;
@property (nullable, nonatomic, retain) NSNumber *credit;
@property (nullable, nonatomic, retain) NSNumber *organic;
@property (nullable, nonatomic, retain) NSString *season1Date;
@property (nullable, nonatomic, retain) NSString *season2Date;
@property (nullable, nonatomic, retain) NSString *season3Date;
@property (nullable, nonatomic, retain) NSString *season4Date;
@property (nullable, nonatomic, retain) NSString *season1Time;
@property (nullable, nonatomic, retain) NSString *season2Time;
@property (nullable, nonatomic, retain) NSString *season3Time;
@property (nullable, nonatomic, retain) NSString *season4Time;
@property (nullable, nonatomic, retain) NSString *updateTime;

@end

NS_ASSUME_NONNULL_END
