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
#import "FMLTextFieldDelegate.h"
#import "SampleZipCodes.h"
#import "FMLAPIClient.h"
#import "Annotation.h"
#import "FMLSearch.h"
#import "FMLMarket.h"
#import "FMLDetailView.h"
#import "FMLMarket+CoreDataProperties.h"
#import "CoreDataStack.h"
#import "FMLPinAnnotationView.h"
#import "FMLJSONDictionary.h"
#import <QuartzCore/QuartzCore.h>
#import "FarmersMarketLocator-Swift.h"

// TODO: When network connection is lost, Core Data misfunctions and saves 0 objects which shouldn't be ok

@interface FMLMapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) FMLMapViewDelegate *mapDelegate;
@property (strong, nonatomic) FMLLocationManagerDelegate *locationDelegate;
@property (strong, nonatomic) FMLTextFieldDelegate *textFieldDelegate;
@property (strong, nonatomic) UIView *dimView;
@property (strong, nonatomic) UITextField *searchBarTextField;
@property (strong, nonatomic) UIButton *searchButton;

@end

@implementation FMLMapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    // Init delegates
    self.mapDelegate = [[FMLMapViewDelegate alloc] initWithTarget:self];
    self.locationDelegate = [[FMLLocationManagerDelegate alloc] initWithTarget:self];
    self.textFieldDelegate = [[FMLTextFieldDelegate alloc]initWithTarget:self]; //or searchBarTF?
    
    // Create and customize map view
//    self.mapView = [[MKMapView alloc]initWithFrame:self.view.frame];
    self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height - 30)];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self.mapDelegate;
    
    // Add it to view
    [self.view addSubview:self.mapView];
    
    
    // Create and Add MoveToLocation Button
    self.moveToLocationButton = [self setUpMoveToLocationButtonWithAction:@selector(moveToLocationButtonTapped)];
    [self.view addSubview:self.moveToLocationButton];
    // Set up constraints
    [self.moveToLocationButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-20].active = YES;
    [self.moveToLocationButton.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:20].active = YES;
    [self.moveToLocationButton.heightAnchor constraintEqualToConstant:32].active = YES;
    [self.moveToLocationButton.widthAnchor constraintEqualToConstant:32].active = YES;
    
    // Create and add redoSearchInMapArea button
    self.redoSearchInMapAreaButton = [self createRedoSearchInCurrentMapAreaButtonWithAction:@selector(redoSearchInCurrentMapArea)];
    [self.view addSubview:self.redoSearchInMapAreaButton];
    [self.redoSearchInMapAreaButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-20].active = YES;
    [self.redoSearchInMapAreaButton.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-20].active = YES;
    [self.redoSearchInMapAreaButton.heightAnchor constraintEqualToConstant:32].active = YES;
    [self.redoSearchInMapAreaButton.widthAnchor constraintEqualToConstant:32].active = YES;
    
    
    //set up search bar and search button view
    self.searchBarTextField = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, 0, 0)];
    self.searchBarTextField.delegate = self.textFieldDelegate;
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.searchButton.imageView.image = [UIImage imageNamed:@"magnifying-glass"];
    self.searchButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
