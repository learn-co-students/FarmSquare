//
//  FMLAPIClient.m
//  FarmersMarketLocator
//
//  Created by Slobodan Kovrlija on 3/29/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import "FMLAPIClient.h"

@implementation FMLAPIClient

+(void)getMarketsForZip:(NSString *)zip {
    
    //http://search.ams.usda.gov/farmersmarkets/v1/data.svc/zipSearch?zip=" + zip
    
    NSString *baseZipURLString = @"http://search.ams.usda.gov/farmersmarkets/v1/data.svc/zipSearch?zip=";
    
    zip = @"10004"; //delete later when zip is fed in method call
    
    NSString *finalURLZip = [NSString stringWithFormat:@"%@%@", baseZipURLString, zip];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    [sessionManager GET:finalURLZip parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"response object: %@", responseObject);
        
        //deserializing our JSON data
        [self deserializingJSON:sessionManager withResponseObject:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error: %@", error);
    }];
}

+(void)getMarketsForLatitude:(CGFloat)latitude longitude:(CGFloat)longitude {
    
    //http://search.ams.usda.gov/farmersmarkets/v1/data.svc/locSearch?lat=" + lat + "&lng=" + lng
    //http://search.ams.usda.gov/farmersmarkets/v1/svcdesc.html
    
    NSString *baseCoordinatesURLString = @"http://search.ams.usda.gov/farmersmarkets/v1/data.svc/locSearch?lat=";
    
    NSString *finalCoordinatesURLString = [NSString stringWithFormat:@"%@%f&lng=%f", baseCoordinatesURLString, latitude, longitude];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager GET:finalCoordinatesURLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"response object: %@", responseObject);
        
        //deserializing our JSON data
        [self deserializingJSON:sessionManager withResponseObject:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error: %@", error);
        
    }];
    
}

+(void)getDetailsForMarketWithId:(NSUInteger)idNumber {
    
    // http://search.ams.usda.gov/farmersmarkets/v1/data.svc/mktDetail?id=" + id
    NSString *baseDetailsURLString = @"http://search.ams.usda.gov/farmersmarkets/v1/data.svc/mktDetail?id=";
    idNumber = 1000066;
    NSString *finalDetailURLString = [NSString stringWithFormat:@"%@%lu", baseDetailsURLString, idNumber];
    
    AFHTTPSessionManager *sessionManagerDetails = [AFHTTPSessionManager manager];
    [sessionManagerDetails GET:finalDetailURLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"response object: %@", responseObject);
        
        //deserialize JSON
        sessionManagerDetails.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        NSDictionary *marketdetails = responseObject[@"marketdetails"];
        NSLog(@"marketdetails:\nAddress: %@\nGoogleMapsLink: %@\nProducts available:%@\nSchedule Hours: %@", marketdetails[@"Address"], marketdetails[@"GoogleLink"], marketdetails[@"Products"], marketdetails[@"Schedule"]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error: %@", error);
    }];
}

+(void)deserializingJSON:(AFHTTPSessionManager *)sessionManager withResponseObject:(NSDictionary *)responseObject {
    
    //deserializing our JSON data
    //sessionManager.responseSerializer = [[AFJSONResponseSerializer alloc]init]; we dont need it
    NSDictionary *results = responseObject;
    NSArray *markets = results[@"results"];
    for (NSDictionary *market in markets) {
        NSLog(@"id of market %@ is %@", market[@"marketname"], market[@"id"]);
    }
}


@end
