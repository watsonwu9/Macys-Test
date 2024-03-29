//
//  PWProductDetailViewController.m
//  MacysTest
//
//  Created by Paul Wong on 5/12/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import "PWProductDetailViewController.h"

static const NSInteger PWCellLabelProductRegularPriceTag = 1001;
static const NSInteger PWCellLabelProductSalePriceTag = 1002;
static const NSInteger PWCellViewProductFirstColorTag = 2001;
static const NSInteger PWCellViewProductSecondColorTag = 2002;
static const NSInteger PWCellViewProductThirdColorTag = 2003;
static const NSInteger PWCellViewProductFourthColorTag = 2004;
static const NSInteger PWCellViewProductFifthColorTag = 2005;
static const NSInteger PWCellLabelProductDescriptionTag = 3001;

static const CGFloat PWDeleteProductHUDDuration = 0.6f;

@interface PWProductDetailViewController ()

@end

@implementation PWProductDetailViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the interface.
    self.navigationItem.title = @"Product";
    
    // Add "Update" and "Delete" button to the right of navigation bar.
    UIBarButtonItem *barButtonItemDelete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteThisProduct)];
    UIBarButtonItem *barButtonItemUpdate = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(updateThisProduct)];
    self.navigationItem.rightBarButtonItems = @[barButtonItemDelete, barButtonItemUpdate];
    
    self.scrollViewBackground.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundTexture"]];

    self.imageViewProductPhoto.image = self.product.productPhoto;
    self.imageViewProductPhoto.contentMode = UIViewContentModeScaleAspectFit;
    self.imageViewProductPhoto.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGestureRecognizer.delegate = self;
    [self.imageViewProductPhoto addGestureRecognizer:tapGestureRecognizer];

    // It is hard to adjust the frame of product name label when I compromise auto-layout for better interests. Therefore, the only way is to progammatically create UILabel.
    UILabel *labelProductName;
    if (!IS_IOS_7) {
        labelProductName = [[UILabel alloc] initWithFrame:CGRectMake(20, 168, 280, 42)];
    }
    else {
        labelProductName = [[UILabel alloc] initWithFrame:CGRectMake(20, 252, 280, 42)];
    }
    labelProductName.backgroundColor = [UIColor clearColor];
    labelProductName.numberOfLines = 2;
    labelProductName.textAlignment = NSTextAlignmentCenter;
    labelProductName.text = self.product.productName;
    [self.view addSubview:labelProductName];
    [self.view bringSubviewToFront:labelProductName];
    
    self.tableViewProductDetails.delegate = self;
    self.tableViewProductDetails.dataSource = self;
    self.tableViewProductDetails.layer.borderColor = [UIColor darkGrayColor].CGColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *tableViewCells = [[NSBundle mainBundle] loadNibNamed:@"TableViewCellProductDetail" owner:self options:kNilOptions];
    UITableViewCell *cell = [tableViewCells objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        // "Price"
        UILabel *labelProductRegularPrice = (UILabel *)[cell viewWithTag:PWCellLabelProductRegularPriceTag];
        UILabel *labelProductSalePrice = (UILabel *)[cell viewWithTag:PWCellLabelProductSalePriceTag];
        
        if (self.product.productRegularPrice > self.product.productSalePrice) {
            // Show a strikethrough effect if the sale price is lower.
            labelProductRegularPrice.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%.02f", self.product.productRegularPrice] attributes:[NSDictionary dictionaryWithObjectsAndKeys:@(NSUnderlineStyleSingle), NSStrikethroughStyleAttributeName , nil]];
            labelProductSalePrice.text = [NSString stringWithFormat:@"$%.02f", self.product.productSalePrice];
        }
        else {
            // If productSalePrice is no less than productRegularPrice, then only show the latter.
            labelProductRegularPrice.text = [NSString stringWithFormat:@"$%.02f", self.product.productRegularPrice];
            labelProductSalePrice.text = @"";
        }
    }
    else if (indexPath.row == 1) {
        // "Colors"
        [self setupProductColorsOnCell:cell];
    }
    else if (indexPath.row == 2) {
        // "Description"
        UILabel *labelProductDescription = (UILabel *)[cell viewWithTag:PWCellLabelProductDescriptionTag];
        
        // Adjust frame for iOS 6.x version.
        if (!IS_IOS_7) {
            labelProductDescription.frame = CGRectMake(101, 6, 180, 32);
            labelProductDescription.font = [UIFont fontWithName:@"Helvetica" size:8.0f];
        }
        
        labelProductDescription.text = self.product.productDescription;
    }
    else if (indexPath.row == 3) {
        // "Available Stores"
        // No need to set up anything extra for this cell.
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 3) {
        // Show available stores if the user taps on this "Available Store" cell.
        [self showAvailableStores];
    }
}

