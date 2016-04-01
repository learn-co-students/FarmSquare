//
//  FMLMapViewDelegate.m
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/1/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import "FMLMapViewDelegate.h"

@implementation FMLMapViewDelegate 


- (instancetype)init
{
    self = [self initWithTarget:nil];
    return self;
}

- (instancetype)initWithTarget:(FMLMapViewController *)target
{
    self = [super init];
    if (self) {
        _viewController = target;
    }
    return self;
}


#pragma mark - MKMapView Delegate Methods


@end
