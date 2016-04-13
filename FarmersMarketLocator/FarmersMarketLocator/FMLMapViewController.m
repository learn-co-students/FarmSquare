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
#import "FMLDetailView.h"
#import "FMLMarket+CoreDataProperties.h"
#import "CoreDataStack.h"
#import "FMLPinAnnotationView.h"
#import "FMLJSONDictionary.h"
#import <QuartzCore/QuartzCore.h>

// TODO: When network connection is lost, Core Data misfunctions and saves 0 objects which shouldn't be ok

@interface FMLMapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) FMLMapViewDelegate *mapDelegate;
@property (strong, nonatomic) FMLLocationManagerDelegate *locationDelegate;
@property (strong, nonatomic) UIView *dimView;
@property (nonatomic) CGFloat animationSpeed;

@end

@implementation FMLMapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init delegates
    self.mapDelegate = [[FMLMapViewDelegate alloc] initWithTarget:self];
    self.locationDelegate = [[FMLLocationManagerDelegate alloc] initWithTarget:self];
    
    // Create and customize map view
    self.mapView = [[MKMapView alloc]initWithFrame:self.view.frame];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self.mapDelegate;
    
    // Add it to view
    [self.view addSubview:self.mapView];
    
    
    // Create detail view
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height * 0.4;
    CGFloat yCoordinateOfMarketView = self.view.frame.size.height - height;
    
    //define detail view (property)
    self.detailView = [[FMLDetailView alloc] initWithFrame:CGRectMake(0, yCoordinateOfMarketView, width, height)];
    [self.view addSubview:self.detailView];
    [self.detailView constrainViews];

    
    
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self.locationDelegate;
    self.detailView.locationManager = self.manager;
    
    
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
    
    self.detailView.transform = CGAffineTransformMakeTranslation(0, self.detailView.frame.size.height);
    
    self.mapView.delegate = self;
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

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    NSString *annotationReuseID = @"PinWithDoubleTapGesture";
    
    // Dequeue a custom pin annotation view
    FMLPinAnnotationView *stockPinView = (FMLPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationReuseID];
    
    // If you don't get one back, initialize one
    if (!stockPinView) {
        stockPinView = [[FMLPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationReuseID];
    }
    
    // If the pin doesn't have the double-tap gesture recognizer, add it
    if (stockPinView.gestureRecognizers.count == 0) {
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showProductsCircleForMarket:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        doubleTapRecognizer.delegate = self;
        [stockPinView addGestureRecognizer:doubleTapRecognizer];
    }

    return stockPinView;
    
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

#pragma mark - product icons methods

// When a pin is double-tapped, don't also zoom in on the map.
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}

