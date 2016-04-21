//
//  FMLGroceryCell.h
//  GroceryList
//
//  Created by Slobodan Kovrlija on 4/12/16.
//  Copyright © 2016 Slobodan Kovrlija. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMLGroceryCellView.h"

@interface FMLGroceryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet FMLGroceryCellView *groceryView;

@end
