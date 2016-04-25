//
//  FMLMapViewController.h
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 3/31/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMLDetailView.h"

@class FMLTitleView;

@interface FMLMapViewController : UIViewController

@property (strong, nonatomic) FMLDetailView *detailView;
@property(strong, nonatomic) UILabel *nameLabel;
@property(strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) NSArray *marketsArray;
@property (assign, nonatomic) BOOL showingSavedData;
@property (strong, nonatomic) UIButton *moveToLocationButton;
@property (strong, nonatomic) UIButton *redoSearchInMapAreaButton;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) FMLTitleView *titleView;


-(void)zoomMaptoLatitude:(CGFloat)latitude longitude:(CGFloat)longitude withLatitudeSpan:(CGFloat)latitudeSpan longitudeSpan:(CGFloat)longitudeSpan;

@end
