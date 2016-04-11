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

typedef NS_ENUM(NSInteger, FMLMarketStatus) {
    FMLMarketHasNoInfo          = -1,
    FMLMarketIsOutOfSeason      = 0, 
    FMLMarketIsOpen             = 1,
    FMLMarketIsClosingSoon      = 2,
    FMLMarketIsClosed           = 3
};

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
        //to use in maps URL for directions:
        detailView.selectedLatitude = [market.latitude floatValue];
        detailView.selectedLongitude = [market.longitude floatValue];
        
        if (mapView.region.span.longitudeDelta != detailView.previousRegion.span.longitudeDelta) {
            detailView.previousRegion = mapView.region;
        }
        
        [self.viewController zoomMaptoLatitude:[market.latitude floatValue]  longitude:[market.longitude floatValue] withLatitudeSpan:0.01 longitudeSpan:0.01];
        
        [detailView showDetailView];
        
        NSLog(@"%@", market.season1Time);
    }
    
   
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
        
//        NSDate *date = [NSDate date]
//        if ([dateString isEqualToString:@""]) {
//            pepeLeView.image = [UIImage imageNamed:@"closingSoonPin"];
//        } else {
////            NSD
//            pepeLeView.image = [UIImage imageNamed:@"openPin"];
//
//        }
        
        pepeLeView.canShowCallout = YES;
        return pepeLeView;
    }
    return nil;
    
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [self.viewController.detailView hideDetailView];
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
            
            NSDate *closingTime;
            
            
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

@end
