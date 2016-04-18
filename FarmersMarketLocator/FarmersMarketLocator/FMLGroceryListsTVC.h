//
//  FMLGroceryListsTVC.h
//  FarmersMarketLocator
//
//  Created by Slobodan Kovrlija on 4/7/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataStack.h"

@interface FMLGroceryListsTVC : UITableViewController

@property(strong, nonatomic)CoreDataStack *stack;

@end
