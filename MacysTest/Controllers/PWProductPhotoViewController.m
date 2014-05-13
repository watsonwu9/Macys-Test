//
//  PWProductPhotoViewController.m
//  MacysTest
//
//  Created by Paul Wong on 5/12/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import "PWProductPhotoViewController.h"

@interface PWProductPhotoViewController ()

@end

@implementation PWProductPhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.navigationItem.title = @"Photo";
    
    NSData *imageData = [NSData dataWithContentsOfFile:[self.product photoPath]];
    [self.webViewProductPhoto loadData:imageData MIMEType:@"image/png" textEncodingName:nil baseURL:nil];
    self.webViewProductPhoto.scalesPageToFit = YES;
    
    UIBarButtonItem *barButtonItemFullScreen = [[UIBarButtonItem alloc] initWithTitle:@"Full Screen" style:UIBarButtonItemStylePlain target:self action:@selector(toggleFullScreen)];
    self.navigationItem.rightBarButtonItem = barButtonItemFullScreen;
    
    [self.buttonExit addTarget:self action:@selector(toggleFullScreen) forControlEvents:UIControlEventTouchUpInside];
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end