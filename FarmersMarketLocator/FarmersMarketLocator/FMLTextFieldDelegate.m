//
//  FMLTextFieldDelegate.m
//  FarmersMarketLocator
//
//  Created by Julia on 4/14/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import "FMLTextFieldDelegate.h"
#import "FMLSearch.h"

@interface FMLTextFieldDelegate ()

@property (strong, nonatomic) FMLMapViewController *viewController;

@end

@implementation FMLTextFieldDelegate

- (instancetype)init
{
    self = [self initWithTarget:nil];
    return self;
}

- (instancetype)initWithTarget:(FMLMapViewController *)target
{
    self = [super init];
    if (self) {
        _viewController = target;
    }
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Hide search filters" object:nil];
    //and set new coordinates
    [FMLSearch searchForNewLocation:textField.text];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Show search filters" object:nil];
}

@end
