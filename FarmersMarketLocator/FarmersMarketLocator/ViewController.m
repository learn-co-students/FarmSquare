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
//    [FMLAPIClient getMarketsForLatitude:40.7 longitude:-74];
//    [FMLAPIClient getDetailsForMarketWithId:1000066];
    [FMLAPIClient getCoordinatesFromGoogleMapsLink:@"asdad"];

}


@end
