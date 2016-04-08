//
//  FMLGroceryItemTableViewCell.h
//  FarmersMarketLocator
//
//  Created by Slobodan Kovrlija on 4/7/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMLGroceryItemTableViewCell : UITableViewCell

@property (strong, nonatomic)UILabel *itemLabel;
@property (strong, nonatomic)UIButton *checkboxButton;

-(instancetype)initWithItemName:(NSString *)itemName checkboxButton:(UIButton *)checkboxButton;

@end
