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

//if its in code
//-(instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self commonInit];
//    }
//    return self;
//}

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
    NSLog(@"ARE YOU GETTING CALLED!!!!");
    self.item = item;
    self.groceryName.text = self.item.name;
    self.numberOfItemsNeeded.text = [NSString stringWithFormat:@"%@", self.item.quantity];
    if (!self.item.isChecked) {
        [self.checkbox setImage:[UIImage imageNamed:@"uncheckedButton"] forState:UIControlStateNormal];
    } else {
        [self.checkbox setImage:[UIImage imageNamed:@"checkedButton"] forState:UIControlStateSelected];
    }
    
}

//-(UIButton *)setUpCheckboxButton {
//    
//    UIButton *checkbox = [[UIButton alloc]init];
//    
//    [checkbox setImage:[UIImage imageNamed:] forState:UIControlStateNormal];
//    [checkbox setImage:[UIImage imageNamed:@"checkedButton"] forState:UIControlStateSelected];
//    
//    [checkbox addTarget:self action:@selector(checkUncheck) forControlEvents:UIControlEventTouchUpInside];
//    
//    return checkbox;
//}
//
//-(void)checkUncheck {
//    
//    
//}


@end
