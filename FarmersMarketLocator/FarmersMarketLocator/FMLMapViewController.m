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
    self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50)];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self.mapDelegate;
    
    // Add it to view
    [self.view addSubview:self.mapView];
    
    
    // Create detail view
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height / 5;
    CGFloat yCoordinateOfMarketView = self.view.frame.size.height - height;
    
    //define detail view (property)
    self.detailView = [[FMLDetailView alloc] initWithFrame:CGRectMake(0, yCoordinateOfMarketView, width, height)];
    [self.view addSubview:self.detailView];
    [self.detailView constrainViews];
    
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self.locationDelegate;
    
    
    // Show saved data
    
    
    NSManagedObjectContext *context = [[CoreDataStack sharedStack] managedObjectContext];
    NSFetchRequest *getSavedLocationsFetch = [NSFetchRequest fetchRequestWithEntityName:@"FMLMarket"];
    
    self.marketsArray = [context executeFetchRequest:getSavedLocationsFetch error:nil];
    
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
        
// TODO: delete this
//        // Capture the annotation view in a variable
//        MKAnnotationView *annotationView = [self.mapView viewForAnnotation:annotation]; // coming back nil :\
//        // Create a double-tap gesture recognizer that calls a method that makes the circle thing happen.
//        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showProductsCircleForMarket:)];
//        doubleTapRecognizer.numberOfTapsRequired = 2;
//        // Add the gesture recognizer to the annotation view.
//        
//        [annotationView addGestureRecognizer:doubleTapRecognizer];
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

// When a pin is double-tapped, don't also zoom in on the map.
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}

