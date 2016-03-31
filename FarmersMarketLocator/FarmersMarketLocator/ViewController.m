//
//  ViewController.m
//  FarmersMarketLocator
//
//  Created by Jeff Spingeld on 3/29/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import "ViewController.h"
#import "FMLAPIClient.h"
#import "FMLMarket.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    // Testing out our API calls with sample locations.
//    [FMLAPIClient getMarketsForZip:@"10004"];
    [FMLAPIClient getMarketsForZip:@"10004" withCompletion:^(NSMutableArray *marketsArray) {
        //whatever logic you want 
    }];
    
    [FMLAPIClient getMarketsForLatitude:40.7 longitude:-74 withCompletion:^(NSMutableArray *marketsArray) {
        for (FMLMarket *market in marketsArray) {
            NSLog(@"We have a market named %@\nand it's hours are: %@\nand available products are: %@", market.name, market.scheduleString, market.productsArray);
            
            // search
            [FMLAPIClient searchProducts:@[@"Honey"] inMarkets:marketsArray];
        }
    }];
   // [FMLAPIClient getCoordinatesFromGoogleMapsLink:@"asdad"];
    
}

@end
