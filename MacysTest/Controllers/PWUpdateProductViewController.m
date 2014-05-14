//
//  PWUpdateProductViewController.m
//  MacysTest
//
//  Created by Paul Wong on 5/13/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import "PWUpdateProductViewController.h"

@interface PWUpdateProductViewController ()

/**
 This image picker is used for updating the photo of the product.
 */
@property (nonatomic) UIImagePickerController *imagePicker;

@end

@implementation PWUpdateProductViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void)cancel {
    // Available stores might have been changed for this specific product object (product of the same memory address is passed along the subsequent screens). Therefore it would be better to just go back to home screen.
    [self popToHomeScreen];
}

- (void)save {
    // Hide the keyboard.
    [self.view endEditing:YES];
    
    self.product.productPhoto = self.imageViewProductPhoto.image;
    self.product.productRegularPrice = [self.textFieldProductRegularPrice.text floatValue];
    self.product.productSalePrice = [self.textFieldProductSalePrice.text floatValue];
    self.product.productName = [self.textFieldProductName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.product.productColors = [[self.textFieldProductColors.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsSeparatedByString:@","];
    self.product.productDescription = [self.textViewProductDescription.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    // self.product.productStores is updated on "PWAllStoresViewController" screen.
    
    // Show "Updating..." HUD.
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Updating...";
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // UPDATE this product in the products table.
        if (![[PWSQLiteManager sharedInstance] update:self.product]) {
            DLog(@"Failed to update the product.");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            [self popToHomeScreen];
        });
    });
}

#pragma mark - Utilities

- (void)handleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self showPhotoMenu];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (void)popToHomeScreen {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)showPhotoMenu {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Take Photo 📷", @"Choose From Library 🌌", nil];
        [actionSheet showInView:self.view];
        
    } else {
        [self choosePhotoFromLibrary];
    }
}

- (void)takePhoto
{
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = NO;
    [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)choosePhotoFromLibrary
{
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = NO;
    
    [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)setupUI {
    self.navigationItem.title = @"Update Product";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundTexture"]];
    
    // Set up "Cancel" and "Save" buttons.
    UIBarButtonItem *barButtonItemCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    UIBarButtonItem *barButtonItemSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    self.navigationItem.leftBarButtonItem = barButtonItemCancel;
    self.navigationItem.rightBarButtonItem = barButtonItemSave;
    
    // Set up imageViewProductPhoto and associate the tap gesture recognizer with it.
    self.imageViewProductPhoto.image = self.product.productPhoto;
    self.imageViewProductPhoto.contentMode = UIViewContentModeScaleAspectFit;
    self.imageViewProductPhoto.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.imageViewProductPhoto addGestureRecognizer:tapGestureRecognizer];
    
    // Set up the interface (textfields and textviews).
    self.textFieldProductRegularPrice.text = [NSString stringWithFormat:@"%.02f", self.product.productRegularPrice];
    self.textFieldProductSalePrice.text = [NSString stringWithFormat:@"%.02f", self.product.productSalePrice];
    self.textFieldProductName.text = self.product.productName;
    self.textFieldProductColors.text = [self.product.productColors componentsJoinedByString:@","];
    self.textViewProductDescription.text = self.product.productDescription;
    
    self.textFieldProductRegularPrice.layer.cornerRadius = 4.0f;
    self.textFieldProductRegularPrice.layer.borderWidth = 1.0f;
    self.textFieldProductRegularPrice.layer.borderColor = [UIColor lightTextColor].CGColor;
    
    self.textFieldProductSalePrice.layer.cornerRadius = 4.0f;
    self.textFieldProductSalePrice.layer.borderWidth = 1.0f;
    self.textFieldProductSalePrice.layer.borderColor = [UIColor lightTextColor].CGColor;
    
    self.textFieldProductName.layer.cornerRadius = 4.0f;
    self.textFieldProductName.layer.borderWidth = 1.0f;
    self.textFieldProductName.layer.borderColor = [UIColor lightTextColor].CGColor;
    
    self.textFieldProductColors.layer.cornerRadius = 5.0f;
    self.textFieldProductColors.layer.borderWidth = 1.0f;
    self.textFieldProductColors.layer.borderColor = [UIColor lightTextColor].CGColor;
    
    self.textViewProductDescription.layer.cornerRadius = 5.0f;
    self.textViewProductDescription.layer.borderWidth = 1.0f;
    self.textViewProductDescription.layer.borderColor = [UIColor lightTextColor].CGColor;
    
    // Associate a tap gesture recognizer to the main view (for hiding keyboard).
    UITapGestureRecognizer *tapGestureRecognizerHideKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGestureRecognizerHideKeyboard];
    
    // Adjust frames for iOS 6.x version.
    if (!IS_IOS_7) {
        for (UIView *subview in self.view.subviews) {
            CGRect frame = subview.frame;
            subview.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame) - 64, CGRectGetWidth(frame), CGRectGetHeight(frame));
        }
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // Take photo.
        [self takePhoto];
    }
    else if (buttonIndex == 1) {
        // Choose photo from library.
        [self choosePhotoFromLibrary];
    }
    else if (buttonIndex == 2) {
        // "Cancel"
        return;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageViewProductPhoto.image = image;
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IB Actions

- (IBAction)showAvailableStores:(id)sender {
    PWAllStoresViewController *allStoresViewController = [[PWAllStoresViewController alloc] initWithNibName:@"PWProductStoresViewController" bundle:nil];
    allStoresViewController.product = self.product;
    [self.navigationController pushViewController:allStoresViewController animated:YES];
}


@end
