//
//  FMLDetailView.h
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/1/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FMLDetailView : UIView

@property (strong, nonatomic) UITextView *produceTextView;
@property (strong, nonatomic) UILabel *scheduleLabel;
@property (strong, nonatomic) UIButton *yelpButton;
@property (strong, nonatomic) UIButton *directionsButton;
@property (assign, nonatomic) MKCoordinateRegion previousRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) CGFloat selectedLatitude;
@property (assign, nonatomic) CGFloat selectedLongitude;
@property (weak, nonatomic) NSString *zip;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIView *border;

-(void)constrainViews;
-(void)showDetailView;
-(void)hideDetailView;

@end
