//
//  FMLMapViewController.h
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 3/31/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMLMapViewController : UIViewController

@property(strong, nonatomic) UIView *detailView;
@property(strong, nonatomic) UILabel *nameLabel;
@property(strong, nonatomic) UILabel *addressLabel;

-(void)zoomMaptoLatitude:(CGFloat)latitude longitude:(CGFloat)longitude withLatitudeSpan:(CGFloat)latitudeSpan longitudeSpan:(CGFloat)longitudeSpan;

@end
