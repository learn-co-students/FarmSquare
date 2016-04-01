//
//  FMLMapViewController.m
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 3/31/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import "FMLMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FMLMapViewDelegate.h"
#import "FMLLocationManagerDelegate.h"
#import "SampleZipCodes.h"
#import "FMLAPIClient.h"
#import "Annotation.h"
#import "FMLMarket.h"

@interface FMLMapViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) FMLMapViewDelegate *mapDelegate;
@property (strong, nonatomic) FMLLocationManagerDelegate *locationDelegate;
@property (strong, nonatomic) NSArray *marketsArray;

@end

@implementation FMLMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init delegates
    self.mapDelegate = [[FMLMapViewDelegate alloc] initWithTarget:self];
    self.locationDelegate = [[FMLLocationManagerDelegate alloc] initWithTarget:self];
    
    
    // Create and customize map view
    self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50)];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self.mapDelegate;
    
    // Add it to view
    [self.view addSubview:self.mapView];
    
    
    // Create detail view
    [self setUpDetailView];
    [self.view addSubview:self.detailView];
    
    
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self.locationDelegate;
    
    [self.manager requestWhenInUseAuthorization];
    
    // TODO: Figure out if queue should be main queue
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMarketObjects) name:@"GotUserCoordinates" object:nil];
}

#pragma mark - Helper Method

-(void)zoomMaptoLatitude:(CGFloat)latitude longitude:(CGFloat)longitude withLatitudeSpan:(CGFloat)latitudeSpan longitudeSpan:(CGFloat)longitudeSpan{
    
    MKCoordinateRegion region;
    
    //center the map on a specific location
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    
    //specify how far the map should zoom into the center pt
    MKCoordinateSpan span;
    span.longitudeDelta = latitudeSpan;
    span.latitudeDelta = longitudeSpan;
    
    //add center and span to map view
    region.center = center;
    region.span = span;
    [self.mapView setRegion:region animated:YES];
}

-(void)setUpDetailView{
    //dimensions
    CGFloat width = self.view.frame.size.width;
    CGFloat heightOfMarketDetailView = self.view.frame.size.height / 5;
    CGFloat yCoordinateOfMarketView = self.view.frame.size.height - heightOfMarketDetailView;
    
    //define detail view (property)
    self.detailView = [[UIView alloc]initWithFrame:CGRectMake(0, yCoordinateOfMarketView, width, heightOfMarketDetailView)];
    self.detailView.backgroundColor = [UIColor whiteColor];
    
    self.nameLabel = [self setUpLabelWithText:@"Greenhouse Farmer's Market" textColor:[UIColor blackColor]];
        [self.detailView addSubview:self.nameLabel];
    
        self.addressLabel = [self setUpLabelWithText:@"123 Easy Street, Manhattan, NY, 11002" textColor:[UIColor blackColor]];
        [self.detailView addSubview:self.addressLabel];
    
//        //define constraints for labels
//    NSLayoutConstraint *constrainNameLabelTopAnchor = [self.nameLabel.topAnchor constraintEqualToAnchor:hideDetailViewButton.bottomAnchor constant:8];
//    NSLayoutConstraint *constrainNameLabelCenterXAnchor = [self.nameLabel.centerXAnchor constraintEqualToAnchor: self.detailView.centerXAnchor];
//
//    NSLayoutConstraint *constrainAddressLabelTopAnchor = [self.addressLabel.topAnchor constraintEqualToAnchor:self.nameLabel.bottomAnchor constant:8];
//    NSLayoutConstraint *constrainAddressLabelCenterXAnchor = [self.addressLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor];
}

-(void)getMarketObjects {
    CGFloat latitude = [[NSUserDefaults standardUserDefaults] floatForKey:@"latitude"];
    CGFloat longitude = [[NSUserDefaults standardUserDefaults] floatForKey:@"longitude"];
    
    [FMLAPIClient getMarketsForLatitude:latitude longitude:longitude withCompletion:^(NSMutableArray *marketsArray) {
        
        self.marketsArray = marketsArray;
        // Plot a pin for the coordinates of each FMLMarket object in marketsArray.
        NSUInteger index = 0;
        for (FMLMarket *farmersMarket in marketsArray) {
            CLLocationCoordinate2D location;
            location.latitude = [farmersMarket.latitude floatValue];
            location.longitude = [farmersMarket.longitude floatValue];
            
            Annotation *annotation = [[Annotation alloc] initWithCoordinate:location
                                                                      title:farmersMarket.name subtitle:farmersMarket.address andTag:index];
            index++;
            
            [self.mapView addAnnotation:annotation];
        }
        
    }];
    
}

-(UILabel *)setUpLabelWithText:(NSString *)text textColor:(UIColor *)color{
    
    //create new label using parameters
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.font = [UIFont fontWithName:@"Helvetica" size:16];
    label.textColor = color;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    return label;
}

@end
