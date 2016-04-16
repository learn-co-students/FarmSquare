//
//  FMLTextFieldDelegate.h
//  FarmersMarketLocator
//
//  Created by Julia on 4/14/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FMLMapViewController.h"

@interface FMLTextFieldDelegate : NSObject <UITextFieldDelegate>

- (instancetype)initWithTarget:(FMLMapViewController *)target;

@end
