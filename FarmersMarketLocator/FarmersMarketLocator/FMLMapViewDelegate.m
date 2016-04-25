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
#import "FMLPinAnnotationView.h"
#import "FarmersMarketLocator-Swift.h"
#import "FMLMapViewController.h"

typedef NS_ENUM(NSInteger, FMLMarketStatus) {
    FMLMarketHasNoInfo          = -1,
    FMLMarketIsOutOfSeason      = 0, 
    FMLMarketIsOpen             = 1,
    FMLMarketIsClosingSoon      = 2,
    FMLMarketIsClosed           = 3
};

@interface FMLMapViewDelegate()

@property (nonatomic) CGFloat animationSpeed;
@property (strong, nonatomic) NSMutableArray *currentProductsIcons;
@property (assign, nonatomic) CGFloat offset;
@property (strong, nonatomic) UIView *cover;
@property (nonatomic) BOOL iconCircleExists;


@end

@implementation FMLMapViewDelegate


- (instancetype)init
{
    self = [self initWithTarget:nil];
    return self;
}

// Initializes with view controller so it's methods and properties can be accessed
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
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Hide search filters" object:nil];
    self.selectedAnnotationView = view;
    
    // Show the detail label; show the circle of product category icons
    if ([Annotation isSubclassOfClass:view.annotation.class]  ) {
        
        Annotation *annotation = (Annotation *)view.annotation;
        FMLMarket *market = self.viewController.marketsArray[ annotation.tag ];
        FMLDetailView *detailView = self.viewController.detailView;
        
        detailView.name = market.name.uppercaseString;
        detailView.produceTextView.text = [NSString stringWithFormat:@"AVAILABLE PRODUCE: %@", market.produceList];
        detailView.scheduleLabel.text = [NSString stringWithFormat:@"SCHEDULE: %@", market.scheduleString];
        
        //to use in yelp URL:
        detailView.zip = market.zipCode;
        
        //to use in maps URL for directions:
        detailView.selectedLatitude = [market.latitude floatValue];
        detailView.selectedLongitude = [market.longitude floatValue];
        
        [detailView showDetailView];
        
        // Center pin in map
        if (mapView.region.span.longitudeDelta != detailView.previousRegion.span.longitudeDelta) {
            detailView.previousRegion = mapView.region;
        }

        // Set and show title view. Also, move up map
        FMLTitleView *titleView = self.viewController.titleView;
        
        CGFloat distance = detailView.frame.size.height - titleView.frame.origin.y;
        CGFloat halfway = detailView.frame.size.height + distance/2;
        self.offset = halfway - self.viewController.view.frame.size.height/2;
        [UIView animateWithDuration:0.25 animations:^{
            self.viewController.mapView.transform = CGAffineTransformMakeTranslation(0, -self.offset);
        }];
        titleView.nameLabel.text = market.name.uppercaseString;
        titleView.addressLabel.text = [NSString stringWithFormat:@"%@\n%@, %@ %@", market.street, market.city, market.state, market.zipCode];
        [titleView showTitleView];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LeafMeAlone" object:nil];
        CGPoint pinLocationBeforeZoom = view.center;

        [self.viewController zoomMaptoLatitude:[market.latitude floatValue]  longitude:[market.longitude floatValue] withLatitudeSpan:0.01 longitudeSpan:0.01];
        
        // If the map hasn't moved, show the product icons. (If it has, we still want to show them, but the regionDidChange method will notice the zooming and take care of displaying the icons.)
        if (view.center.x == pinLocationBeforeZoom.x && view.center.y == pinLocationBeforeZoom.y) {
            [self showProductsCircleForMarket:view];

        }
        
        // Cover mapView to prevent map interaction
        self.cover = [[UIView alloc] initWithFrame:self.viewController.view.frame];
        self.cover.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *onTapClear = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeCoverView:)];
        [self.cover addGestureRecognizer:onTapClear];
        [self.viewController.view addSubview:self.cover];
        // Bring forward the detail view and the annotation view with icons to allow interaction
        [self.viewController.view bringSubviewToFront:self.viewController.detailView];
        [self.viewController.view bringSubviewToFront:view];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCoverView:) name:@"SwiperNoSwiping" object:nil];
    }
}

