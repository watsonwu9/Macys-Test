//
//  PWProductPhotoViewController.m
//  MacysTest
//
//  Created by Paul Wong on 5/12/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import "PWProductPhotoViewController.h"

@implementation PWProductPhotoViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.navigationItem.title = @"Photo";
    
    // Adjust for iPhone 3.5-inch (iPhone4 or previous, but not iPhone5 or iPhone5S).
    if (IPHONE4 || IPAD) {
        DLog(@"iphone 3.5-inch or on ipad");
        self.imageViewProductPhoto.frame = CGRectMake(0, 64, 320, 416);
        // Adjust for iOS 6.x version.
        if (!IS_IOS_7) {
            self.imageViewProductPhoto.frame = CGRectMake(0, 10, 320, 416);
        }
    }
    
    // Load the image into imageview.
    self.imageViewProductPhoto.image = self.product.productPhoto;
    self.imageViewProductPhoto.contentMode = UIViewContentModeScaleAspectFit;
    
    UIBarButtonItem *barButtonItemAction = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showMoreOptions)];
    self.navigationItem.rightBarButtonItem = barButtonItemAction;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void)showMoreOptions {
    NSArray *activityItems = @[self.product.productPhoto];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

@end
