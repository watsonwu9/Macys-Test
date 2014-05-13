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
    
    // Load the image into a webview instead of an imageview since the webview automatically enables the user to zoom in or zoom out on the image if scalePageToFit is turned on.
    // The part width=\"960\" comes from my personal experiment. It works like charm. (It turns out that setting width=100% does not work very well for me...)
    NSString *imagePath = [[self.product photoPath] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    imagePath = [NSString stringWithFormat:@"file://%@", imagePath];
    NSString* htmlString = [NSString stringWithFormat:
                                @"<html>"
                                "<body>"
                                "<img src=\"%@\" width=\"960\"/>"
                                "</body></html>", imagePath];
    self.webViewProductPhoto.scalesPageToFit = YES;
    [self.webViewProductPhoto loadHTMLString:htmlString baseURL:nil];
    
    UIBarButtonItem *barButtonItemFullScreen = [[UIBarButtonItem alloc] initWithTitle:@"Full Screen" style:UIBarButtonItemStylePlain target:self action:@selector(toggleFullScreen)];
    self.navigationItem.rightBarButtonItem = barButtonItemFullScreen;
    
    UIBarButtonItem *barButtonItemClose = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeScreen)];
    self.navigationItem.leftBarButtonItem = barButtonItemClose;
    
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

- (void)closeScreen {
    // Clear the webview's cache.
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    self.webViewProductPhoto = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
