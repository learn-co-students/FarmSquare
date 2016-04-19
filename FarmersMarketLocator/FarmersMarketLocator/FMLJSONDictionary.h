//
//  FMLJSONDictionary.h
//  FarmersMarketLocator
//
//  Created by Magfurul Abeer on 4/4/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMLJSONDictionary : NSObject

+(NSDictionary *)dictionaryForMarketWithId:(NSString *)fmid;

@end
