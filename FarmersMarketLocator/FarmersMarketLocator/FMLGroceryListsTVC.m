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
//    cell.textLabel.text = currentList.listName;
    
    return cell;
}

//- (IBAction)doneTapped:(id)sender {
//    
//    FMLGroceryList *addedList = [NSEntityDescription insertNewObjectForEntityForName:@"FMLGroceryList" inManagedObjectContext:self.stack.managedObjectContext];
//    addedList.listName = @"New grocery list";
//    
//    addedList.dateModified = [NSDate date];
//    
//    [self.stack saveContext];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"new list created" object:nil];
//    NSLog(@"does this get called at all..???");
//}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
if ([segue.identifier isEqualToString:@"viewList"]) {
        FMLGroceryTVC *destVC = segue.destinationViewController;
    
//        destinationTrivia.allTriviaForTappedLocation = selectedLocation.trivia;
        
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        FMLGroceryList *selectedGroceryList = self.stack.groceryLists[selectedIndexPath.row];
        destVC.groceryListToDisplay = selectedGroceryList;
        destVC.segueIsViewList = YES;
    }
}


@end
