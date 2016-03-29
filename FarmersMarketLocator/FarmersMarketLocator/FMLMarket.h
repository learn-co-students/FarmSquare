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
@property (strong, nonatomic) NSString *productsString;
@property (strong, nonatomic) NSString *scheduleString;
@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;

-(instancetype)initWithNameString:(NSString *)name googleLink:(NSString *)googleLink;

@end


