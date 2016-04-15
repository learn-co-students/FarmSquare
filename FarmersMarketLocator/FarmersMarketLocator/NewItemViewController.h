//
//  NewItemViewController.h
//  GroceryList
//
//  Created by Slobodan Kovrlija on 4/13/16.
//  Copyright © 2016 Slobodan Kovrlija. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CoreDataStack.h"

@interface NewItemViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *itemQuantTextField;
@property (weak, nonatomic) IBOutlet UITextField *itemNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

//@property (strong, nonatomic) GroceryItem *addedGroceryItem;

@property (strong, nonatomic) CoreDataStack *stack;

@end