// When a pin is double-tapped, shoot out an icon for each product available at that Farmer's Market. The icons should radiate out to form a circle around the pin. (If there's not enough room, maybe a spiral instead.)
-(void)showProductsCircleForMarket:(UITapGestureRecognizer *)gestureRecognizer {

    // To disable and dim the map/background, put a grayish transparent view over it
        self.dimView = [[UIView alloc] initWithFrame:self.mapView.frame];
        self.dimView.backgroundColor = [UIColor grayColor];
        self.dimView.alpha = 0.6; // Could do a blur thing instead of a gray thing, might look nicer
        [self.view addSubview:self.dimView];
    
    // Create the view that holds the pin and its icons
    FMLPinAnnotationView *view = (FMLPinAnnotationView *)gestureRecognizer.view;
    // Turn off autoresizing thing (its constraints interfere with ours)
//    view.translatesAutoresizingMaskIntoConstraints = NO;
    // Make the pin's view (not the pin itself) big enough to hold the pin and all the icons that will be placed around it.
//    [view.heightAnchor constraintEqualToConstant:150].active=YES;
//    [view.widthAnchor constraintEqualToConstant:150].active=YES;
    view.backgroundColor = [UIColor greenColor];
    
    
    Annotation *annotation = view.annotation;
    
    // We're going to have a set of icons in assets that represent all of .
    
    // Each key in this dictionary is a product category. Each value is the name of an icon in Assets that represents that category.
    // NOTE: right now I'm using dummy pictures to save time. Later we can pick actual icons (from the Noun Project or Flaticon or wherever).
    NSDictionary *productIconsDictionary = @{@"Baked goods": @"Baked goods",
                                            @"Cheese and/or dairy products": @"",
                                            @"Crafts and/or woodworking items": @"Crafts and or woodworking items",
                                            @"Cut flowers": @"",
                                            @"Eggs": @"",
                                            @"Fish and/or seafood": @"",
                                            @"Fresh and/or dried herbs": @"",
                                            @"Fresh vegetables": @"",
                                            @"Honey": @"",
                                            @"Canned or preserved fruits, vegetables, jams, jellies, preserves, salsas, pickles, dried fruit, etc.": @"",
                                            @"Maple syrup and/or maple products": @"",
                                            @"Meat": @"",
                                            @"Nuts": @"",
                                            @"Plants in containers": @"",
                                            @"Poultry": @"",
                                            @"Prepared foods (for immediate consumption)": @"",
                                            @"Soap and/or body care products": @"",
                                            @"Trees, shrubs": @"",
                                            @"Wine, beer, hard cider": @"",
                                            @"Coffee and or tea": @"",
                                            @"Dry beans": @"",
                                            @"Fresh fruits": @"",
                                            @"Grains and or flour": @"",
                                            @"Juices and or non-alcoholic ciders": @"",
                                            @"Mushrooms": @"",
                                            @"Pet food": @"",
                                            @"Tofu and or non-animal protein": @"",
                                            @"Wild harvested forest products: mushrooms, medicinal herbs, edible fruits and nuts, etc.": @""
                                            };
    
    // Create an array to store the icons we want to pop out
    NSMutableArray *iconsArray = [NSMutableArray new];
    
    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
     To-do:
     - Get actual icons (Noun Project, Flaticon, etc.), put them in Assets, give them the right names, and uncomment the code that adds to the iconsArray using the dictionary. (Could do it without the dictionary and just give them the same names as the strings, BUT there are slashes in some of the strings. Could just change them first though.)
     - Make all the icons circles of uniform size--they don't come as circles, so put them on colored circles. This will be much prettier.
     - Somehow make the center of the circle be the actual location, not just the center of the pin view. More like, the bottom middle?
     - Remove green background from pin view.
     - Fix the frames thing: should be based on a calculation with screen size, not an absolute number
     - What if there are too many items? Bigger circle? Spiral? A "..." icon that you can tap to expand more?
     - Should it move the double-tapped pin to the center? Otherwise, if it's close to the side some of the icons will be offscreen.
     - Should there be little text labels next to the icons? Maybe you can touch an icon to see the text
     - On second double-tap (and/or tap elsewhere), make the icons get sucked back into the pin and restore map functionality. (Do this last, because it has to reverse all the previous stuff.)
     - Instead of making new constraints in the animation, just reassign the values of the existing constraints. Rename appropriately.
    
     Done:
     - Disable the map movement and make the background dim.
     
     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     */
     
    // Uncomment this after test ---->

//    // Get the right icons
//    for (NSString *product in annotation.market.productsArray) {
//
//        NSString *iconName = [NSString stringWithFormat:@"%@", product];
//        [iconsArray addObject:productIconsDictionary[iconName]];
//        
//        
//        
//    }
    
    // TODO: REMOVE THIS AFTER TEST
    iconsArray = [@[@"Baked goods", @"Baked goods", @"Baked goods", @"Baked goods", @"Baked goods", @"Baked goods"] mutableCopy];
    
    // Place the icons equidistant from each other along a circle around around the pin.
    // Figure out the position of each icon. Basically, divide 360 by the number of icons, and put an icon at a position that many degrees around the circle...?
    CGFloat degreesBetweenIcons = 360 / iconsArray.count;
    // index to multiply number of degrees by
    NSUInteger index = 0;

    // ---------------- Duplicate pin view
    // Add a duplicate pin view in the same place as the old one, so that it can be double-tapped again to get out of this view.
    FMLPinAnnotationView *newPinView = [[FMLPinAnnotationView alloc] init];
    newPinView.frame = view.frame;
    newPinView.pinTintColor = [UIColor yellowColor];
    [self.dimView addSubview:newPinView];
    
    // On second double-tap, get rid of the dim view (this will get rid of the icons and the duplicate pin, which are its subviews)
    UITapGestureRecognizer *secondDoubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeDimViewFromSuperView)];
    secondDoubleTap.numberOfTapsRequired = 2;
    secondDoubleTap.delegate = self;
    [newPinView addGestureRecognizer:secondDoubleTap];
    // ---------------
    
    // Make each icon appear at the center of the pin and animate out to its position.
    for (NSString *iconName in iconsArray) {
        
        // ~~~~~ INITIAL STATE OF ICONS ~~~~~
        
        // Create the icon and a view for it.
        UIImage *icon = [UIImage imageNamed:iconName];
        UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        iconView.clipsToBounds = YES;
        iconView.translatesAutoresizingMaskIntoConstraints = NO;
        
        // Sizeless and fully transparent
        NSLayoutConstraint *zeroHeight = [iconView.heightAnchor constraintEqualToConstant:0];
        zeroHeight.identifier = @"zeroheight";
        NSLayoutConstraint *zeroWidth = [iconView.widthAnchor constraintEqualToConstant:0];
        zeroWidth.identifier = @"zeroWidth";
        zeroHeight.active = YES;
        zeroWidth.active = YES;
        iconView.alpha = 0;
        
        // Add the iconView to the dimView as a subview
        [self.dimView addSubview:iconView];
        
        // Initial position: centered on the pin, using NSLayoutConstraints.
        NSLayoutConstraint *sameXAsPin = [NSLayoutConstraint constraintWithItem:iconView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *sameYAsPin = [NSLayoutConstraint constraintWithItem:iconView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        sameXAsPin.active = YES;
        sameYAsPin.active = YES;
//        iconView.frame = CGRectZero;
        iconView.center = view.center;
        
        [self.mapView layoutIfNeeded];
        
        
        // ~~~~~ FINAL STATE OF ICONS ~~~~~
        
        // Calculate number of degrees around the circle that the icon should be
        CGFloat degreesForIcon = degreesBetweenIcons * index;
        
        // Get the coordinates of that position
        CGPoint iconDestinationPosition = [self pointAroundCircumferenceFromCenter:view.center withRadius:50 andAngle:degreesForIcon];
        
        // Animate the icon moving to its position in the circle. Also make it opaque and have size (same size as pin).
        self.animationSpeed = 0.25; // Change this to change the animation speed of both the appearance and disappearance of the icons.
        [UIView animateWithDuration:self.animationSpeed animations:^{
            
            // position
            sameXAsPin.active = NO;
            sameYAsPin.active = NO;
            NSLayoutConstraint *xPosition = [iconView.centerXAnchor constraintEqualToAnchor:self.dimView.leftAnchor constant:iconDestinationPosition.x];
            NSLayoutConstraint *yPosition = [iconView.centerYAnchor constraintEqualToAnchor:self.dimView.topAnchor constant:iconDestinationPosition.y];
//            NSLayoutConstraint *xPosition = [NSLayoutConstraint constraintWithItem:iconView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:iconDestinationPosition.x];
//            NSLayoutConstraint *yPosition = [NSLayoutConstraint constraintWithItem:iconView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:iconDestinationPosition.y];
            xPosition.active = YES;
            yPosition.active = YES;
            
            // alpha (opacity)
            iconView.alpha = 1;
            
            // size
            zeroHeight.active = NO;
            zeroWidth.active = NO;
            [iconView.heightAnchor constraintEqualToConstant:30].active=YES;
            [iconView.widthAnchor constraintEqualToConstant:30].active=YES;
            // NOTE ON FRAMES: make the height and width a calculation based on the size of the view, so it works correctly regardless of device.
//            iconView.frame = CGRectMake(0, 0, 30, 30);
            iconView.center = iconDestinationPosition;
            [self.mapView layoutIfNeeded];
            
        }];
        
        // Increment index
        index++;
        
    }
    

}

-(void)removeDimViewFromSuperView{

    // Array of the subviews. This includes both the icons and the pin in the middle.
    NSArray *subviews = self.dimView.subviews;
    
    // TODO: check if there's a better way to separate the icons (imageviews) from the pin (either MKPinAnnotationView or our subclass of it) than these for-loops and if-statements. NSPredicate? IndexOfObjectPassingTest?
    
    // Capture the pin annotation view in a variable, so we can use its location as the point on which the icons should converge
    MKAnnotationView *pinView;
    for (UIView *subview in subviews) {
        if (![subview isKindOfClass:UIImageView.class]) {
            pinView = (MKAnnotationView *)subview;
            break;
        }
    }
    
    // Animation of icons' disappearance: become transparent, shrink, move back to the center.
    [UIView animateWithDuration:self.animationSpeed animations:^{
        
        for (UIView *subview in subviews) {
            
            if ([subview isKindOfClass:UIImageView.class]) {
                
                // Transparency/alpha
                subview.alpha = 0;
                // Size
                subview.frame = CGRectZero;
                // Position
                subview.center = pinView.center;
                
                // Constraint version of size/position stuff--doesn't work.
                // Remove all old constraints
//                [subview removeConstraints:subview.constraints];
                
                // Size
                //                NSLayoutConstraint *zeroHeight = [subview.heightAnchor constraintEqualToConstant:0];
                //                NSLayoutConstraint *zeroWidth = [subview.widthAnchor constraintEqualToConstant:0];
                //                zeroHeight.active = YES;
                //                zeroWidth.active = YES;
                //
                //                // Position
                //                NSLayoutConstraint *sameXAsPin = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:pinView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
                //                NSLayoutConstraint *sameYAsPin = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:pinView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
                //                sameXAsPin.active = YES;
                //                sameYAsPin.active = YES;
                

                
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








@end
