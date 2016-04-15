//
//  GroceryCell.h
//  GroceryList
//
//  Created by Slobodan Kovrlija on 4/12/16.
//  Copyright © 2016 Slobodan Kovrlija. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroceryCellView.h"

@interface GroceryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet GroceryCellView *groceryView;

@end
