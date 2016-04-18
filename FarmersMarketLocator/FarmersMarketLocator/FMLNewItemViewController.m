//
//  FMLNewItemViewController.m
//  GroceryList
//
//  Created by Slobodan Kovrlija on 4/13/16.
//  Copyright © 2016 Slobodan Kovrlija. All rights reserved.
//

#import "FMLNewItemViewController.h"


@interface FMLNewItemViewController ()

@end

@implementation FMLNewItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.stack = [CoreDataStack sharedStack];
}


- (IBAction)saveTapped:(id)sender {
    NSLog(@"saveTapped!");
    
    NSString *itemName = self.itemNameTextField.text;
    NSString *itemQuantity = self.itemQuantTextField.text;
    
    FMLGroceryItem2 *addedItem = [FMLGroceryItem2 new];
//    FMLGroceryItem *addedItem = (FMLGroceryItem *)[NSEntityDescription insertNewObjectForEntityForName:@"FMLGroceryItem" inManagedObjectContext:self.stack.managedObjectContext];
    addedItem.name = itemName;
    addedItem.quantity = itemQuantity;
    
    
    //[self.stack saveContext];
    
    [self.delegate newItemViewControllerDismissed:addedItem];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"new item added" object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
