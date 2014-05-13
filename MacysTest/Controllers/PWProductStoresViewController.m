//
//  PWProductStoresViewController.m
//  MacysTest
//
//  Created by Paul Wong on 5/13/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import "PWProductStoresViewController.h"

static const NSInteger PWCellLabelStoreNameTag = 1000;

@interface PWProductStoresViewController ()

@end

@implementation PWProductStoresViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.stores = [[NSMutableArray alloc] init];
    
    self.navigationItem.title = @"Available Stores";
    
    // Register the tableview cell.
    UINib *nib = [UINib nibWithNibName:@"TableViewCellStore" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TableViewCellStore"];
    
    // Load stores in accordance with the storeIds.
    [self updateStoresAndTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Utilities

- (void)updateStoresAndTableView {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Load "products" on background thread.
        self.stores = [[PWSQLiteManager sharedInstance] fetchedStores:self.storeIds];
        
        // Update tableview on main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.stores.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // Keep the table view nice and clean.
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Store *store = [self.stores objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellStore" forIndexPath:indexPath];
    
    UILabel *labelStoreName = (UILabel *)[cell viewWithTag:PWCellLabelStoreNameTag];
    labelStoreName.text = store.storeName;
    
    return cell;
}

@end
