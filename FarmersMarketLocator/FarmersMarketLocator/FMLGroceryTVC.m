//
//  FMLGroceryTVC.m
//  GroceryList
//
//  Created by Slobodan Kovrlija on 4/12/16.
//  Copyright © 2016 Slobodan Kovrlija. All rights reserved.
//

#import "FMLGroceryTVC.h"
#import "FMLGroceryCell.h"
#import "FMLNewItemViewController.h"
#import "FMLGroceryItem.h"
#import "CoreDataStack.h"
#import "FMLGroceryList.h"

@interface FMLGroceryTVC () <NewItemDelegate>

@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation FMLGroceryTVC



-(void)newItemViewControllerDismissed:(FMLGroceryItem *)newItem {
    
    NSLog(@"newItem is: %@", newItem.name);
    
    [self.items addObject:newItem];
    
    NSLog(@"items array's count is:  %lu", self.items.count);
    
    [self.tableView reloadData];
    
}


- (IBAction)doneButtonTapped:(id)sender {
    
    if (self.items.count > 0) {
        FMLGroceryList *addedList = [NSEntityDescription insertNewObjectForEntityForName:@"FMLGroceryList" inManagedObjectContext:self.stack.managedObjectContext];
        addedList.listName = @"New grocery list";
        addedList.dateModified = [NSDate date];
        
        //adding groceryItems to the new grocery list (its NSOrderedSet property)
        NSMutableOrderedSet *mutableItems = addedList.itemsInList.mutableCopy;
        
        for (NSUInteger i = 0; i < self.items.count; i++) {
            
            [mutableItems addObject:self.items[i]];
        }
        addedList.itemsInList = mutableItems.copy;
        
        [self.stack saveContext];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"new list created" object:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = [[NSMutableArray alloc]init];
    
    self.stack = [CoreDataStack sharedStack];
    
    self.tableView.separatorColor = [UIColor greenColor];
    
    //to allow left swipe delete of a cell
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"new item added" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self.tableView reloadData];
    }];
    
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
    }
    [super viewWillDisappear:animated];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //we need to delete the object from the array, but from core data so that the number of rows is updated with one less
//        [self.stack.managedObjectContext deleteObject:self.stack.groceryItems[indexPath.row]];

        // TODO: swipe delete breaks here
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //number of rows depending on whether we are displaying an already saved grocery list or the new list being created
    if (self.segueIsViewList) {
        return self.groceryListToDisplay.itemsInList.count;
    } else {
        return self.items.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FMLGroceryCell *cell = (FMLGroceryCell*)[tableView dequeueReusableCellWithIdentifier:@"groceryCell" forIndexPath:indexPath];
    
    //cell content can come from either a saved list (itemsInList property of FMLGroceryList) or from a new item view controller (saved in "items")
    if (self.segueIsViewList) {
        
        FMLGroceryItem *currentItem = self.groceryListToDisplay.itemsInList[indexPath.row];
        [cell.groceryView setGroceryItem:currentItem];
        return cell;
        
    } else {
        
    FMLGroceryItem *currentItem = self.items[indexPath.row];
    [cell.groceryView setGroceryItem:currentItem];
    return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"makeNewItem"]) {
        FMLNewItemViewController *destVC = segue.destinationViewController;
        destVC.delegate = self;
        self.segueIsViewList = NO; //so that the if statements above execute loading appropriate data
    }
}

@end
