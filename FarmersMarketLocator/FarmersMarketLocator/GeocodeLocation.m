//
//  GeocodeLocation.m
//  FarmersMarketLocator
//
//  Created by Julia on 4/14/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import "GeocodeLocation.h"
#import <CoreLocation/CoreLocation.h>

@interface GeocodeLocation ()


@end

@implementation GeocodeLocation

+(void)getCoordinateForLocation:(NSString *)locationString withCompletion:(void (^)(CLLocationCoordinate2D))block{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder geocodeAddressString:locationString completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        for (CLPlacemark *placemark in placemarks){
            block(placemark.location.coordinate);
        }
    }];
}

@end
