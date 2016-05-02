//
//  FMLJSONDictionary.m
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/4/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import "FMLJSONDictionary.h"

@implementation FMLJSONDictionary

+(NSArray *)jsonData {

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"farmers-markets" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSArray *marketData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return marketData;
}

+(NSArray *)jsonDataForKey:(NSString *)key {
    
    NSString *resourceName = [NSString stringWithFormat:@"farmers-markets-%@", key];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:resourceName withExtension:@"json"];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSArray *marketData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    return marketData;
}

+(NSDictionary *)dictionaryForMarketWithId:(NSString *)fmid {

    // Last number is the key
    NSString *key = [fmid substringFromIndex:(fmid.length - 1)];
    
    
    NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"FMID == %@", fmid];
    
    NSArray *filteredArray = [[FMLJSONDictionary jsonDataForKey:key] filteredArrayUsingPredicate:idPredicate];
    
    
    if (filteredArray.count > 1) {
        NSLog(@"more than 1 market with the id: %@", fmid);
    } else if (filteredArray.count == 0) {
        NSLog(@"no market with the id: %@", fmid);
    } else {
        NSDictionary *data = (NSDictionary *)filteredArray.firstObject;
        return data;
    }
    
    
    return nil;
}


@end
