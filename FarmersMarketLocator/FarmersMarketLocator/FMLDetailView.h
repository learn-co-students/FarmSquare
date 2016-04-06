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

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UITextView *produceTextView;
@property (strong, nonatomic) UILabel *scheduleLabel;
@property (strong, nonatomic) UIButton *arrowDownButton;
@property (strong, nonatomic) UIButton *arrowUpButton;
@property (strong, nonatomic) UIButton *yelpButton;
@property (strong, nonatomic) UIButton *directionsButton;
@property (assign, nonatomic) MKCoordinateRegion previousRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) CGFloat selectedLatitude;
@property (assign, nonatomic) CGFloat selectedLongitude;

-(void)constrainViews;
-(void)showDetailView;
-(void)hideDetailView;

@end
