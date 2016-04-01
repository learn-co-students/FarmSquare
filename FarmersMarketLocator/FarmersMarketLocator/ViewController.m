//
//  ViewController.m
//  FarmersMarketLocator
//
//  Created by Jeff Spingeld on 3/29/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import "ViewController.h"
#import "Annotation.h"
#import "SampleZipCodes.h"
#import "FMLAPIClient.h"
#import <CoreLocation/CoreLocation.h>


@interface ViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property(strong, nonatomic) CLLocationManager *manager;
@property(strong, nonatomic) NSMutableArray *annotationArray;
@property(strong, nonatomic) UIView *detailView;
@property(strong, nonatomic) UIImage *arrowImageView;
@property(strong, nonatomic) UILabel *nameLabel;
@property(strong, nonatomic) UILabel *addressLabel;
@property(strong, nonatomic) MKMapView *mapView;

@end




@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set up map and add it to the view
    [self setUpMap];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];

    
    //for location request
    self.manager = [[CLLocationManager alloc]init];
    self.manager.delegate = self;
    
    
    
//    //dummy data -- will be the user-specified location
//    CGFloat NYC_LATITUDE = 40.7141667;
//    CGFloat NYC_LONGITUDE = -74.0063889;
//    
//    
//    
//    
//    //set up detail view and add it to the view
//    [self setUpDetailView];
//    [self.view addSubview:self.detailView];
//    
//    
//    //set up constraints for detail view
//    NSLayoutConstraint *constrainDetailViewBottomAnchor = [self.detailView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];
//    NSLayoutConstraint *constrainDetailViewCenterXAnchor = [self.detailView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor];
//    
//    NSArray *detailViewConstraints = @[constrainDetailViewBottomAnchor, constrainDetailViewCenterXAnchor];
//    
//    [self updateViewWithConstraints:detailViewConstraints];
//    
//    
//    //set up labels (and whatever else) for the detail view
//    //and add it as a subview of the detail view
//    self.nameLabel = [self setUpLabelWithText:@"Greenhouse Farmer's Market" textColor:[UIColor blackColor]];
//    [self.detailView addSubview:self.nameLabel];
//    
//    self.addressLabel = [self setUpLabelWithText:@"123 Easy Street, Manhattan, NY, 11002" textColor:[UIColor blackColor]];
//    [self.detailView addSubview:self.addressLabel];
//    
//    
//    
//    //set up button
//    UIButton *hideDetailViewButton = [self setUpButton];
//    [self.detailView addSubview:hideDetailViewButton];
//    
//    
//    //define constraints for button
//    NSLayoutConstraint *constrainButtonTopAnchor = [hideDetailViewButton.topAnchor constraintEqualToAnchor:self.detailView.topAnchor constant:6];
//    NSLayoutConstraint *constrainButtonCenterXAnchor = [hideDetailViewButton.centerXAnchor constraintEqualToAnchor:self.detailView.centerXAnchor];
//    
//    NSArray *buttonConstraints = @[constrainButtonTopAnchor, constrainButtonCenterXAnchor];
//    
//    [self updateViewWithConstraints:buttonConstraints];
//    
//    
//    //define constraints for labels
//    NSLayoutConstraint *constrainNameLabelTopAnchor = [self.nameLabel.topAnchor constraintEqualToAnchor:hideDetailViewButton.bottomAnchor constant:8];
//    NSLayoutConstraint *constrainNameLabelCenterXAnchor = [self.nameLabel.centerXAnchor constraintEqualToAnchor: self.detailView.centerXAnchor];
//    
//    NSLayoutConstraint *constrainAddressLabelTopAnchor = [self.addressLabel.topAnchor constraintEqualToAnchor:self.nameLabel.bottomAnchor constant:8];
//    NSLayoutConstraint *constrainAddressLabelCenterXAnchor = [self.addressLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor];
//    
//    
//    //setting up for custom constraint activation method
//    NSArray *labelConstraints = @[constrainNameLabelTopAnchor, constrainNameLabelCenterXAnchor, constrainAddressLabelTopAnchor, constrainAddressLabelCenterXAnchor];
//    
//    //activate constraints
//    [self updateViewWithConstraints:labelConstraints];
//    
//    
//    //more dummy data -- will be the market locations
//    NSArray *latitudes = [SampleZipCodes returnLatitudes];
//    NSArray *longitudes = [SampleZipCodes returnLongitudes];
//    NSArray *zipCodes = [SampleZipCodes returnZipCodes];
//    
//    NSInteger numberOfIterations = latitudes.count;
//    
//    for (NSInteger i = 0; i < numberOfIterations; i++){
//        //create annotation and add it to the map view
//        CGFloat latitude = [latitudes[i] floatValue];
//        CGFloat longitude = [longitudes[i] floatValue];
//        NSString *title = zipCodes[i];
//        NSString *subtitle = @"This should be an address.";
//        
//        Annotation *annotation = [self makeAnnotationUsingLatitude:latitude longitude:longitude title:title subtitle:subtitle];
//        MKAnnotationView *annotationView = [mapView viewForAnnotation:annotation];
//        //to identify which annotation has been selected via the
//        //annotation array (property) .. index of array == tag
//        annotationView.tag = i;
//        [mapView addAnnotation:annotation];
//    }
//    
//    self.detailView.transform = CGAffineTransformMakeTranslation(0, self.detailView.frame.size.height);
    
}

