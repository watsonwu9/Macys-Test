//
//  PWAllStoresViewController.h
//  MacysTest
//
//  Created by Paul Wong on 5/13/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "PWSQLiteManager.h"

@interface PWAllStoresViewController : UITableViewController

/**
 the availables stores of this specific product will be having checkmarks enabled.
 */
@property (nonatomic) Product *product;

@end
