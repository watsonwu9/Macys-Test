//
//  PWCreateProductViewController.m
//  MacysTest
//
//  Created by Paul Wong on 5/11/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import "PWCreateProductViewController.h"

static const NSInteger PWCellImageViewProductPhotoTag = 1000;
static const NSInteger PWCellLabelProductNameTag = 2000;
static const NSInteger PWCellLabelProductRegularPriceTag = 3000;
static const NSInteger PWCellLabelProductSalePriceTag = 4000;

static const CGFloat PWCreateProductHUDDuration = 0.6f;

@interface PWCreateProductViewController ()

/**
 the list of mock products.
 */
@property (nonatomic) NSMutableArray *mockProducts;

@end

@implementation PWCreateProductViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register the tableview cell.
    UINib *nib = [UINib nibWithNibName:@"TableViewCellProduct" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TableViewCellProduct"];
    
    // Initialize "mockProducts".
    self.mockProducts = [[NSMutableArray alloc] init];
    
    // Load mock products from MockData(json).
    self.navigationItem.title = @"Create Product";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Load JsonData on background thread.
        [self loadMockJsonData];
        
        // Update tableview on main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    
    // Set up the left bar button item.
    UIBarButtonItem *barButtonItemCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = barButtonItemCancel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.mockProducts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // Keep the table view nice and clean.
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Product *mockProduct = [self.mockProducts objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TableViewCellProduct" forIndexPath:indexPath];
    
    UIImageView *imageViewProductPhoto = (UIImageView *)[cell viewWithTag:PWCellImageViewProductPhotoTag];
    UILabel *labelProductName = (UILabel *)[cell viewWithTag:PWCellLabelProductNameTag];
    UILabel *labelProductRegularPrice = (UILabel *)[cell viewWithTag:PWCellLabelProductRegularPriceTag];
    UILabel *labelProductSalePrice = (UILabel *)[cell viewWithTag:PWCellLabelProductSalePriceTag];
    
    imageViewProductPhoto.image = mockProduct.productPhoto;
    imageViewProductPhoto.contentMode = UIViewContentModeScaleAspectFit;
    
    labelProductName.text = mockProduct.productName;
    if (mockProduct.productRegularPrice > mockProduct.productSalePrice) {
        // Show a strikethrough effect if the sale price is lower.
        labelProductRegularPrice.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%.02f", mockProduct.productRegularPrice] attributes:[NSDictionary dictionaryWithObjectsAndKeys:@(NSUnderlineStyleSingle), NSStrikethroughStyleAttributeName , nil]];
        labelProductSalePrice.text = [NSString stringWithFormat:@"$%.02f", mockProduct.productSalePrice];
    }
    else {
        // If productSalePrice is no less than productRegularPrice, then only show the latter.
        labelProductRegularPrice.text = [NSString stringWithFormat:@"$%.02f", mockProduct.productRegularPrice];
        labelProductSalePrice.text = @"";
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // INSERT a row into the products table (create the product).
    Product *product = [self.mockProducts objectAtIndex:indexPath.row];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Load "products" on background thread.
        if (![[PWSQLiteManager sharedInstance] add:product]) {
            // Failed to create the product.
            DLog(@"Failed to create the product.");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Display "Created!" HUD.
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:HUD];
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark.png"]];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"Created!";
            [HUD show:YES];
            [HUD hide:YES afterDelay:PWCreateProductHUDDuration];
            
            // Close the screen right away when the HUD disappears.
            [self performSelector:@selector(closeScreen) withObject:self afterDelay:PWCreateProductHUDDuration];
        });
    });
}

#pragma mark - Utilities

- (void)loadMockJsonData {
    NSString *jsonDataPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MockData.json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonDataPath];
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    if (!jsonArray) {
        DLog(@"Error loading json data: %@", [error userInfo]);
    }
    else {
        for (NSDictionary *productInfo in jsonArray) {
            NSInteger productId = [[productInfo objectForKey:@"id"] intValue];
            NSString *productName = [productInfo objectForKey:@"name"];
            NSString *productDescription = [productInfo objectForKey:@"description"];
            CGFloat productRegularPrice = [[productInfo objectForKey:@"regular_price"] floatValue];
            CGFloat productSalePrice = [[productInfo objectForKey:@"sale_price"] floatValue];
            NSString *productPhotoName = [productInfo objectForKey:@"product_photo"];
            NSArray *productColors = [productInfo objectForKey:@"colors"];
            NSDictionary *productStores = [productInfo objectForKey:@"stores"];
            
            Product *product = [[Product alloc] initWithId:productId andName:productName andDescription:productDescription andRegularPrice:productRegularPrice andSalePrice:productSalePrice andPhotoName:productPhotoName andColors:productColors andStores:productStores];
            [self.mockProducts addObject:product];
        }
    }
}

#pragma mark - Private Methods

- (void)cancel {
    [self closeScreen];
}

- (void)closeScreen {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
