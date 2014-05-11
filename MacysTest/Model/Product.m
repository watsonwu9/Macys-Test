//
//  Product.m
//  MacysTest
//
//  Created by Paul Wong on 5/11/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import "Product.h"

@implementation Product

- (id)initWithId:(NSInteger)productId andName:(NSString *)productName andDescription:(NSString *)productDescription andRegularPrice:(CGFloat)productRegularPrice andSalePrice:(CGFloat)productSalePrice andColors:(NSArray *)productColors andStores:(NSDictionary *)productStores {
    self = [super init];
    if (self) {
        self.productId = productId;
        self.productName = productName;
        self.productDescription = productDescription;
        self.productRegularPrice = productRegularPrice;
        self.productSalePrice = productSalePrice;
        self.productPhoto = [self originalPhotoImage];
        self.productColors = productColors;
        self.productStores = productStores;
    }
    return self;
}

- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (NSString *)originalPhotoPath
{
    NSString *filename = [NSString stringWithFormat:@"OriginalPhoto-%d.png", self.productId];
    return [[self documentsDirectory] stringByAppendingPathComponent:filename];
}

- (UIImage *)originalPhotoImage
{
    return [UIImage imageWithContentsOfFile:[self originalPhotoPath]];
}

- (NSString *)thumbPhotoPath
{
    NSString *filename = [NSString stringWithFormat:@"ThumbPhoto-%d.png", self.productId];
    return [[self documentsDirectory] stringByAppendingPathComponent:filename];
}

- (UIImage *)thumbPhotoImage
{
    return [UIImage imageWithContentsOfFile:[self thumbPhotoPath]];
}

@end
