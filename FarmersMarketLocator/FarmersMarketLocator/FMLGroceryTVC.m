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
#import "FMLGroceryItem2.h"
#import "CoreDataStack.h"

@interface FMLGroceryTVC () <NewItemDelegate>

@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation FMLGroceryTVC



-(void)newItemViewControllerDismissed:(FMLGroceryItem2 *)newItem {
    
    NSLog(@"newItem is: %@", newItem.name);
    
    [self.items addObject:newItem];
    
    NSLog(@"items array's count is:  %lu", self.items.count);
    
    [self.tableView reloadData];
    
}


- (IBAction)doneButtonTapped:(id)sender {
    FMLGroceryList *addedList = [NSEntityDescription insertNewObjectForEntityForName:@"FMLGroceryList" inManagedObjectContext:self.stack.managedObjectContext];
    addedList.listName = @"New grocery list";
    
    addedList.dateModified = [NSDate date];
    
    [self.stack saveContext];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"new list created" object:nil];
    
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
        [self.stack.managedObjectContext deleteObject:self.stack.groceryItems[indexPath.row]];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
    //NSLog(@"self.items.count is %lu", self.items.count);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FMLGroceryCell *cell = (FMLGroceryCell*)[tableView dequeueReusableCellWithIdentifier:@"groceryCell" forIndexPath:indexPath];
    
    FMLGroceryItem2 *currentItem = self.items[indexPath.row];
    
    [cell.groceryView setGroceryItem:currentItem];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"makeNewItem"]) {
        FMLNewItemViewController *destVC = segue.destinationViewController;
        destVC.delegate = self;
    }
}




/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
