//
//  PWUpdateProductViewController.m
//  MacysTest
//
//  Created by Paul Wong on 5/13/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import "PWUpdateProductViewController.h"

static const CGFloat PWUpdateProductHUDDuration = 0.6f;

@interface PWUpdateProductViewController ()

@property (nonatomic) UIImagePickerController *imagePicker;

@end

@implementation PWUpdateProductViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Update Info";
    
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
    
}

- (void)handleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self showPhotoMenu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)cancel {
    
    [self closeScreen];
}

- (void)closeScreen {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save {
    self.product.productPhoto = self.imageViewProductPhoto.image;
    self.product.productRegularPrice = [self.textFieldProductRegularPrice.text floatValue];
    self.product.productSalePrice = [self.textFieldProductSalePrice.text floatValue];
    self.product.productName = [self.textFieldProductName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.product.productColors = [[self.textFieldProductColors.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsSeparatedByString:@","];
    self.product.productDescription = [self.textViewProductDescription.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    // self.product.productStores = ...
    
    // UPDATE this product in the products table.
    if ([[PWSQLiteManager sharedInstance] update:self.product]) {
        // Display "Updated!" HUD.
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark.png"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"Updated!";
        [HUD show:YES];
        [HUD hide:YES afterDelay:PWUpdateProductHUDDuration];
        
        // Close the screen right away when the HUD disappears.
        [self performSelector:@selector(popToHomeScreen) withObject:self afterDelay:PWUpdateProductHUDDuration];
    }
    else {
        NSLog(@"Failed to update the product.");
    }
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

@end