-(void)removeCoverView:(UITapGestureRecognizer *)sender {
    [self.cover removeFromSuperview];
    [self.viewController.mapView deselectAnnotation:self.viewController.mapView.selectedAnnotations.firstObject animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SwiperNoSwiping" object:nil];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([Annotation isSubclassOfClass:annotation.class]  ) {
        Annotation *annie = (Annotation *)annotation;
        NSUInteger tag = annie.tag;
        
        FMLMarket *market = self.viewController.marketsArray[tag];
        
        
        MKAnnotationView *pepeLeView = [[MKAnnotationView alloc] initWithAnnotation:annie reuseIdentifier:@""];
        pepeLeView.enabled = YES;
        
        enum FMLMarketStatus status = [self currentStatusForMarket:market];
        switch (status) {
            case FMLMarketIsOpen:
                pepeLeView.image = [UIImage imageNamed:@"openPin"];
                break;
            case FMLMarketIsClosingSoon:
                pepeLeView.image = [UIImage imageNamed:@"closingSoonPin"];
                break;
            case FMLMarketIsClosed:
                pepeLeView.image = [UIImage imageNamed:@"closedPin"];
                break;
            case FMLMarketIsOutOfSeason:
                pepeLeView.image = [UIImage imageNamed:@"outOfSeason"];
                break;
            case FMLMarketHasNoInfo:
                pepeLeView.image = [UIImage imageNamed:@"pin"];
                break;
            default:
                break;
        }
        
        pepeLeView.canShowCallout = NO;
        return pepeLeView;
    }
    return nil;
}

