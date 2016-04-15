//
//  GroceryTVC.h
//  GroceryList
//
//  Created by Slobodan Kovrlija on 4/12/16.
//  Copyright © 2016 Slobodan Kovrlija. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataStack.h"

@interface GroceryTVC : UITableViewController

@property(strong, nonatomic)CoreDataStack *stack;

@end
