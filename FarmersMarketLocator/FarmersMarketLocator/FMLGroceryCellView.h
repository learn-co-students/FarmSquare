//
//  FMLGroceryCellView.h
//  GroceryList
//
//  Created by Slobodan Kovrlija on 4/12/16.
//  Copyright © 2016 Slobodan Kovrlija. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMLGroceryItem2.h"

@interface FMLGroceryCellView : UIView

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *groceryName;
@property (weak, nonatomic) IBOutlet UILabel *numberOfItemsNeeded;
@property (weak, nonatomic) IBOutlet UIButton *checkbox;


@property (nonatomic, strong) FMLGroceryItem2 *item;

- (void)setGroceryItem:(FMLGroceryItem2 *)item;


@end
