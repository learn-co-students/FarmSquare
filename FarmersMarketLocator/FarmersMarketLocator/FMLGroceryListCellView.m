//
//  FMLGroceryListCellView.m
//  FarmersMarketLocator
//
//  Created by Slobodan Kovrlija on 4/17/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import "FMLGroceryListCellView.h"

@interface FMLGroceryListCellView ()

@end

@implementation FMLGroceryListCellView

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self commonInit];
    }
    return self;
    
}

- (void)commonInit {
    
    [[NSBundle mainBundle] loadNibNamed:@"FMLGroceryListCellView"
                                  owner:self
                                options:nil];
    
    self.contentViewListCell.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.contentViewListCell];
    
    [self.contentViewListCell.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.contentViewListCell.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.contentViewListCell.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.contentViewListCell.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    
}

-(void)setGroceryList:(FMLGroceryList *)list {
    
    self.list = list;
    //self.listName.text = list.listName;
    
    //converting NSDate to NSString to display on the text label
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm:ss a"];
    NSString *stringFromDate = [dateFormatter stringFromDate:list.dateModified];
    self.dateModified.text = stringFromDate;
    
}

@end
