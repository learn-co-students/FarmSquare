//
//  FMLNewItemViewController.h
//  GroceryList
//
//  Created by Slobodan Kovrlija on 4/13/16.
//  Copyright © 2016 Slobodan Kovrlija. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMLGroceryItem2.h"
#import "CoreDataStack.h"

@protocol NewItemDelegate <NSObject>

-(void)newItemViewControllerDismissed:(FMLGroceryItem2 *)newItem;

@end

@interface FMLNewItemViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *itemQuantTextField;
@property (weak, nonatomic) IBOutlet UITextField *itemNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) id <NewItemDelegate> delegate;

//@property (strong, nonatomic) GroceryItem *addedGroceryItem;

@property (strong, nonatomic) CoreDataStack *stack;

@end

