//
//  FMLMarket.m
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/1/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import "FMLMarket.h"



@implementation FMLMarket

-(NSString *)nameFromString:(NSString *)name {
    // The name string from the API always starts with the distance: e.g., "0.1 Blah Market."
    // After confirming that the string begins with a digit, we want to remove the distance before assigning _name.
    NSString *nameString = name;
    NSCharacterSet *decimalDigits = [NSCharacterSet decimalDigitCharacterSet];
    if([decimalDigits characterIsMember:[nameString characterAtIndex:0]] && [nameString containsString:@" "]) {
        
        NSUInteger indexOfSpace = [nameString rangeOfString:@" "].location;
        nameString = [nameString substringFromIndex:indexOfSpace + 1];
    }
    return nameString;
}

@end
