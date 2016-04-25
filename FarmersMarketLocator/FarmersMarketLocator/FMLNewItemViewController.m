//
//  FMLNewItemViewController.m
//  GroceryList
//
//  Created by Slobodan Kovrlija on 4/13/16.
//  Copyright © 2016 Slobodan Kovrlija. All rights reserved.
//

#import "FMLNewItemViewController.h"
#import "FMLNewItemView.h"

@interface FMLNewItemViewController ()
@property (weak, nonatomic) IBOutlet FMLNewItemView *yellowView;

@end

@implementation FMLNewItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.stack = [CoreDataStack sharedStack];
    self.yellowView.layer.cornerRadius = 15;
}


- (IBAction)saveTapped:(id)sender {
    
    NSString *itemName = self.itemNameTextField.text;
    NSString *itemQuantity = self.itemQuantTextField.text;
    
    FMLGroceryItem *addedItem = (FMLGroceryItem *)[NSEntityDescription insertNewObjectForEntityForName:@"FMLGroceryItem" inManagedObjectContext:self.stack.managedObjectContext];
    addedItem.name = itemName;
    addedItem.quantity = itemQuantity;
    
    [self.stack saveContext];
    
    [self.delegate newItemViewControllerDismissed:addedItem];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"new item added" object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
