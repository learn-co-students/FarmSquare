//
//  Annotation.m
//  FarmersMarketLocator
//
//  Created by Julia on 3/31/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle andTag:(NSUInteger)tag {
    self = [super init];
    if (self) {
        _coordinate = coordinate;
        _title = title;
        _subtitle = subtitle;
        _tag = tag;
    }
    return self;
}
    
    
@end
