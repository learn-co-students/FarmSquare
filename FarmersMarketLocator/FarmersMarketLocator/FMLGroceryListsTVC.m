//
//  FMLGroceryListsTVC.m
//  FarmersMarketLocator
//
//  Created by Slobodan Kovrlija on 4/7/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import "FMLGroceryListsTVC.h"
#import "FMLGroceryListCell.h"
#import "FMLGroceryList.h"
#import "FMLGroceryTVC.h"

@interface FMLGroceryListsTVC ()

@end

@implementation FMLGroceryListsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.stack = [CoreDataStack sharedStack];
    
    //to allow left swipe delete of a cell
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"new list created" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self.tableView reloadData];
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.stack.groceryLists.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FMLGroceryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    
    FMLGroceryList *currentList = self.stack.groceryLists[indexPath.row];
    
    [cell.groceryListView setGroceryList:currentList];
    
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
if ([segue.identifier isEqualToString:@"viewList"]) {
        FMLGroceryTVC *destVC = segue.destinationViewController;
        
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        FMLGroceryList *selectedGroceryList = self.stack.groceryLists[selectedIndexPath.row];
        destVC.groceryListToDisplay = selectedGroceryList;
        destVC.segueIsViewList = YES;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //we need to delete the object from the array, but from core data so that the number of rows is updated with one less
        [self.stack.managedObjectContext deleteObject:self.stack.groceryLists[indexPath.row]];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [tableView reloadData];
    }
}



@end