////    self.searchButton.backgroundColor = [UIColor blackColor];
//    self.searchButton.image = @[[UIImage imageNamed:@"magnifying-glass"]];
    
    [self.searchButton addTarget:self action:@selector(callSearchMethod) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.searchBarTextField.layer.borderColor = [[UIColor blackColor] CGColor];
    self.searchBarTextField.layer.borderWidth = 1.0;
    
    
    self.searchBarTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [self.view addSubview:self.searchBarTextField];
    [self.view addSubview:self.searchButton];
    
    [self.searchBarTextField.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.searchBarTextField.leadingAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:-65].active = YES;
    [self.searchBarTextField.heightAnchor constraintEqualToConstant:30].active = YES;
    [self.searchBarTextField.widthAnchor constraintEqualToConstant:200].active = YES;
    
    [self.searchButton.topAnchor constraintEqualToAnchor:self.searchBarTextField.topAnchor].active = YES;
    [self.searchButton.leadingAnchor constraintEqualToAnchor:self.searchBarTextField.trailingAnchor constant:10].active = YES;
    [self.searchButton.heightAnchor constraintEqualToAnchor:self.searchBarTextField.heightAnchor].active = YES;
    [self.searchButton.widthAnchor constraintEqualToConstant:30].active = YES;


    
    
    // Create detail view
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height * 0.4;
    CGFloat yCoordinateOfMarketView = self.view.frame.size.height - height;
    
    //define detail view (property)
    self.detailView = [[FMLDetailView alloc] initWithFrame:CGRectMake(0, yCoordinateOfMarketView, width, height)];
    [self.view addSubview:self.detailView];
    [self.detailView constrainViews];

    
    // create Title View
    self.titleView = [[FMLTitleView alloc] initWithFrame:CGRectMake(0, 0, width, 130)];
    [self.view addSubview:self.titleView];
    [self.titleView constrainViews];
    
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self.locationDelegate;
    self.detailView.locationManager = self.manager;
    
    
    
    
    
    // Grab data from Managed Context Object
    NSManagedObjectContext *context = [[CoreDataStack sharedStack] managedObjectContext];
    NSFetchRequest *getSavedLocationsFetch = [NSFetchRequest fetchRequestWithEntityName:@"FMLMarket"];
    
    self.marketsArray = [context executeFetchRequest:getSavedLocationsFetch error:nil];
    
    // If there's saved data, show it
    if ([self.marketsArray count] > 0) {
        self.showingSavedData = YES;
        [self displayMarketObjects:self.marketsArray];
    } else {
        self.showingSavedData = NO;
    }
    
    [self.manager requestWhenInUseAuthorization];
    
    // TODO: Figure out if queue should be main queue
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMarketObjects) name:@"GotUserCoordinates" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zoomBackOut:) name:@"ZoomBackOutKThxBai" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zoomMapToNewLocation) name:@"ZoomToNewLocation" object:nil];
    
    self.detailView.transform = CGAffineTransformMakeTranslation(0, self.detailView.frame.size.height);
    
}

