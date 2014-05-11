//
//  Product.h
//  MacysTest
//
//  Created by Paul Wong on 5/11/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic) NSInteger productId;
@property (nonatomic) NSString *productName;
@property (nonatomic) NSString *productDescription;
@property (nonatomic) CGFloat productRegularPrice;
@property (nonatomic) CGFloat productSalePrice;
@property (nonatomic) UIImage *productPhoto;
@property (nonatomic) NSArray *productColors;
@property (nonatomic) NSDictionary *productStores;

@end
