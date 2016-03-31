//
//  FMLMarket.h
//  FarmersMarketLocator
//
//  Created by Slobodan Kovrlija on 3/29/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FMLMarket : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *googleMapLink;
@property (strong, nonatomic) NSArray *productsArray;
@property (strong, nonatomic) NSString *scheduleString;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;

-(instancetype)initWithName:(NSString *)name;

@end


