//
//  FMLAPIClient.m
//  FarmersMarketLocator
//
//  Created by Slobodan Kovrlija on 3/29/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import "FMLAPIClient.h"
#import "FMLMarket.h"
#import "CoreDataStack.h"
#import "FMLMarket+CoreDataProperties.h"
#import "FMLJSONDictionary.h"

@implementation FMLAPIClient

+(void)getMarketsForZip:(NSString *)zip withCompletion:(void (^)(NSMutableArray *marketsArray, NSError *error))zipCompletion {
    
    //http://search.ams.usda.gov/farmersmarkets/v1/data.svc/zipSearch?zip=" + zip
    
    NSString *zipURLString = [NSString stringWithFormat: @"http://search.ams.usda.gov/farmersmarkets/v1/data.svc/zipSearch?zip=%@", zip];
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    [sessionManager GET:zipURLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // Plug that response object into a method that gets details for all of those markets.
        [FMLAPIClient marketsArrayForListOfMarkets:responseObject withCompletion:^(NSMutableArray *marketsArray, NSError *error) {
            
            // Now we have an array of market objects. All we do with it is pass it to the completion block.
            zipCompletion(marketsArray, nil);
            
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // Pass the error up to the view controller
        zipCompletion(nil, error);
        NSLog(@"\nError in getMarketsForZip: %@\n", error);
        
    }];
}

+(void)getMarketsForLatitude:(CGFloat)latitude longitude:(CGFloat)longitude withCompletion:(void (^)(NSMutableArray *marketsArray, NSError *error))coordinatesCompletion {
    
    //http://search.ams.usda.gov/farmersmarkets/v1/data.svc/locSearch?lat=" + lat + "&lng=" + lng
    //http://search.ams.usda.gov/farmersmarkets/v1/svcdesc.html
    
    // Base URL string
    NSString *baseCoordinatesURLString = @"http://search.ams.usda.gov/farmersmarkets/v1/data.svc/locSearch?lat=";
    
    if (latitude != 0 && longitude != 0) {
        // Add the queries for latitude and longitude to the URL string
        NSString *finalCoordinatesURLString = [NSString stringWithFormat:@"%@%f&lng=%f", baseCoordinatesURLString, latitude, longitude];
        
        // Make the API call
        AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
        [sessionManager GET:finalCoordinatesURLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            // Plug that response object into a method that gets details for all of those markets.
            [FMLAPIClient marketsArrayForListOfMarkets:responseObject withCompletion:^(NSMutableArray *marketsArray, NSError *error) {
                
                // Now we have an array of market objects. All we do with it is pass it to the completion block.
                coordinatesCompletion(marketsArray, nil);
                
            }];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            // Pass the error up to the view controller
            coordinatesCompletion(nil, error);
            NSLog(@"\nerror: %@\n", error);
            
        }];
    } else {
        
        //Notification for alert sent to FMLMapViewController
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Location irretrievable" object:nil];
    }
    
}

+(void)getDetailsForMarketWithId:(NSString *)idNumber withCompletion:(void (^)(NSDictionary *marketDetails, NSError *error))idCompletion {
    
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
        idCompletion(marketDetails, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        idCompletion(nil, error);
        NSLog(@"\nError in getDetailsForMarketWithId:%@ %@\n", idNumber, error);
        
    }];
}

