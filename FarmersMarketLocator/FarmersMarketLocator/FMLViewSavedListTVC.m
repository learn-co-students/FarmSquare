//
//  FMLViewSavedListTVC.m
//  FarmersMarketLocator
//
//  Created by Slobodan Kovrlija on 4/21/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import "FMLViewSavedListTVC.h"
#import "FMLGroceryCell.h"


@interface FMLViewSavedListTVC ()

@end

@implementation FMLViewSavedListTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.stack = [CoreDataStack sharedStack];
    
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideTheLeaf" object:nil];

}



-(void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowTheLeaf" object:nil];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.groceryListToView.itemsInList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FMLGroceryCell *cell = (FMLGroceryCell*)[tableView dequeueReusableCellWithIdentifier:@"groceryCell" forIndexPath:indexPath];
    
    FMLGroceryItem *currentItem = self.groceryListToView.itemsInList[indexPath.row];
    [cell.groceryView setGroceryItem:currentItem];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        FMLGroceryItem *itemToDelete = self.groceryListToView.itemsInList[indexPath.row];
        
        //we need to delete the object from core data
        [self.stack.managedObjectContext deleteObject:itemToDelete];
        
        [self.stack saveContext];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}




@end
