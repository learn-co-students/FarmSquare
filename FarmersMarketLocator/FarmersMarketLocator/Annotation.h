//
//  Annotation.h
//  FarmersMarketLocator
//
//  Created by Julia on 3/31/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>

@property(assign, nonatomic) CLLocationCoordinate2D coordinate;
@property(copy, nonatomic) NSString *title;
@property(copy, nonatomic) NSString *subtitle;
@property (assign, nonatomic) NSUInteger tag;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle andTag:(NSUInteger)tag;

@end
