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

@end
