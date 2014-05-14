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
    }
    
    // Load the image into imageview.
    self.imageViewProductPhoto.image = self.product.productPhoto;
    self.imageViewProductPhoto.contentMode = UIViewContentModeScaleAspectFit;
    
    UIBarButtonItem *barButtonItemFullScreen = [[UIBarButtonItem alloc] initWithTitle:@"Full Screen" style:UIBarButtonItemStylePlain target:self action:@selector(toggleFullScreen)];
    self.navigationItem.rightBarButtonItem = barButtonItemFullScreen;
    
    [self.buttonExit addTarget:self action:@selector(toggleFullScreen) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Utilities

- (void)toggleFullScreen {
    if (self.navigationController.navigationBar.alpha == 0.0) {
        // fade in navigation
        
        [UIView animateWithDuration:0.4 animations:^{
            [[UIApplication sharedApplication] setStatusBarHidden:FALSE withAnimation:UIStatusBarAnimationNone];
            self.navigationController.navigationBar.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }
    else {
        // fade out navigation
        
        [UIView animateWithDuration:0.4 animations:^{
            [[UIApplication sharedApplication] setStatusBarHidden:TRUE withAnimation:UIStatusBarAnimationFade];
            self.navigationController.navigationBar.alpha = 0.0;
        } completion:^(BOOL finished) {
        }];
    }
}

@end
