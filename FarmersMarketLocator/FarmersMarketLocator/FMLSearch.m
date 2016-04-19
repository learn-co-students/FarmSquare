//
//  FMLSearch.m
//  FarmersMarketLocator
//
//  Created by Julia on 4/14/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import "FMLSearch.h"
#import "GeocodeLocation.h"
#import "FMLAPIClient.h"
#import "FMLMapViewController.h"


@implementation FMLSearch

+(void)searchForNewLocation:(NSString *)location{
    [GeocodeLocation getCoordinateForLocation:location withCompletion:^(CLLocationCoordinate2D coordinate) {
        [[NSUserDefaults standardUserDefaults] setFloat:coordinate.latitude forKey:@"latitude"];
        [[NSUserDefaults standardUserDefaults] setFloat:coordinate.longitude forKey:@"longitude"];
        //this will call the API and then display results
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Search for new location" object:nil];
        //this will zoom to the new location
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ZoomToNewLocation" object:nil];
    }];
    
    
}

@end
