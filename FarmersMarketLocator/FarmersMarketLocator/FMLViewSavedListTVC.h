//
//  FMLViewSavedListTVC.h
//  FarmersMarketLocator
//
//  Created by Slobodan Kovrlija on 4/21/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMLGroceryList.h"
#import "CoreDataStack.h"

@interface FMLViewSavedListTVC : UITableViewController

@property (nonatomic, strong)FMLGroceryList *groceryListToView;
@property (nonatomic, strong)CoreDataStack *stack;

@end
