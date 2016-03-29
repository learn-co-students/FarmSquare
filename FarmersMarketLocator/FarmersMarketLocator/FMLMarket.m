//
//  FMLMarket.m
//  FarmersMarketLocator
//
//  Created by Slobodan Kovrlija on 3/29/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import "FMLMarket.h"

@implementation FMLMarket

-(instancetype)initWithNameString:(NSString *)nameString googleLink:(NSString *)googleLink {
    
    self = [super init];
    
    if (self) {
        
        // The name string always starts with the distance: e.g., "0.1 Blah Market." We want to confirm that the string begins with a digit, then remove the distance from the name before assigning to _name.
        // create character set for digits
        NSCharacterSet *decimalDigits = [NSCharacterSet decimalDigitCharacterSet];
        
        if([decimalDigits characterIsMember:[nameString characterAtIndex:0]] && [nameString containsString:@" "]) {
            
            NSUInteger indexOfSpace = [nameString rangeOfString:@" "].location;
            nameString = [nameString substringFromIndex:indexOfSpace + 1];
        }
        
        // The Google Maps link contains the latitude and longitude. Extract them so we can set their properties.
        
        
        
        // Set properties
        _name = nameString;
//        _latitude = ;
//        _longitude = ;
    }
    return self;
}

@end
