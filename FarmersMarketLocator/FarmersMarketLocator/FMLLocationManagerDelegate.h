//
//  FMLLocationManagerDelegate.h
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/1/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "FMLMapViewController.h"

@interface FMLLocationManagerDelegate : NSObject <CLLocationManagerDelegate>

- (instancetype)initWithTarget:(FMLMapViewController *)target;

- (void)displayLocationAlert;

@end
