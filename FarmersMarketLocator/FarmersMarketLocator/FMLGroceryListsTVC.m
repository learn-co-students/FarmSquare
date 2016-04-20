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


@end
