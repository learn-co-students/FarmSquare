//
//  FMLGroceryListCellView.h
//  FarmersMarketLocator
//
//  Created by Slobodan Kovrlija on 4/17/16.
//  Copyright © 2016 Jeff Spingeld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMLGroceryList.h"
#import "CoreDataStack.h"

@interface FMLGroceryListCellView : UIView
@property (weak, nonatomic) IBOutlet UITextField *listName;
@property (weak, nonatomic) IBOutlet UILabel *dateModified;

@property (strong, nonatomic) IBOutlet UIView *contentViewListCell;

@property (strong, nonatomic)FMLGroceryList *list;

-(void)setGroceryList:(FMLGroceryList *)list;

@end
