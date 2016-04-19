//
//  FMLPinAnnotationView.m
//  FarmersMarketLocator
//
//  Created by Jeff Spingeld on 4/5/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import "FMLPinAnnotationView.h"

@implementation FMLPinAnnotationView

-(instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    return self;
    
}

@end