-(void)viewDidAppear:(BOOL)animated {
    [self.manager requestWhenInUseAuthorization];
}

-(void)setUpMap{
    //screen dimensions
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    //map dimensions
    self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 50, screenWidth, screenHeight - 50)];
    
    //map preferences
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    
}

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
}


-(void)hideDetailView{
    [UIView animateWithDuration:0.25 animations:^{
        self.detailView.transform = CGAffineTransformMakeTranslation(0, self.detailView.frame.size.height);
        
    } completion:nil];
}

-(void)showDetailView{
    [UIView animateWithDuration:0.25 animations:^{
        self.detailView.transform = CGAffineTransformIdentity;
        
    } completion:nil];
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

-(UIButton *)setUpButton{
    
    //create button with down arrow image
    UIButton *button = [[UIButton alloc]init];
    self.arrowImageView = [UIImage imageNamed:@"down arrow"];
    [button setImage:self.arrowImageView forState:UIControlStateNormal];
    [button addTarget:self action:@selector(hideDetailView) forControlEvents:UIControlEventTouchUpInside];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    return button;
}

-(void)updateViewWithConstraints:(NSArray *)arrayOfConstraints{
    
    //for each constraint, activate it
    for (NSLayoutConstraint *constraint in arrayOfConstraints){
        constraint.active = YES;
    }
    [self.view updateConstraints];
}



-(Annotation *)makeAnnotationUsingLatitude:(CGFloat)latitude longitude:(CGFloat)longitude title:(NSString *)titleString subtitle:(NSString *)subtitleString{
    
    //coordinate of pin (market)
    CLLocationCoordinate2D location;
    location.latitude = latitude;
    location.longitude = longitude;
    
    //create the pin and define its properties (coordinate is mandatory)
    Annotation *annotation = [Annotation alloc];
    annotation.coordinate = location;
    annotation.title = titleString;
    annotation.subtitle = subtitleString;
    
    //keeping track of annotation order (in order to grab information
    //later -- for detail view
    //---------------------------------v-v----------------------------
    //the index of an annotation in this array == annotation.tag
    [self.annotationArray addObject:annotation];
    
    return annotation;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    //zoom in and display detail view animated
    
    NSLog(@"hello?");
    
    self.nameLabel.text = view.annotation.title;
    self.addressLabel.text = view.annotation.subtitle;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.detailView.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    MKCoordinateRegion region;
    
    
    //specify how far the map should zoom into the center pt
    MKCoordinateSpan span;
    span.longitudeDelta = 0.01;
    span.latitudeDelta = 0.01;
    
    //add center and span to map view
    region.center = view.annotation.coordinate;
    region.span = span;
    [mapView setRegion:region animated:YES];
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    //hide detail view animated
    
    
}

//-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
//    
//}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"authorization changed");
        [self refocusToUserLocation];
    }
        
}
    


-(void)refocusToUserLocation {
    CLLocationCoordinate2D coordinates = self.mapView.userLocation.location.coordinate;
    NSLog(@"(%f,%f)", coordinates.latitude, coordinates.longitude);
    //zoom map into user's location
    
    [self zoomMaptoLatitude:coordinates.latitude longitude:coordinates.longitude withLatitudeSpan:0.05 longitudeSpan:0.05];
}


@end