-(void)zoomBackOut:(NSNotification *)notification {
    
    [self.mapView deselectAnnotation:self.mapDelegate.selectedAnnotationView.annotation animated:YES];
    
    NSValue *value = (NSValue *)notification.object;
    MKCoordinateRegion region;
    [value getValue:&region];
    
    [self zoomMaptoLatitude:region.center.latitude longitude:region.center.longitude withLatitudeSpan:region.span.latitudeDelta longitudeSpan:region.span.longitudeDelta];
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



-(void)getMarketObjects {
    CGFloat latitude = [[NSUserDefaults standardUserDefaults] floatForKey:@"latitude"];
    CGFloat longitude = [[NSUserDefaults standardUserDefaults] floatForKey:@"longitude"];
    
    [FMLAPIClient getMarketsForLatitude:latitude longitude:longitude withCompletion:^(NSMutableArray *marketsArray) {
        
        self.marketsArray = marketsArray;
        // Plot a pin for the coordinates of each FMLMarket object in marketsArray.
        [self displayMarketObjects:marketsArray];
        
    }];
    
}

-(void)displayMarketObjects:(NSArray *)marketsArray {
    NSUInteger index = 0;
    //FILTERS!
    
    //before for loop, have a predicate run through the array, if any filters are applied
    
    //snap -- "self.snap = 1"
    
    //wic -- "self.wic = 1"
    //wicCash -- "self.wicCash = 1"
    
    //credit -- "self.credit = 1"
    
    //sfmnp -- "self.sfmnp = 1"
    
    //organic -- "self.organic = 1"
    
    
    
    for (FMLMarket *farmersMarket in marketsArray) {
        CLLocationCoordinate2D location;
        location.latitude = [farmersMarket.latitude floatValue];
        location.longitude = [farmersMarket.longitude floatValue];
        
        Annotation *annotation = [[Annotation alloc] initWithCoordinate:location
                                                                  title:farmersMarket.name subtitle:farmersMarket.address andTag:index
                                                                 Market:farmersMarket];
        index++;
        
        [self.mapView addAnnotation:annotation];
        
    }
}

-(UIButton *)setUpMoveToLocationButtonWithAction:(SEL)action {
    // Create and Add MoveToLocation button
    UIButton *moveToLocationButton = [[UIButton alloc] init];
    UIImage *buttonImage = [UIImage imageNamed:@"gps (1)"];
    [moveToLocationButton setImage:buttonImage forState:UIControlStateNormal];
    [moveToLocationButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    moveToLocationButton.layer.masksToBounds = YES;
    moveToLocationButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    return moveToLocationButton;
}

-(void)moveToLocationButtonTapped {
    CLLocationCoordinate2D currentLocation = self.manager.location.coordinate;
    [self zoomMaptoLatitude:currentLocation.latitude longitude:currentLocation.longitude withLatitudeSpan:0.05 longitudeSpan:0.05];
}

-(UIButton *)createRedoSearchInCurrentMapAreaButtonWithAction:(SEL)action {
    
    UIButton *button = [[UIButton alloc] init];
    UIImage *buttonImage = [UIImage imageNamed:@"redoSearchButton"];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    button.layer.masksToBounds = YES;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    return button;
    
}

-(void)redoSearchInCurrentMapArea {
    
    MKCoordinateRegion currentRegion = self.mapView.region;
    CLLocationDegrees latitude = currentRegion.center.latitude;
    CLLocationDegrees longitude = currentRegion.center.longitude;

    [FMLAPIClient getMarketsForLatitude:latitude longitude:longitude withCompletion:^(NSMutableArray *marketsArray) {
        
        [self displayMarketObjects:marketsArray];
        
    }];
    
    
}
-(void)callSearchMethod{
    [FMLSearch searchForNewLocation:self.searchBarTextField.text];
}

-(void)zoomMapToNewLocation{
    [self zoomMaptoLatitude:[[NSUserDefaults standardUserDefaults] floatForKey:@"latitude"] longitude:[[NSUserDefaults standardUserDefaults] floatForKey:@"longitude"] withLatitudeSpan:0.05 longitudeSpan:0.05];
}

#pragma mark - product icons methods

// When a pin is double-tapped, don't also zoom in on the map.
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}

// Shoot out an icon for each product type available at that Farmer's Market. The icons should radiate out to equidistant positions around a circle centered on the pin. The Assets folder contains an icon for each product category.

// Remove dimView: animate the disappearance of the icons, then remove the view entirely.






/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Icons stuff
 
 To-do:
 - Somehow make the center of the circle of icons be the actual location, not just the center of the pin view. More like, the bottom middle?
 - Remove green background from pin view.
 - Fix the frames thing: should be based on a calculation with screen size, not an absolute number
 - What if there are too many items? Bigger circle? Spiral? A "..." icon that you can tap to expand more?
 - Should there be little text labels next to the icons? Maybe you can touch an icon to see the text
 - Instead of making new constraints in the animation, just reassign the values of the existing constraints. Rename appropriately.
 - Account for what happens if we get a name of a product type that's not in the Assets
 - ERROR: for the market near the Exploratorium in San Francisco, we get:
 -[MKUserLocation market]: unrecognized selector sent to instance 0x7fafb0d02c00
 
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */

// ~ PICTURE CREDITS ~
// (see https://thenounproject.zendesk.com/hc/en-us/articles/200509928-How-do-I-give-creators-credit-in-my-work-)
// Tools for editing: http://www.networkworld.com/article/2602971/software/how-to-automate-image-editing-with-gimp.html and https://pixlr.com/editor/

/*
 baked goods -- ??
 Cheese by Arthur Shlain from the Noun Project
 wooden horse by Luis Rodrigues from the Noun Project
 Rose by Juan Pablo Bravo from the Noun Project
 eggs by Alex Bu from the Noun Project
 Fish by Federico Panzano from the Noun Project
 leaf by Ola Möller from the Noun Project
 Broccoli by Creative Stall from the Noun Project
 honey by Cassie McKown from the Noun Project
 Strawberry Jam by Nikita Kozin from the Noun Project
 maple syrup by Pumpkin Juice from the Noun Project
 Steak by Blaise Sewell from the Noun Project
 Peanut by Charlotte Gilissen from the Noun Project
 (plant by Becky Warren: public domain)
 Chicken by Elves Sousa from the Noun Project
 Cafeteria Plate by Studio Fibonacci from the Noun Project
 liquid soap by Arthur Shlain from the Noun Project
 Tree by Edward Boatman from the Noun Project
 Beer by Claire Jones from the Noun Project
 Coffee by Grant Taylor from the Noun Project
 beans by Anna Bearne from the Noun Project
 Apple by Creative Stall from the Noun Project
 Wheat by Creative Stall from the Noun Project
 Cocktail by Виталий Плут from the Noun Project
 Mushrooms by Creative Stall from the Noun Project
 food bowl by Виталий Плут from the Noun Project
 Tofu by Anna Bearne from the Noun Project
 -----  (get rid of this one) fruit tree by Eugene Dobrik from the Noun Project
 Pine Cone by Arthur Shlain from the Noun Project
 
 redoSearch button:
 Icon made by Minh Hoang (http://www.flaticon.com/authors/minh-hoang) from www.flaticon.com

 */

@end
