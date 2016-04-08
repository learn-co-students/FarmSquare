//
//  FMLGroceryItemTableViewCell.m
//  FarmersMarketLocator
//
//  Created by Slobodan Kovrlija on 4/7/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import "FMLGroceryItemTableViewCell.h"
#import "FMLCreateNewListViewController.h"

@implementation FMLGroceryItemTableViewCell

-(instancetype)initWithItemName:(NSString *)itemName checkboxButton:(UIButton *)checkboxButton {
    
    self = [super init];
    if (self) {
        _itemLabel = [self setUpLabelWithText:itemName textColor:[UIColor blackColor]];
        _checkboxButton = checkboxButton;
    }
    return self;
}

-(UILabel *)setUpLabelWithText:(NSString *)text textColor:(UIColor *)color {
    
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.font = [UIFont fontWithName:@"Helvetica" size:16];
    label.textColor = color;
    label.numberOfLines = 0;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    return label;
}

-(UIButton *)setUpCheckboxButton {
    
    UIButton *button = [[UIButton alloc]init];
    
    [button setImage:@"uncheckedButton" forState:UIControlStateNormal];
    [button setImage:@"checkedButton" forState:UIControlStateSelected];
    
    return button;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
