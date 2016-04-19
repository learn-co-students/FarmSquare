//
//  FMLMapViewDelegate.h
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/1/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "FMLMapViewController.h"
@class FMLTitleView;

@interface FMLMapViewDelegate : NSObject <MKMapViewDelegate>

@property (strong, nonatomic) FMLMapViewController *viewController;
@property (strong, nonatomic) MKAnnotationView *selectedAnnotationView;

- (instancetype)initWithTarget:(FMLMapViewController *)target;

@end
