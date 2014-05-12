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

- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (NSString *)originalPhotoPath {
    if (self.productId < 0) {
        // Mock products' Ids are negative, for example, -1, -2 and -3
        // "MockProductPhoto1.png", "MockProductPhoto2.png" and so on...
        return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"MockProductPhoto%d.png", (-1) * self.productId]];
    }
    else {
        NSString *filename = [NSString stringWithFormat:@"OriginalPhoto%d.png", self.productId];
        return [[self documentsDirectory] stringByAppendingPathComponent:filename];
    }
}

- (UIImage *)originalPhotoImage {
    return [UIImage imageWithContentsOfFile:[self originalPhotoPath]];
}

+ (NSInteger)nextId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger nextProductId = [userDefaults integerForKey:@"NextId"];
    if (nextProductId == 0) {
        // Id should start from 1, not 0, according to SQLite convention.
        nextProductId = 1;
    }
    [userDefaults setInteger:nextProductId+1 forKey:@"NextId"];
    [userDefaults synchronize];
    return nextProductId;
}

@end