// Shoot out an icon for each product type available at that Farmer's Market. The icons should radiate out to equidistant positions around a circle centered on the pin. The Assets folder contains an icon for each product category.
-(void)showProductsCircleForMarket:(UITapGestureRecognizer *)gestureRecognizer {

    // ~ DIM VIEW ~ ------------------------
    // To disable and dim the map/background, put a partially transparent view over it
    // TODO: Could do a blur thing instead of a gray thing, might look nicer. Could also change the color.
        self.dimView = [[UIView alloc] initWithFrame:self.mapView.frame];
        self.dimView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.6];
        [self.view addSubview:self.dimView];
    
    // Change pin view's background color when tapped (for testing only, DELETE AFTER)
    FMLPinAnnotationView *view = (FMLPinAnnotationView *)gestureRecognizer.view;
    view.backgroundColor = [UIColor greenColor];
    // ------------------------
    
    
    // ~ NEW PIN VIEW ~ ------------------------
    // New pin on top of the old one. Necessary a) so the pin isn't blurred/dimmed, and b) to hold a gesture recognizer.
    FMLPinAnnotationView *newPinView = [[FMLPinAnnotationView alloc] init];
    newPinView.frame = view.frame;
    newPinView.pinTintColor = [UIColor yellowColor];
    // Tag pinView so we can exclude it from the icon animations later
    newPinView.tag = 1;
    // Add as subview of dimView
    [self.dimView addSubview:newPinView];
    
    // Add double-tap recognizer to make the icons go away
    UITapGestureRecognizer *secondDoubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeDimViewFromSuperView)];
    secondDoubleTap.numberOfTapsRequired = 2;
    secondDoubleTap.delegate = self;
    [newPinView addGestureRecognizer:secondDoubleTap];
    // ------------------------
    
    
    // ~ ICON CIRCLE ~ ------------------------
    
    // Get an array of the names of the icons we want. (Remove slashes because filenames can't have slashes.)
    Annotation *annotation = view.annotation;
    NSMutableArray *iconsArray = [[[annotation.market.produceList stringByReplacingOccurrencesOfString:@"/" withString:@"" ] componentsSeparatedByString:@"; "] mutableCopy];
    
    // Number of degrees separating icons
    CGFloat degreesBetweenIcons = 360 / iconsArray.count;
    // Index (to multiply number of degrees by)
    NSUInteger index = 0;
    
    // Make each icon appear at the center of the pin and animate out to its position.
    for (NSString *iconName in iconsArray) {
        
        // ~~~~~ ICONS: INITIAL STATE ~~~~~
        
        // Create a circle:
        // Make a view
        UIView *circleView = [[UIView alloc] init];
        circleView.translatesAutoresizingMaskIntoConstraints = NO;
        circleView.backgroundColor = [UIColor brownColor];
        // Corner radius to 50 makes it a circle
        circleView.layer.cornerRadius = 15;
        // Add to dimView
        [self.dimView addSubview:circleView];
        // Position constraints: center the circle at the center of the pin view
        NSLayoutConstraint *circleCenterX = [NSLayoutConstraint constraintWithItem:circleView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:newPinView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *circleCenterY = [NSLayoutConstraint constraintWithItem:circleView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:newPinView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        circleCenterX.active = YES;
        circleCenterY.active = YES;
        NSLayoutConstraint *circleHeight = [circleView.heightAnchor constraintEqualToConstant:0];
        NSLayoutConstraint *circleWidth = [circleView.widthAnchor constraintEqualToConstant:0];
        circleHeight.active = YES;
        circleWidth.active = YES;
        circleView.alpha = 0;
        
        // Get the icon and put it on the circle:
        // Create an image view with the icon
        UIImage *icon = [UIImage imageNamed:iconName];
        UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        iconView.clipsToBounds = YES;
        iconView.translatesAutoresizingMaskIntoConstraints = NO;
        // Put the icon on the circle
        [circleView addSubview:iconView];
        
        // Constrain icon to center of circle
        // Both the icons and the circles should start out sizeless and fully transparent
        
        NSLayoutConstraint *iconAtCenterOfCircleX = [NSLayoutConstraint constraintWithItem:iconView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:circleView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *iconAtCenterOfCircleY = [NSLayoutConstraint constraintWithItem:iconView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:circleView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        iconAtCenterOfCircleX.active = YES;
        iconAtCenterOfCircleY.active = YES;
        NSLayoutConstraint *iconHeight = [iconView.heightAnchor constraintEqualToConstant:0];
        NSLayoutConstraint *iconWidth = [iconView.widthAnchor constraintEqualToConstant:0];
        iconHeight.active = YES;
        iconWidth.active = YES;
        iconView.alpha = 0;
        
        [self.dimView layoutSubviews];
        [circleView layoutIfNeeded];
        
        
        // ~~~~~ ICONS: FINAL STATE ~~~~~
        
        // Calculate number of degrees around the circle that the icon should be
        CGFloat degreesForIcon = degreesBetweenIcons * index;
        
        // Get the coordinates of that position
        CGPoint iconDestinationPosition = [self pointAroundCircumferenceFromCenter:view.center withRadius:50 andAngle:degreesForIcon];
        
        // Animate the icon moving to its position in the circle.
        self.animationSpeed = 0.25;
        [UIView animateWithDuration:self.animationSpeed animations:^{
            
            // position (we move only the circle; the icon is constrained to it)
            circleCenterX.active = NO;
            circleCenterY.active = NO;
            NSLayoutConstraint *xPosition = [circleView.centerXAnchor constraintEqualToAnchor:self.dimView.leftAnchor constant:iconDestinationPosition.x];
            NSLayoutConstraint *yPosition = [circleView.centerYAnchor constraintEqualToAnchor:self.dimView.topAnchor constant:iconDestinationPosition.y];

            xPosition.active = YES;
            yPosition.active = YES;
            
            // alpha (opacity)
            iconView.alpha = 1;
            circleView.alpha = 1;
            
            // size
            // TODO: make the height and width a calculation based on the size of the view, so it works correctly regardless of device. Or perhaps as a multiple of the size of the pinview or something.
            circleHeight.constant = 30;
            circleWidth.constant = 30;
            iconHeight.constant = 15;
            iconWidth.constant = 15;
            
            [self.dimView layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            if (finished) {
                
            }
        }];
        
        // Increment index
        index++;
        
    }

    // ------------------------
 
}

// Remove dimView: animate the disappearance of the icons, then remove the view entirely.
-(void)removeDimViewFromSuperView{

    // Array of the subviews. This includes both the icons and the pin in the middle.
    NSArray *subviews = self.dimView.subviews;
    
    // TODO: check if there's a better way to separate the icons (imageviews) from the pin (either MKPinAnnotationView or our subclass of it) than these for-loops and if-statements. NSPredicate? IndexOfObjectPassingTest?
    
    // Capture the pin annotation view in a variable, so we can use its location as the point on which the icons should converge
    MKAnnotationView *pinView;
    for (UIView *subview in subviews) {
        if (subview.tag == 1) {
            pinView = (MKAnnotationView *)subview;
            break;
        }
    }

    // Animation of icons' disappearance: become transparent, shrink, move back to the center.
    [UIView animateWithDuration:self.animationSpeed animations:^{
        
        for (UIView *subview in subviews) {
            
            if (subview.tag != 1) {
                
                // Transparency/alpha
                subview.alpha = 0;
                // Size
                subview.frame = CGRectZero;
                // Position
                subview.center = pinView.center;
                
            }
        }
        
    } completion:^(BOOL finished) {
       
        // After the animation, remove the pin. (Don't animate this: there's an identical one right underneath and it shouldn't look like there's two. The color/alpha could animate, though.)
        [pinView removeFromSuperview];
        
        // After everything else, make dimView disappear
        [self.dimView removeFromSuperview];
        
    }];
}

// Function to get points at a particular number of degrees around a circle
// from Stack Overflow: http://stackoverflow.com/questions/17739397/get-end-points-of-circle-drawn-in-objectivec
- (CGPoint)pointAroundCircumferenceFromCenter:(CGPoint)center withRadius:(CGFloat)radius andAngle:(CGFloat)theta
{
    
    // Convert degrees to radians, which is the measure assumed by Objective-C's cosine, etc. functions
    theta = theta * (M_PI / 180);
    
    CGPoint point = CGPointZero;
    point.x = center.x + radius * cos(theta);
    point.y = center.y + radius * sin(theta);
    
    return point;
    
}




/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Icons stuff
 
 To-do:
 - Somehow make the center of the circle of icons be the actual location, not just the center of the pin view. More like, the bottom middle?
 - Remove green background from pin view.
 - Fix the frames thing: should be based on a calculation with screen size, not an absolute number
 - What if there are too many items? Bigger circle? Spiral? A "..." icon that you can tap to expand more?
 - Should it move the double-tapped pin to the center? Otherwise, if it's close to the side some of the icons will be offscreen.
 - Should there be little text labels next to the icons? Maybe you can touch an icon to see the text
 - Instead of making new constraints in the animation, just reassign the values of the existing constraints. Rename appropriately.
 - Account for what happens if we get a name of a product type that's not in the Assets
 - ERROR: for the market near the Exploratorium in San Francisco, we get:
 -[MKUserLocation market]: unrecognized selector sent to instance 0x7fafb0d02c00
 
 Done:
 - Disable the map movement and make the background dim.
 - On second double-tap (and/or tap elsewhere), make the icons get sucked back into the pin and restore map functionality. (Do this last, because it has to reverse all the previous stuff.)
 - Issue: the dimView's alpha applies not to just the background, but to the pin and icons on top of it. Fix this. (Does the background itself have an alpha that can be set independently?)
 - Get actual icons (Noun Project, Flaticon, etc.), put them in Assets, give them the right names, and uncomment the code that adds to the iconsArray using the dictionary. (Could do it without the dictionary and just give them the same names as the strings, BUT there are slashes in some of the strings. Could just change them first though.)
 - Make all the icons circles of uniform size--they don't come as circles, so put them on colored circles. This will be much prettier.
 
 
 
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
