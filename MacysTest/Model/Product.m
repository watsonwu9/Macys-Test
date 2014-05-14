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
        self.productPhoto = [self photoImage];
        self.productColors = productColors;
        self.productStores = productStores;
    }
    return self;
}

#pragma mark - Utilities

- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

#pragma mark - Public Methods

- (NSString *)photoPath {
    NSString *filename = [NSString stringWithFormat:@"Photo%d.png", self.productId];
    return [[self documentsDirectory] stringByAppendingPathComponent:filename];
}

+ (NSInteger)nextId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger nextProductId = [userDefaults integerForKey:@"NextId"];
    if (nextProductId == 0) {
        // Id should start from 1, not 0, just to be consistent with SQLite convention.
        nextProductId = 1;
    }
    [userDefaults setInteger:nextProductId+1 forKey:@"NextId"];
    [userDefaults synchronize];
    return nextProductId;
}

#pragma mark - Private Methods

- (UIImage *)photoImage {
    // Mock products have negative Ids, such as -1, -2 and -3.
    if (self.productId < 0) {
        // "MockProductPhoto1.png", "MockProductPhoto2.png" and "MockProductPhoto3.png"
        return [UIImage imageNamed:[NSString stringWithFormat:@"MockProductPhoto%d.png", (-1) * self.productId]];
    }
    else {
        return [UIImage imageWithContentsOfFile:[self photoPath]];
    }
}

@end
