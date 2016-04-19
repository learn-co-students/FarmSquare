//
//  FMLGroceryTVC.h
//  GroceryList
//
//  Created by Slobodan Kovrlija on 4/12/16.
//  Copyright © 2016 Slobodan Kovrlija. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataStack.h"

@interface FMLGroceryTVC : UITableViewController

@property(strong, nonatomic)CoreDataStack *stack;
@property (strong, nonatomic)NSString *name;
@property (strong, nonatomic)NSString *quantity;
@property (nonatomic)BOOL isChecked;

@property (nonatomic, strong)FMLGroceryList *groceryListToDisplay;

//BOOL property to distinguish for cells what to show when viewing a saved grocery list
@property (nonatomic) BOOL segueIsViewList;



@end
