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

+(NSDictionary *)getCoordinatesFromGoogleMapsLink:(NSString *)googleMapsLink {
    
//    // Uncomment this to test the method
//    googleMapsLink = @"http://maps.google.com/?q=40.704587%2C%20-74.014313%20(%22Bowling+Green+Greenmarket%22)";
    
    
    // Google maps link example:
    // http://maps.google.com/?q=40.704587%2C%20-74.014313%20(%22Bowling+Green+Greenmarket%22)
    // We want to:
    // 1) Get the number between: "?q=" and "%", and the number between "%20" and "(".
    // 2) Turn each number into a CGFloat and put them in the dictionary as latitude and longitude.
    // 3) Test this with a bunch of URLs to make sure the link is always formatted the same. Even if it is, put in an if-statement so we don't crash if we can't figure out the coordinates.

    // Create a mutable dictionary to hold the coordinates
    NSMutableDictionary *coordinatesDictionary = [NSMutableDictionary new];
    
    // Create an NSURLComponents object for the URL
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:googleMapsLink];
    // Get the queries from the URL. The first and only query's value is a string containing the location's coordinates and name.
    NSArray *queryItems = urlComponents.queryItems;
    NSURLQueryItem *query = queryItems[0];
    NSString *coordinatesAndName = query.value;
    
    // Now we have a string of the form "LAT, LONG (name)".
    // Example: "40.704587, -74.014313 (\"Bowling+Green+Greenmarket\")"
    
    // Get the latitude (from 0 to the comma)
    NSRange rangeOfComma = [coordinatesAndName rangeOfString:@","];
    NSRange rangeOfLatitude = NSMakeRange(0, rangeOfComma.location);
    NSString *latitude = [coordinatesAndName substringWithRange:rangeOfLatitude];
    NSLog(@"latitude: %@", latitude);
    
    // Get the longitude (bounded by spaces)
    NSArray *junkArray = [coordinatesAndName componentsSeparatedByString:@" "];
    NSString *longitude = junkArray[1];

    // Put the latitude and longitude in the dictionary (as NSNumbers)
    coordinatesDictionary[@"latitude"] = @([latitude floatValue]);
    coordinatesDictionary[@"longitude"] = @([longitude floatValue]);

    NSLog(@"Coordinates dictionary: \n%@", coordinatesDictionary);
    return coordinatesDictionary;
    
}


@end
