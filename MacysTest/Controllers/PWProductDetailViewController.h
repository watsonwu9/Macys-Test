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

/**
 the product whose details are to be shown.
 */
@property (nonatomic) Product *product;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewBackground;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewProductPhoto;

@property (strong, nonatomic) IBOutlet UITableView *tableViewProductDetails;

@end
