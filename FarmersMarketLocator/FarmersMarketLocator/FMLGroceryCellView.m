//
//  FMLGroceryCellView.m
//  GroceryList
//
//  Created by Slobodan Kovrlija on 4/12/16.
//  Copyright © 2016 Slobodan Kovrlija. All rights reserved.
//

#import "FMLGroceryCellView.h"

@implementation FMLGroceryCellView


//if someone tries to make his view in Storyboard
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self commonInit];
    }
    return self;
    
}

- (void)commonInit {
    
    [[NSBundle mainBundle] loadNibNamed:@"FMLGroceryCellView"
                                  owner:self
                                options:nil];
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.contentView];
    
    [self.contentView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.contentView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.contentView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    
}


- (void)setGroceryItem:(FMLGroceryItem *)item {
    
    self.item = item;
    self.groceryName.text = item.name;
    self.numberOfItemsNeeded.text = [NSString stringWithFormat:@"%@", self.item.quantity];
    
    //default state for checkbox is unchecked
    self.item.isChecked = @0;  //isChecked is NSNumber
    [self.checkbox setImage:[UIImage imageNamed:@"uncheckedButton"] forState:UIControlStateNormal];
    
}

- (IBAction)checkboxTapped:(id)sender {
    
        if ([self.item.isChecked isEqual: @0]) {
        
        [self.checkbox setImage:[UIImage imageNamed:@"checkedButton"] forState:UIControlStateNormal];
        self.item.isChecked = @1;
            
    } else {
        [self.checkbox setImage:[UIImage imageNamed:@"uncheckedButton"] forState:UIControlStateNormal];
        self.item.isChecked = @0;
    }
}

@end
