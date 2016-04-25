//
//  FMLLocationManagerDelegate.m
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/1/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import "FMLLocationManagerDelegate.h"
#import <UIKit/UIKit.h>
#import "SampleZipCodes.h"
#import "GeocodeLocation.h"


@interface FMLLocationManagerDelegate()

@property (strong, nonatomic) FMLMapViewController *viewController;

@end

@implementation FMLLocationManagerDelegate

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

#pragma mark - CLLocationManager Delegate Methods

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        CLLocationCoordinate2D coordinates = manager.location.coordinate;
        [self.viewController zoomMaptoLatitude:coordinates.latitude longitude:coordinates.longitude withLatitudeSpan:0.05 longitudeSpan:0.05];
        if (!self.viewController.showingSavedData) {
            [self saveUserCoordinates:coordinates];
        }
    }
    
    if (status == kCLAuthorizationStatusDenied) {
        self.viewController.moveToLocationButton.enabled = NO;
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"zipCodeSaved"]) {
            CGFloat latitude = [[NSUserDefaults standardUserDefaults] floatForKey:@"latitude"];
            CGFloat longitude = [[NSUserDefaults standardUserDefaults] floatForKey:@"longitude"];
            
            [self.viewController zoomMaptoLatitude:latitude longitude:longitude withLatitudeSpan:0.05 longitudeSpan:0.05];
            if (!self.viewController.showingSavedData) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GotUserCoordinates" object:nil];
            }
            
            
        } else {
            [self displayLocationAlert];
        }
    }

}



#pragma mark - Helper Methods 

-(void)displayLocationAlert {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Please enter your location" message:@"Ex: 123 Rockaway Ave, Brooklyn or Brooklyn, NY" preferredStyle:UIAlertControllerStyleAlert];
    
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    
    UIAlertAction *enter = [UIAlertAction actionWithTitle:@"Enter" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *input = controller.textFields.firstObject.text;
        
        [GeocodeLocation getCoordinateForLocation:input withCompletion:^(CLLocationCoordinate2D coordinate) {
            [self saveUserCoordinates:coordinate];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"zipCodeSaved"];
            
            // Zoom into it
            [self.viewController zoomMaptoLatitude:coordinate.latitude longitude:coordinate.longitude withLatitudeSpan:0.05 longitudeSpan:0.05];
            
            
        }];
        
    }];
    
    [controller addAction:enter];
    
    [self.viewController presentViewController:controller animated:YES completion:nil];
    
}

-(void)saveUserCoordinates:(CLLocationCoordinate2D)coordinates {
    [[NSUserDefaults standardUserDefaults] setFloat:coordinates.latitude forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setFloat:coordinates.longitude forKey:@"longitude"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"GotUserCoordinates" object:nil];
}

@end
