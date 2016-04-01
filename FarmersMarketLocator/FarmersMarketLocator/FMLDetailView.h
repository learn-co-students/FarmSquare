//
//  FMLDetailView.h
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/1/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface FMLDetailView : UIView

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UIButton *arrowButton;
@property (assign, nonatomic) MKCoordinateRegion previousRegion;

-(void)constrainViews;
-(void)showDetailView;
-(void)hideDetailView;

@end
