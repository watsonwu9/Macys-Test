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

@property (nonatomic) NSMutableArray *storeIds;
@property (nonatomic) NSMutableArray *stores;

@end
