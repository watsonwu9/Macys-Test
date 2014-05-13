//
//  PWProductStoresViewController.h
//  MacysTest
//
//  Created by Paul Wong on 5/13/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWSQLiteManager.h"

@interface PWProductStoresViewController : UITableViewController

/**
 the list of store ids.
 */
@property (nonatomic) NSMutableArray *storeIds;

/**
 the list of stores to be shown.
 */
@property (nonatomic) NSMutableArray *stores;

@end