// Animate icons' disappearance: become transparent, shrink, move back into the pin, and disappear.
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
    [self.viewController.detailView hideDetailView];
    [self.viewController.titleView hideTitleView];
    [UIView animateWithDuration:0.25 animations:^{
        self.viewController.mapView.transform = CGAffineTransformIdentity;
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VineAndDine" object:nil];
    [UIView animateWithDuration:self.animationSpeed animations:^{
        
        for (UIView *icon in self.currentProductsIcons) {
            // Transparency/alpha
            icon.alpha = 0;
            
            // Size and position
            icon.frame = CGRectZero;
        }
    } completion:^(BOOL finished) {
        for (UIView *icon in self.currentProductsIcons) {
            [icon removeFromSuperview];
        }
    }];
    
    self.selectedAnnotationView = nil;
    self.iconCircleExists = NO;
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    if (self.selectedAnnotationView && !self.iconCircleExists) {
        [self showProductsCircleForMarket:self.selectedAnnotationView];
    }
}


#pragma mark - Helper Methods

// Shoot out an icon for each product type available at a given Farmer's Market. The icons should radiate out to equidistant positions around a circle centered on the pin. The Assets folder contains an icon for each product category.
-(void)showProductsCircleForMarket:(MKAnnotationView *)annotationView {
    
    // Empty the current products icon array before adding the circle views
    self.currentProductsIcons = [@[] mutableCopy];
    
    // Get an array of the names of the icons we want. (Remove slashes because filenames can't have slashes.)
    Annotation *annotation = annotationView.annotation;
    NSMutableArray *iconsArray = [[[annotation.market.produceList stringByReplacingOccurrencesOfString:@"/" withString:@"" ] componentsSeparatedByString:@"; "] mutableCopy];
    
    // Number of degrees separating icons
    CGFloat degreesBetweenIcons = 360.0 / iconsArray.count;
    // Index (to multiply number of degrees by)
    NSUInteger index = 0;
    
    // Remove any empty strings from iconsArray, so we don't get blank circles. (Not doing this earlier to avoid a dividing-by-zero problem or having to use an if-statement.)
        [iconsArray removeObject:@""];
    
    // Make each icon appear at the center of the pin and animate out to its position.
    for (NSString *iconName in iconsArray) {
        
        // ~~~~~ ICONS: INITIAL STATE ~~~~~
        
        // Create a circle:
        // Make a view
        UIView *circleView = [[UIView alloc] init];
        circleView.translatesAutoresizingMaskIntoConstraints = NO;
        circleView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [annotationView addSubview:circleView];
        [self.currentProductsIcons addObject:circleView];
        // Position constraints: center the circle at the center of the pin view
        NSLayoutConstraint *circleCenterX = [NSLayoutConstraint constraintWithItem:circleView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:annotationView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *circleCenterY = [NSLayoutConstraint constraintWithItem:circleView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:annotationView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
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
        
        [self.viewController.view layoutSubviews];
        [circleView layoutIfNeeded];
        
        
        // ~~~~~ ICONS: FINAL STATE ~~~~~
        
        // Calculate number of degrees around the circle that the icon should be
        CGFloat degreesForIcon = degreesBetweenIcons * index;
        
        // Get the coordinates of that position
        CGPoint iconDestinationPosition = [self pointAroundCircumferenceFromCenter:annotationView.center withRadius:100 andAngle:degreesForIcon];
        
        // Animate the icon moving to its position in the circle.
        self.animationSpeed = 0.25;
        [UIView animateWithDuration:self.animationSpeed animations:^{
            
            // position (we move only the circle; the icon is constrained to it)
            circleCenterX.active = NO;
            circleCenterY.active = NO;
            NSLayoutConstraint *xPosition = [circleView.centerXAnchor constraintEqualToAnchor:self.viewController.view.leftAnchor constant:iconDestinationPosition.x];
            NSLayoutConstraint *yPosition = [circleView.centerYAnchor constraintEqualToAnchor:self.viewController.view.topAnchor constant:iconDestinationPosition.y];
            
            xPosition.active = YES;
            yPosition.active = YES;
            
            // alpha (opacity)
            iconView.alpha = 1;
            circleView.alpha = 1;
            
            // size
            // TODO: make the height and width a calculation based on the size of the view, so it works correctly regardless of device. Or perhaps as a multiple of the size of the pinview or something.
            circleHeight.constant = 45;
            circleWidth.constant = circleHeight.constant;
            // Corner radius to half of size makes it a circle
            circleView.layer.cornerRadius = 0.5 * circleHeight.constant;
            iconHeight.constant = circleHeight.constant * 0.75;
            iconWidth.constant = circleWidth.constant * 0.75;
            
            [self.viewController.view layoutIfNeeded];
            
        }];
        
        // Increment index
        index++;
        // Icon circle property
        self.iconCircleExists = YES;
    }
    
}



-(FMLMarketStatus)currentStatusForMarket:(FMLMarket *)market {
    NSString *dateString = market.season1Date;
    
    if (![dateString isEqualToString:@""]) {
        NSArray *dates = [dateString componentsSeparatedByString:@" to "];
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        
        NSDate *startDate = [formatter dateFromString:dates.firstObject];
        NSDate *endDate = [formatter dateFromString:dates.lastObject];
        NSDate *currentDate = [NSDate date];
        
        if ([self date:currentDate isBetweenDate:startDate andDate:endDate]) {
            
            
            
            NSString *timeString = [market.season1Time stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSArray *components = [timeString componentsSeparatedByString:@";"];
            
            for (NSString *schedule in components) {
                if (![schedule isEqualToString:@""]) {
                    NSString *dayOfWeek = [[schedule substringToIndex:3] capitalizedString];
                    NSDateFormatter *dayOfWeekFormat = [[NSDateFormatter alloc] init];
                    [dayOfWeekFormat setDateFormat:@"eee"];
                    NSString *today = [dayOfWeekFormat stringFromDate:[NSDate date]];
                    NSString *time = [schedule substringFromIndex:4];
                    NSArray *times = [time componentsSeparatedByString:@"-"];
                    
                    
                    if ([dayOfWeek isEqualToString:today]) {
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"HH:mma"];
                        
                        NSDate *startTime = [formatter dateFromString:times.firstObject];
                        NSDate *endTime = [formatter dateFromString:times.lastObject];
                        
                        // Redundant? Necessary?
                        NSString *nowTime = [formatter stringFromDate:currentDate];
                        NSDate *currentTime = [formatter dateFromString:nowTime];
                        
                        if ([self date:currentTime isBetweenDate:startTime andDate:endTime]) {
                            
                            NSDate *twoHoursFromNow = [currentTime dateByAddingTimeInterval:7200];
                            
                            if ([twoHoursFromNow compare:endTime] == NSOrderedDescending) {
                                return FMLMarketIsClosingSoon;
                            }
                            return FMLMarketIsOpen;
                        }
                    }
                }
            }
            return FMLMarketIsClosed;
        } else {
            return FMLMarketIsOutOfSeason;
        }
        
    }
    
    return FMLMarketHasNoInfo;

}

-(BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
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
