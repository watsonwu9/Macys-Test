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

@property (nonatomic) Product *product;

// Webview to display the product photo (built-in multiple gestures!).
@property (strong, nonatomic) IBOutlet UIWebView *webViewProductPhoto;
@property (strong, nonatomic) IBOutlet UIButton *buttonExit;

@end