#pragma mark - Private Methods

- (void)handleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    // Show full-size product photo.
    PWProductPhotoViewController *productPhotoViewController = [[PWProductPhotoViewController alloc] initWithNibName:@"PWProductPhotoViewController" bundle:nil];
    productPhotoViewController.product = self.product;
    [self.navigationController pushViewController:productPhotoViewController animated:YES];
}

- (void)updateThisProduct {
    PWUpdateProductViewController *updateProductViewController = [[PWUpdateProductViewController alloc] initWithNibName:@"PWUpdateProductViewController" bundle:nil];
    updateProductViewController.product = self.product;
    [self.navigationController pushViewController:updateProductViewController animated:YES];
}

- (void)deleteThisProduct {
    // Show deletion confirmation first.
    UIActionSheet *actionSheetDeletionConfirmation = [[UIActionSheet alloc] initWithTitle:@"Are you sure to delete this product?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
    [actionSheetDeletionConfirmation showInView:self.view];
}

- (void)showAvailableStores {
    PWProductStoresViewController *productStoresViewController = [[PWProductStoresViewController alloc] initWithNibName:@"PWProductStoresViewController" bundle:nil];
    productStoresViewController.storeIds = [[self.product.productStores objectForKey:@"available_store_id"] mutableCopy];
    [self.navigationController pushViewController:productStoresViewController animated:YES];
}

#pragma mark - Utilities

- (void)setupProductColorsOnCell:(UITableViewCell *)cell {
    UIView *viewProductFirstColor = [cell viewWithTag:PWCellViewProductFirstColorTag];
    UIView *viewProductSecondColor = [cell viewWithTag:PWCellViewProductSecondColorTag];
    UIView *viewProductThirdColor = [cell viewWithTag:PWCellViewProductThirdColorTag];
    UIView *viewProductFourthColor = [cell viewWithTag:PWCellViewProductFourthColorTag];
    UIView *viewProductFifthColor = [cell viewWithTag:PWCellViewProductFifthColorTag];
    NSArray *viewsProductColors = @[viewProductFirstColor, viewProductSecondColor, viewProductThirdColor, viewProductFourthColor, viewProductFifthColor];

    NSInteger numberOfColors = self.product.productColors.count;
    for (UIView *view in viewsProductColors) {
        if ([viewsProductColors indexOfObject:view] < numberOfColors) {
            view.hidden = NO;
            NSString *trimmedColorString = [[self.product.productColors objectAtIndex:[viewsProductColors indexOfObject:view]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            view.backgroundColor = [trimmedColorString representedColor];
        }
        else {
            view.hidden = YES;
        }
    }
}

- (void)closeScreen {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // Delete this product. Yes, go ahead.
        if ([[PWSQLiteManager sharedInstance] remove:self.product]) {
            // Display "Deleted!" HUD.
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:HUD];
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark.png"]];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"Deleted!";
            [HUD show:YES];
            [HUD hide:YES afterDelay:PWDeleteProductHUDDuration];
            
            // Close the screen right away when the HUD disappears.
            [self performSelector:@selector(closeScreen) withObject:self afterDelay:PWDeleteProductHUDDuration];
        }
        else {
            DLog(@"Failed to delete the product.");
        }
    }
    else if (buttonIndex == 1) {
        // Cancel.
        // Do nothing then.
    }
}

@end
