//
//  PWProductPhotoViewController.h
//  MacysTest
//
//  Created by Paul Wong on 5/12/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface PWProductPhotoViewController : UIViewController

/**
 the product whose photo will be shown.
 */
@property (nonatomic) Product *product;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewProductPhoto;
@property (strong, nonatomic) IBOutlet UIButton *buttonExit;

@end
