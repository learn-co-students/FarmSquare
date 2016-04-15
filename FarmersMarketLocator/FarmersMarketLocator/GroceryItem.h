//
//  GroceryItem.h
//  GroceryList
//
//  Created by Slobodan Kovrlija on 4/12/16.
//  Copyright © 2016 Slobodan Kovrlija. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroceryItem : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *quantity;
@property (nonatomic) BOOL isChecked;


@end
