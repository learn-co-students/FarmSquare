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

@property (strong, nonatomic)NSString *zipCode;

// API methods
+(void)getMarketsForZip:(NSString *)zip
         withCompletion:(void (^)(NSMutableArray *marketsArray, NSError *error))zipCompletion;
+(void)getMarketsForLatitude:(CGFloat)latitude
                   longitude:(CGFloat)longitude
              withCompletion:(void (^)(NSMutableArray *marketsArray, NSError *error))coordinatesCompletion;
+(void)getDetailsForMarketWithId:(NSString *)idNumber
                  withCompletion:(void (^)(NSDictionary *marketDetails, NSError *error))idCompletion;
+(void)marketsArrayForListOfMarkets:(NSDictionary *)marketsDict
                     withCompletion:(void (^)(NSMutableArray *marketsArray, NSError *error))listMarketsCompletion;

// Non-internet helper methods
+(NSDictionary *)getCoordinatesFromGoogleMapsLink:(NSString *)googleMapsLink;

//+(NSArray *)searchProducts:(NSArray *)usersProducts inMarkets:(NSArray *)marketsToSearch;


@end
