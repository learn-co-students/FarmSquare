//
//  FMLMapViewDelegate.m
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/1/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import "FMLMapViewDelegate.h"
#import "FMLMarket.h"
#import "FMLMarket+CoreDataProperties.h"
#import "FMLDetailView.h"
#import "Annotation.h"

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

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    self.selectedAnnotationView = view;
    
    Annotation *annotation = (Annotation *)view.annotation;
    FMLMarket *market = self.viewController.marketsArray[ annotation.tag ];
    FMLDetailView *detailView = self.viewController.detailView;
    detailView.nameLabel.text = market.name;
    detailView.addressLabel.text = market.address;
    
    if (mapView.region.span.longitudeDelta != detailView.previousRegion.span.longitudeDelta) {
        detailView.previousRegion = mapView.region;
    }
    
    
    [self.viewController zoomMaptoLatitude:[market.latitude floatValue]  longitude:[market.longitude floatValue] withLatitudeSpan:0.01 longitudeSpan:0.01];
    
    [detailView showDetailView];
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [self.viewController.detailView hideDetailView];
}
@end
