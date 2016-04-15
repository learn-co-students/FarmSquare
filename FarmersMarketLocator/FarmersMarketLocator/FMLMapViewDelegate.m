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

//
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    self.selectedAnnotationView = view;
    
    if ([Annotation isSubclassOfClass:view.annotation.class]  ) {
        
        Annotation *annotation = (Annotation *)view.annotation;
        FMLMarket *market = self.viewController.marketsArray[ annotation.tag ];
        FMLDetailView *detailView = self.viewController.detailView;
        
        detailView.nameLabel.text = market.name.uppercaseString;
        detailView.addressLabel.text = [NSString stringWithFormat:@"ADDRESS: %@", market.address];
        detailView.produceTextView.text = [NSString stringWithFormat:@"AVAILABLE PRODUCE: %@", market.produceList];
        detailView.scheduleLabel.text = [NSString stringWithFormat:@"SCHEDULE: %@", market.scheduleString];
        
        //to use in yelp URL:
        detailView.zip = market.zipCode;
        
        //to use in maps URL for directions:
        detailView.selectedLatitude = [market.latitude floatValue];
        detailView.selectedLongitude = [market.longitude floatValue];
        
        [detailView showDetailView];
        
        if (mapView.region.span.longitudeDelta != detailView.previousRegion.span.longitudeDelta) {
            detailView.previousRegion = mapView.region;
        }
        
        CGPoint pinLocationBeforeZoom = view.center;
        
        [self.viewController zoomMaptoLatitude:[market.latitude floatValue]  longitude:[market.longitude floatValue] withLatitudeSpan:0.01 longitudeSpan:0.01];
        
        if (view.center.x == pinLocationBeforeZoom.x && view.center.y == pinLocationBeforeZoom.y) {
            [self showProductsCircleForMarket:view];

        }
                
        UIView *cover = [[UIView alloc] initWithFrame:self.viewController.view.frame];
        cover.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *onTapClear = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeCoverView:)];
        [cover addGestureRecognizer:onTapClear];
        [self.viewController.view addSubview:cover];
        
        [self.viewController.view bringSubviewToFront:self.viewController.detailView];
        
    }
}

-(void)removeCoverView:(UITapGestureRecognizer *)sender {
    [sender.view removeFromSuperview];
    [self.viewController.mapView deselectAnnotation:self.viewController.mapView.selectedAnnotations.firstObject animated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([Annotation isSubclassOfClass:annotation.class]  ) {
        Annotation *annie = (Annotation *)annotation;
        NSUInteger tag = annie.tag;
        
        FMLMarket *market = self.viewController.marketsArray[tag];
        
        
        MKAnnotationView *pepeLeView = [[MKAnnotationView alloc] initWithAnnotation:annie reuseIdentifier:@""];
        pepeLeView.enabled = YES;
        
        FMLMarketStatus status = [self currentStatusForMarket:market];
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

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
    [self.viewController.detailView hideDetailView];
    
    // Animation of icons' disappearance: become transparent, shrink, move back into the pin.
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
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    
    if (self.selectedAnnotationView) {

        [self showProductsCircleForMarket:self.selectedAnnotationView];
        
    }
}


#pragma mark - Helper Methods

-(void)showProductsCircleForMarket:(MKAnnotationView *)annotationView {
    
    // Empty the current products icon array before adding the circle views
    self.currentProductsIcons = [@[] mutableCopy];
    
    // Get an array of the names of the icons we want. (Remove slashes because filenames can't have slashes.)
    Annotation *annotation = annotationView.annotation;
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
        // Corner radius to half of size makes it a circle
        circleView.layer.cornerRadius = 15;
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
        CGPoint iconDestinationPosition = [self pointAroundCircumferenceFromCenter:annotationView.center withRadius:50 andAngle:degreesForIcon];
        
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
            circleHeight.constant = 30;
            circleWidth.constant = 30;
            iconHeight.constant = 15;
            iconWidth.constant = 15;
            
            [self.viewController.view layoutIfNeeded];
            
        }];
        
        // Increment index
        index++;
        
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
