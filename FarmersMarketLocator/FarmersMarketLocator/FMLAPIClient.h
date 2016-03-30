//
//  FMLAPIClient.h
//  FarmersMarketLocator
//
//  Created by Slobodan Kovrlija on 3/29/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface FMLAPIClient : NSObject


+(void)getMarketsForZip:(NSString *)zip;
+(void)getMarketsForLatitude:(CGFloat)latitude
                   longitude:(CGFloat)longitude;
+(void)getDetailsForMarketWithId:(NSUInteger)idNumber;


@end
