//
//  PWProductDetailViewController.h
//  MacysTest
//
//  Created by Paul Wong on 5/12/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "NSString+Color.h"
#import "PWProductPhotoViewController.h"
#import "PWProductStoresViewController.h"
#import "PWUpdateProductViewController.h"
#import "MBProgressHUD.h"

@interface PWProductDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate>

// The details of this product are to be displayed.
@property (nonatomic) Product *product;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewBackground;
@property (strong, nonatomic) IBOutlet UILabel *labelProductName;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewProductPhoto;
@property (strong, nonatomic) IBOutlet UITableView *tableViewProductDetails;

@end
