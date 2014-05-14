//
//  PWAllStoresViewController.m
//  MacysTest
//
//  Created by Paul Wong on 5/13/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import "PWAllStoresViewController.h"

static const NSInteger PWCellLabelStoreNameTag = 1000;

@interface PWAllStoresViewController ()

/**
 a list of all stores in the database.
 */
@property (nonatomic) NSMutableArray *allStores;

/**
 available store ids for the specific product
 */
@property (nonatomic) NSMutableArray *availableStoreIds;

@end

@implementation PWAllStoresViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.availableStoreIds = [[self.product.productStores objectForKey:@"available_store_id"] mutableCopy];
    
    self.navigationItem.title = @"All Stores";
    
    // Register the tableview cell.
    UINib *nib = [UINib nibWithNibName:@"TableViewCellStore" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TableViewCellStore"];
    
    // Load stores in accordance with the storeIds.
    self.allStores = [[NSMutableArray alloc] init];
    [self updateAllStoresAndTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utilities

- (void)updateAllStoresAndTableView {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Load "products" on background thread.
        self.allStores = [[PWSQLiteManager sharedInstance] fetchedAllStores];
        
        // Update tableview on main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (BOOL)isAvailable:(int)storeId {
    for (int i = 0; i < self.availableStoreIds.count; i++) {
        int thisStoreId = [[self.availableStoreIds objectAtIndex:i] intValue];
        if (thisStoreId == storeId) {
            return YES;
        }
    }
    return NO;
}

- (void)removeAvailableId:(int)storeId {
    for (int i = 0; i < self.availableStoreIds.count; i++) {
        int thisStoreId = [[self.availableStoreIds objectAtIndex:i] intValue];
        if (thisStoreId == storeId) {
            [self.availableStoreIds removeObjectAtIndex:i];
            break;
        }
    }
}

- (void)addAvailableId:(int)storeId {
    [self.availableStoreIds addObject:@(storeId)];
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
    return self.allStores.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // Keep the table view nice and clean.
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Store *store = [self.allStores objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellStore" forIndexPath:indexPath];
    
    UILabel *labelStoreName = (UILabel *)[cell viewWithTag:PWCellLabelStoreNameTag];
    labelStoreName.text = store.storeName;
    
    if ([self isAvailable:store.storeId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Store *store = [self.allStores objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self removeAvailableId:store.storeId];
        self.product.productStores = @{@"available_store_id" : self.availableStoreIds};
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self addAvailableId:store.storeId];
        self.product.productStores = @{@"available_store_id" : self.availableStoreIds};
    }
}

@end