// This method takes the API response containing a list of markets (each with a name and numerical ID), makes an array of FMLMarket objects, and hands this array to its completion block.
+(void)marketsArrayForListOfMarkets:(NSDictionary *)marketsDict withCompletion:(void (^)(NSMutableArray *marketsArray, NSError *error))listMarketsCompletion {
    
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
//        FMLMarket *marketsss = [[FMLMarket alloc] initWithName:nameString];
        
        NSManagedObjectContext *context = [[CoreDataStack sharedStack] managedObjectContext];
        
        FMLMarket *market = (FMLMarket *)[NSEntityDescription insertNewObjectForEntityForName:@"FMLMarket" inManagedObjectContext:context];
        
        market.name = [market nameFromString:nameString];
        
        // Get data from JSON Dump file
        NSDictionary *data = [FMLJSONDictionary dictionaryForMarketWithId:marketID];
        market.season1Date = data[@"Season1Date"];
        market.season2Date = data[@"Season2Date"];
        market.season3Date = data[@"Season3Date"];
        market.season4Date = data[@"Season4Date"];
        market.season1Time = data[@"Season1Time"];
        market.season2Time = data[@"Season2Time"];
        market.season3Time = data[@"Season3Time"];
        market.season4Time = data[@"Season4Time"];
        NSString *isOrganic = data[@"Organic"];
        if ([isOrganic isEqualToString:@"-"]) {
            market.organic = @(0);
        } else {
            market.organic = [isOrganic isEqualToString:@"Y"] ? @1 : @-1;
        }
        market.snap = data[@"Snap"];
        market.wic = [data[@"WIC"] isEqualToString:@"Y"] ? @1 : @0;
        market.wicCash = [data[@"WICcash"] isEqualToString:@"Y"] ? @1 : @0;
        market.sfmnp = [data[@"SFMNP"] isEqualToString:@"Y"] ? @1 : @0;
        market.credit = [data[@"Credit"] isEqualToString:@"Y"] ? @1 : @0;
        market.website = data[@"Website"];
        market.facebook = data[@"Facebook"];
        market.twitter = data[@"Twitter"];
        market.city = data[@"city"];
        market.state = data[@"State"];
        market.street = data[@"street"];
        market.zipCode = data[@"zip"];
        market.updateTime = data[@"updateTime"];

        
        // Now to give it its properties (other than name), call getDetails... to make the API call that gets the dictionary of details.
        [FMLAPIClient getDetailsForMarketWithId:marketID withCompletion:^(NSDictionary *marketDetails, NSError *error) {
            
            // If API call in getDetails is successful:
            if (marketDetails) {
                
                // Give FMLMarket object its properties, from the marketDetails dictionary.

                market.address = marketDetails[@"Address"];
                market.googleMapLink = marketDetails[@"GoogleLink"];
                //Converting products string into an array of products
                NSString *productsString = marketDetails[@"Products"];
                market.produceList = productsString;
                
                //erasing the <br><br><br> at the end of schedule strings
                NSString *cleanScheduleString = [marketDetails[@"Schedule"] stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
                market.scheduleString = cleanScheduleString;
                
                // (Use the Google link to get the coordinates before setting them.)
                NSDictionary *marketCoordinates = [FMLAPIClient getCoordinatesFromGoogleMapsLink:market.googleMapLink];
                market.latitude = marketCoordinates[@"latitude"];
                market.longitude = marketCoordinates[@"longitude"];
                
                // Add the completed FMLMarket object to our mutable array.
                [marketObjectsArray addObject:market];
                
                // At the end of the last iteration, pass the mutable array to the completion block.
                if(marketObjectsArray.count == marketDictionariesArray.count) {
                    // Pass the array of market objects to the completion block
                    listMarketsCompletion(marketObjectsArray, nil);
                }
                
                if (![[NSUserDefaults standardUserDefaults] boolForKey:@"CoreDataTurnedOff"]) {
                    [[CoreDataStack sharedStack] saveContext];
                }
                
            } else {
                
                // If API call is unsuccessful
                NSLog(@"The API call in getDetailsForMarketWithId: failed on the market with ID %@, named %@.", marketID, nameString);
                listMarketsCompletion(nil, error);
                
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
    // 3) Put in an if-statement so we don't crash if we can't figure out the coordinates because the URL isn't formatted as expected (or for any other reason).

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
    
    // Get the latitude (from 0 to the comma).
    NSRange rangeOfComma = [coordinatesAndName rangeOfString:@","];
    NSRange rangeOfLatitude = NSMakeRange(0, rangeOfComma.location);
    NSString *latitude = [coordinatesAndName substringWithRange:rangeOfLatitude];

    
    // Get the longitude (bounded by spaces)
    NSArray *junkArray = [coordinatesAndName componentsSeparatedByString:@" "];
    NSString *longitude = junkArray[1];

//    // Put the latitude and longitude in the dictionary (as NSNumbers)
//    coordinatesDictionary[@"latitude"] = @([latitude floatValue]);
//    coordinatesDictionary[@"longitude"] = @([longitude floatValue]);
    
    // Put the latitude and longitude in the dictionary (as strings)
    coordinatesDictionary[@"latitude"] = latitude;
    coordinatesDictionary[@"longitude"] = longitude;


    return coordinatesDictionary;
}

//+(NSArray *)searchProducts:(NSArray *)usersProducts inMarkets:(NSArray *)marketsToSearch {
//    
//    NSMutableArray *marketsWithSearchedProducts = [[NSMutableArray alloc]init];
//    
//    for (FMLMarket *market in marketsToSearch) {
//        for (NSUInteger i = 0; i < usersProducts.count; i++) {
//            if ([market.productsArray containsObject: usersProducts[i]]) {
//                [marketsWithSearchedProducts addObject:market];
//                break;
//            }
//        }
//    }
//
//    return marketsWithSearchedProducts;
//}

@end



