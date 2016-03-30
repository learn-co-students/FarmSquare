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


// API stuff
+(void)getMarketsForZip:(NSString *)zip;
+(void)getMarketsForLatitude:(CGFloat)latitude
                   longitude:(CGFloat)longitude
              withCompletion:(void (^)(NSMutableArray *marketsArray))completion;
+(void)getDetailsForMarketWithId:(NSString *)idNumber withCompletion:(void (^)(NSDictionary *marketDetails))completion;
+(void)marketsArrayForListOfMarkets:(NSDictionary *)marketsDict withCompletion:(void (^)(NSMutableArray *marketsArray))completion;

// Non-internet helper methods
+(NSDictionary *)getCoordinatesFromGoogleMapsLink:(NSString *)googleMapsLink;


@end
