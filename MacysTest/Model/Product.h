//
//  Product.h
//  MacysTest
//
//  Created by Paul Wong on 5/11/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

/**
 the id of the product.
 */
@property (nonatomic) NSInteger productId;

/**
 the name of the product.
 */
@property (nonatomic) NSString *productName;

/**
 the description of the product.
 */
@property (nonatomic) NSString *productDescription;

/**
 the regular price of the product.
 */
@property (nonatomic) CGFloat productRegularPrice;

/**
 the sale price of the product.
 */
@property (nonatomic) CGFloat productSalePrice;

/**
 the photo of the product.
 */
@property (nonatomic) UIImage *productPhoto;

/**
 the colors of the product.
 */
@property (nonatomic) NSArray *productColors;

/**
 the stores of the product.
 */
@property (nonatomic) NSDictionary *productStores;

/**
 @params productId the id for the product.
 @params productName the name for the product.
 @params productDescription the description for the product.
 @params productRegularPrice the regular price for the product.
 @params productSalePrice the sale price for the product.
 @params productPhotoName the related photo name for the product, if it exists.
 @params productColors the available colors for the product.
 @params productStores the availbale stores for the product.
 @returns an instance of the Product.
 */
- (id)initWithId:(NSInteger)productId andName:(NSString *)productName andDescription:(NSString *)productDescription andRegularPrice:(CGFloat)productRegularPrice andSalePrice:(CGFloat)productSalePrice  andPhotoName:(NSString *)productPhotoName andColors:(NSArray *)productColors andStores:(NSDictionary *)productStores;

/**
 @returns the related photo path for the product.
 */
- (NSString *)photoPath;

/**
 @returns the next available id for the product to be created.
 */
+ (NSInteger)nextId;

@end
