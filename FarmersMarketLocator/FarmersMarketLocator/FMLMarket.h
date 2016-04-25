//
//  FMLMarket.h
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/1/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMLMarket : NSManagedObject

-(NSString *)nameFromString:(NSString *)name;

@end

NS_ASSUME_NONNULL_END

#import "FMLMarket+CoreDataProperties.h"
