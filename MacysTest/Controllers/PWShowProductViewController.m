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

@property (nonatomic) NSMutableArray *products;

@end

@implementation PWShowProductViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Register the tableview cell.
    UINib *nib = [UINib nibWithNibName:@"ProductCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ProductCell"];
    
    // Initialize "mockProducts".
    self.products = [[NSMutableArray alloc] init];
    
    // Load products from ProductDB.sql
    self.navigationItem.title = @"All Products";
    
    [self updateProductsAndTableView];
}

- (void)updateProductsAndTableView {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Load "products" on background thread.
        self.products = [[PWSQLiteManager sharedInstance] fetchedProducts];
        
        // Update tableview on main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Product *product = [self.products objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ProductCell" forIndexPath:indexPath];
    
    UIImageView *imageViewProductPhoto = (UIImageView *)[cell viewWithTag:PWCellImageViewProductPhotoTag];
    UILabel *labelProductName = (UILabel *)[cell viewWithTag:PWCellLabelProductNameTag];
    UILabel *labelProductRegularPrice = (UILabel *)[cell viewWithTag:PWCellLabelProductRegularPriceTag];
    UILabel *labelProductSalePrice = (UILabel *)[cell viewWithTag:PWCellLabelProductSalePriceTag];
    
    imageViewProductPhoto.image = product.productPhoto;
    imageViewProductPhoto.contentMode = UIViewContentModeScaleAspectFit;
    
    labelProductName.text = product.productName;
    if (product.productRegularPrice > product.productSalePrice) {
        // Show a strikethrough effect if the sale price is lower.
        labelProductRegularPrice.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Reg. $%.02f", product.productRegularPrice] attributes:[NSDictionary dictionaryWithObjectsAndKeys:@(NSUnderlineStyleSingle), NSStrikethroughStyleAttributeName , nil]];
        labelProductSalePrice.text = [NSString stringWithFormat:@"Sale $%.02f", product.productSalePrice];
    }
    else {
        // If productSalePrice is no less than productRegularPrice, then only show the latter.
        labelProductRegularPrice.text = [NSString stringWithFormat:@"$%.02f", product.productRegularPrice];
        labelProductSalePrice.text = @"";
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Product *product = [self.products objectAtIndex:indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        // [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[PWSQLiteManager sharedInstance] remove:product];
        [self updateProductsAndTableView];
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
