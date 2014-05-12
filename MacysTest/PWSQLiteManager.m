//
//  PWSQLiteManager.m
//  MacysTest
//
//  Created by Paul Wong on 5/11/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import "PWSQLiteManager.h"

@interface PWSQLiteManager()

@property (nonatomic) NSString *databaseName;
@property (nonatomic) NSString *databasePath;

@end

@implementation PWSQLiteManager

+ (id)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)checkAndCreateDatabase {
    self.databaseName = @"ProductDB.sql";
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    self.databasePath = [documentsDir stringByAppendingPathComponent:self.databaseName];
    
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:self.databasePath];
    NSLog(@"Success: %d", success);
    
    // If the database already exists, then do nothing more
    if (success) {
        return;
    }
    else {
        // If not, then copy the database from the application
        NSError *error;
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseName];
        if (![fileManager copyItemAtPath:databasePathFromApp toPath:self.databasePath error:&error]) {
            // Handle error
            NSLog(@"Copying error: %@", [error userInfo]);
        }
    }
}

- (BOOL)add:(Product *)product {
    FMDatabase *database = [FMDatabase databaseWithPath:self.databasePath];
    [database open];
    
    // Generate an id for the newly created product
    NSInteger newProductId = [Product nextId];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filename = [NSString stringWithFormat:@"OriginalPhoto%d.png", newProductId];
    NSString *photoPathName = [documentsDirectory stringByAppendingPathComponent:filename];
    
    BOOL success = [database executeUpdate:@"INSERT INTO products (id, name, description, regular_price, sale_price, product_photo) VALUES (?, ?, ?, ?, ?, ?)", @(newProductId), product.productName, product.productDescription, @(product.productRegularPrice), @(product.productSalePrice), photoPathName];
    [database close];
    
    // Save the product's related photo in the Documents directory
    if (success) {
        if (![[PWPhotoManager sharedInstance] saveImage:product.productPhoto toPath:photoPathName]) {
            NSLog(@"Error saving the photo of the product.");
        }
    }
    
    return success;
}

- (BOOL)remove:(Product *)product {
    FMDatabase *database = [FMDatabase databaseWithPath:self.databasePath];
    [database open];
    BOOL success = [database executeUpdate:@"DELETE FROM products WHERE id=?", @(product.productId)];
    [database close];
    
    // Delete the product's related photo in the Documents directory
    if (success) {
        // [self deleteImageAtPath:product.originalPhotoPath];
        if (![[PWPhotoManager sharedInstance] deleteImageAtPath:product.originalPhotoPath]) {
            NSLog(@"Error deleting the photo of the product.");
        }
    }
    
    return success;
}

- (BOOL)update:(Product *)product {
    
    BOOL success;
    // Update the product's related photo in the documents directory
    if (success) {
        //
    }
    
    return YES;
}

- (NSMutableArray *)fetchedProducts {
    NSMutableArray *products = [[NSMutableArray alloc] init];
    FMDatabase *database = [FMDatabase databaseWithPath:self.databasePath];
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT * FROM products"];
    while ([results next]) {
        Product *product = [[Product alloc] initWithId:[results intForColumn:@"id"] andName:[results stringForColumn:@"name"] andDescription:[results stringForColumn:@"description"] andRegularPrice:[results doubleForColumn:@"regular_price"] andSalePrice:[results doubleForColumn:@"sale_price"] andColors:nil andStores:nil];
        [products addObject:product];
    }
    return products;
}
 
@end
