//
//  GeocodeLocation.h
//  FarmersMarketLocator
//
//  Created by Julia on 4/14/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface GeocodeLocation : NSObject

+(void)getCoordinateForLocation:(NSString *)locationString withCompletion:(void (^)(CLLocationCoordinate2D coordinate))block;

@end
