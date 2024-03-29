//
//  PWShowProductViewController.m
//  MacysTest
//
//  Created by Paul Wong on 5/11/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import "PWShowProductViewController.h"

static const NSInteger PWCellImageViewProductPhotoTag = 1000;
static const NSInteger PWCellLabelProductNameTag = 2000;
static const NSInteger PWCellLabelProductRegularPriceTag = 3000;
static const NSInteger PWCellLabelProductSalePriceTag = 4000;

@interface PWShowProductViewController ()

/**
 the list of products.
 */
@property (nonatomic) NSMutableArray *products;

@end

@implementation PWShowProductViewController

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Initialize "mockProducts".
    self.products = [[NSMutableArray alloc] init];
    
    // Load products from MacysDB.sql
    [self updateProductsAndTableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"All Products";
    
    // Register the tableview cell.
    UINib *nib = [UINib nibWithNibName:@"TableViewCellProduct" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TableViewCellProduct"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    return self.products.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // Keep the table view nice and clean.
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Product *product = [self.products objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TableViewCellProduct" forIndexPath:indexPath];
    
    UIImageView *imageViewProductPhoto = (UIImageView *)[cell viewWithTag:PWCellImageViewProductPhotoTag];
    UILabel *labelProductName = (UILabel *)[cell viewWithTag:PWCellLabelProductNameTag];
    UILabel *labelProductRegularPrice = (UILabel *)[cell viewWithTag:PWCellLabelProductRegularPriceTag];
    UILabel *labelProductSalePrice = (UILabel *)[cell viewWithTag:PWCellLabelProductSalePriceTag];
    
    imageViewProductPhoto.image = product.productPhoto;
    imageViewProductPhoto.contentMode = UIViewContentModeScaleAspectFit;
    
    labelProductName.text = product.productName;
    if (product.productRegularPrice > product.productSalePrice) {
        // Show a strikethrough effect if the sale price is lower.
        labelProductRegularPrice.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%.02f", product.productRegularPrice] attributes:[NSDictionary dictionaryWithObjectsAndKeys:@(NSUnderlineStyleSingle), NSStrikethroughStyleAttributeName , nil]];
        labelProductSalePrice.text = [NSString stringWithFormat:@"$%.02f", product.productSalePrice];
    }
    else {
        // If productSalePrice is no less than productRegularPrice, then only show the latter.
        labelProductRegularPrice.text = [NSString stringWithFormat:@"$%.02f", product.productRegularPrice];
        labelProductSalePrice.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Product *product = [self.products objectAtIndex:indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the product.
        [[PWSQLiteManager sharedInstance] remove:product];
        [self updateProductsAndTableView];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PWProductDetailViewController *productDetailViewController = [[PWProductDetailViewController alloc] initWithNibName:@"PWProductDetailViewController" bundle:nil];
    productDetailViewController.product = [self.products objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:productDetailViewController animated:YES];
}

#pragma mark - Utilities

- (void)updateProductsAndTableView {
    // Show "Loading..." HUD.
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Load "products" on background thread.
        self.products = [[PWSQLiteManager sharedInstance] fetchedAllProducts];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            [self.tableView reloadData];
        });
    });
}

@end
