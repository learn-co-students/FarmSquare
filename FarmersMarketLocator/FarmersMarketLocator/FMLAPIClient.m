//
//  FMLAPIClient.m
//  FarmersMarketLocator
//
//  Created by Slobodan Kovrlija on 3/29/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import "FMLAPIClient.h"
#import "FMLMarket.h"

@implementation FMLAPIClient

+(void)getMarketsForZip:(NSString *)zip withCompletion:(void (^)(NSMutableArray *marketsArray))zipCompletion {
    
    //http://search.ams.usda.gov/farmersmarkets/v1/data.svc/zipSearch?zip=" + zip
    
    NSString *zipURLString = [NSString stringWithFormat: @"http://search.ams.usda.gov/farmersmarkets/v1/data.svc/zipSearch?zip=%@", zip];
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    [sessionManager GET:zipURLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // Plug that response object into a method that gets details for all of those markets.
        [FMLAPIClient marketsArrayForListOfMarkets:responseObject withCompletion:^(NSMutableArray *marketsArray) {
            
            // Now we have an array of market objects. All we do with it is pass it to the completion block.
            zipCompletion(marketsArray);
            
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error: %@", error);
    }];
}

+(void)getMarketsForLatitude:(CGFloat)latitude longitude:(CGFloat)longitude withCompletion:(void (^)(NSMutableArray *marketsArray))coordinatesCompletion {
    
    //http://search.ams.usda.gov/farmersmarkets/v1/data.svc/locSearch?lat=" + lat + "&lng=" + lng
    //http://search.ams.usda.gov/farmersmarkets/v1/svcdesc.html
    
    // Base URL string
    NSString *baseCoordinatesURLString = @"http://search.ams.usda.gov/farmersmarkets/v1/data.svc/locSearch?lat=";
    
    // Add the queries for latitude and longitude to the URL string
    NSString *finalCoordinatesURLString = [NSString stringWithFormat:@"%@%f&lng=%f", baseCoordinatesURLString, latitude, longitude];
    
    // Make the API call
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager GET:finalCoordinatesURLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"response object: %@", responseObject);
        
        // Plug that response object into a method that gets details for all of those markets.
        [FMLAPIClient marketsArrayForListOfMarkets:responseObject withCompletion:^(NSMutableArray *marketsArray) {
            
            // Now we have an array of market objects. All we do with it is pass it to the completion block.
            coordinatesCompletion(marketsArray);
            
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"\nerror: %@\n", error);
    }];
}

+(void)getDetailsForMarketWithId:(NSString *)idNumber withCompletion:(void (^)(NSDictionary *marketDetails))idCompletion {
    
    // API link:
    // http://search.ams.usda.gov/farmersmarkets/v1/data.svc/mktDetail?id=" + id
    
    // URL setup
    NSString *baseDetailsURLString = @"http://search.ams.usda.gov/farmersmarkets/v1/data.svc/mktDetail?id=";
    idNumber = idNumber;
    NSString *finalDetailURLString = [NSString stringWithFormat:@"%@%@", baseDetailsURLString, idNumber];
    
    // API call
    AFHTTPSessionManager *sessionManagerDetails = [AFHTTPSessionManager manager];
    [sessionManagerDetails GET:finalDetailURLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // Deserialize
        sessionManagerDetails.responseSerializer = [[AFJSONResponseSerializer alloc]init];
        // Get dictionary of market details
        NSDictionary *marketDetails = responseObject[@"marketdetails"];
        // Pass the dictionary to the completion block
        idCompletion(marketDetails);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"\nerror: %@\n", error);
    }];
}

// This method takes the API response containing a list of markets (each with a name and numerical ID), makes an array of FMLMarket objects, and hands this array to its completion block.
+(void)marketsArrayForListOfMarkets:(NSDictionary *)marketsDict withCompletion:(void (^)(NSMutableArray *marketsArray))listMarketsCompletion {
    
    // This is the array inside the dictionary we get from the first API call
    NSArray *marketDictionariesArray = marketsDict[@"results"];
    
    // Create an array to put the new market objects in
    NSMutableArray *marketObjectsArray = [NSMutableArray new];
    
    /* For each market in the list of nearby markets:
     1) Initialize a FMLMarket object
     2) Plug its ID into the getDetails... method to get back a dictionary of its details
     3) Use the dictionary to populate the properties of that FMLMarket object
     4) Add the FMLMarket object to an array
     4) Pass that array to the completion block.
     */
    
    for (NSDictionary *marketDict in marketDictionariesArray) {
        
        NSString *marketID = marketDict[@"id"];
        NSString *nameString = marketDict[@"marketname"];
        
        // Initialize market object.
        // (Note that the "marketname" from the API has the distance inside the string, but this is handled by the initializer. See comments on initializer for details.)
        FMLMarket *market = [[FMLMarket alloc] initWithName:nameString];
        
        // Now to give it its properties (other than name), call getDetails... to make the API call that gets the dictionary of details.
        [FMLAPIClient getDetailsForMarketWithId:marketID withCompletion:^(NSDictionary *marketDetails) {
            
            // Give it its properties, from the marketDetails dictionary.
            market.address = marketDetails[@"Address"];
            market.googleMapLink = marketDetails[@"GoogleLink"];
            //Converting products string into an array of products
            NSString *productsString = marketDetails[@"Products"];
            market.productsArray = [productsString componentsSeparatedByString:@"; "];
            market.scheduleString = marketDetails[@"Schedule"];
            // (Use the Google link to get the coordinates before setting them.)
            NSDictionary *marketCoordinates = [FMLAPIClient getCoordinatesFromGoogleMapsLink:market.googleMapLink];
            market.latitude = marketCoordinates[@"latitude"];
            market.longitude = marketCoordinates[@"longitude"];
            
            // Add the completed FMLMarket object to our mutable array.
            [marketObjectsArray addObject:market];
            
            // At the end of the last iteration, pass the mutable array to the completion block.
            if(marketObjectsArray.count == marketDictionariesArray.count) {
                // Pass the array of market objects to the completion block
                listMarketsCompletion(marketObjectsArray);
            }
        }];
    }
}

// Helper method, does what it says on the tin.
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

//    // Put the latitude and longitude in the dictionary (as NSNumbers)
//    coordinatesDictionary[@"latitude"] = @([latitude floatValue]);
//    coordinatesDictionary[@"longitude"] = @([longitude floatValue]);
    
    // Put the latitude and longitude in the dictionary (as strings)
    coordinatesDictionary[@"latitude"] = latitude;
    coordinatesDictionary[@"longitude"] = longitude;

    NSLog(@"Coordinates dictionary: \n%@", coordinatesDictionary);
    return coordinatesDictionary;
}

+(NSArray *)searchProducts:(NSArray *)usersProducts inMarkets:(NSArray *)marketsToSearch {
    
    NSMutableArray *marketsWithSearchedProducts = [[NSMutableArray alloc]init];
    
    for (FMLMarket *market in marketsToSearch) {
        for (NSUInteger i = 0; i < usersProducts.count; i++) {
            if ([market.productsArray containsObject: usersProducts[i]]) {
                [marketsWithSearchedProducts addObject:market];
                break;
            }
        }    }
    NSLog(@"\n\n SEARCH RESULTS:\n");
    for (FMLMarket *market in marketsWithSearchedProducts) {
        NSLog(@"The market named %@ at %@ has some stuff.", market.name, market.address);
    }
    
    return marketsWithSearchedProducts;
}

@end



