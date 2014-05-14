//
//  PWUpdateProductViewController.h
//  MacysTest
//
//  Created by Paul Wong on 5/13/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "PWSQLiteManager.h"
#import "MBProgressHUD.h"
#import "PWAllStoresViewController.h"

@interface PWUpdateProductViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

/**
 the product whose details are to be updated.
 */
@property (nonatomic) Product *product;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewProductPhoto;
@property (strong, nonatomic) IBOutlet UITextField *textFieldProductRegularPrice;
@property (strong, nonatomic) IBOutlet UITextField *textFieldProductSalePrice;
@property (strong, nonatomic) IBOutlet UITextField *textFieldProductName;
@property (strong, nonatomic) IBOutlet UITextField *textFieldProductColors;
@property (strong, nonatomic) IBOutlet UITextView *textViewProductDescription;

@end
