//
//  PWHomeViewController.m
//  MacysTest
//
//  Created by Paul Wong on 5/11/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import "PWHomeViewController.h"

@implementation PWHomeViewController

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IB Actions

- (IBAction)createProduct:(id)sender {
    PWCreateProductViewController *viewControllerCreateProduct = [[PWCreateProductViewController alloc] initWithNibName:@"PWCreateProductViewController" bundle:nil];
    [self.navigationController pushViewController:viewControllerCreateProduct animated:YES];
}

- (IBAction)showProduct:(id)sender {
    PWShowProductViewController *viewControllerShowProduct = [[PWShowProductViewController alloc] initWithNibName:@"PWShowProductViewController" bundle:nil];
    [self.navigationController pushViewController:viewControllerShowProduct animated:YES];
}

@end
