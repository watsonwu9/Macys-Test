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
    self.databaseName = @"MacysDB.sql";
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
    
    // Generate an id for the newly created product.
    NSInteger newProductId = [Product nextId];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filename = [NSString stringWithFormat:@"Photo%d.png", newProductId];
    NSString *photoPathName = [documentsDirectory stringByAppendingPathComponent:filename];
    
    // Save store_id combined string into the column "stores" of the products table
    // For example, "2,4" means stores with store_id 2 and store_id 4.
    NSDictionary *productStores = product.productStores;
    NSArray *storeIdsArray = [productStores objectForKey:@"available_store_id"];
    NSString *storeIdsString = [storeIdsArray componentsJoinedByString:@","];
    
    BOOL success = [database executeUpdate:@"INSERT INTO products (id, name, description, regular_price, sale_price, product_photo, colors, stores) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", @(newProductId), product.productName, product.productDescription, @(product.productRegularPrice), @(product.productSalePrice), photoPathName, [product.productColors componentsJoinedByString:@","], storeIdsString];
    [database close];
    
    // Save the product's related photo in the Documents directory
    if (success) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [[PWPhotoManager sharedInstance] saveImage:product.productPhoto toPath:photoPathName];

            dispatch_async(dispatch_get_main_queue(), ^{
                // Do nothing here.
            });
        });
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
        if (![[PWPhotoManager sharedInstance] deleteImageAtPath:[product photoPath]]) {
            NSLog(@"Error deleting the photo of the product.");
        }
    }
    
    return success;
}

// CREATE TABLE products ( id INTEGER PRIMARY KEY, name TEXT, description TEXT, regular_price REAL, sale_price REAL, product_photo VARCHAR(255), colors TEXT, stores TEXT )
- (BOOL)update:(Product *)product {
    FMDatabase *database = [FMDatabase databaseWithPath:self.databasePath];
    [database open];
    
    // Save store_id combined string into the column "stores" of the products table
    // For example, "2,4" means stores with store_id 2 and store_id 4.
    NSDictionary *productStores = product.productStores;
    NSArray *storeIdsArray = [productStores objectForKey:@"available_store_id"];
    NSString *storeIdsString = [storeIdsArray componentsJoinedByString:@","];
    
    BOOL success = [database executeUpdate:@"UPDATE products SET name=?, description=?, regular_price=?, sale_price=?, colors=?, stores=? WHERE id=?", product.productName, product.productDescription, @(product.productRegularPrice), @(product.productSalePrice), [product.productColors componentsJoinedByString:@","], storeIdsString, @(product.productId)];
    
    // Update the product's related photo in the documents directory
    if (success) {
        [[PWPhotoManager sharedInstance] updateImage:product.productPhoto atPath:[product photoPath]];
    }
    
    return YES;
}

- (NSMutableArray *)fetchedProducts {
    NSMutableArray *products = [[NSMutableArray alloc] init];
    FMDatabase *database = [FMDatabase databaseWithPath:self.databasePath];
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT * FROM products"];
    while ([results next]) {
        
        // An example for storeIdsString would be "1,2,4".
        NSString *storeIdsString = [results stringForColumn:@"stores"];
        NSDictionary *productStores = @{@"available_store_id" : [storeIdsString componentsSeparatedByString:@","]};
        
        Product *product = [[Product alloc] initWithId:[results intForColumn:@"id"] andName:[results stringForColumn:@"name"] andDescription:[results stringForColumn:@"description"] andRegularPrice:[results doubleForColumn:@"regular_price"] andSalePrice:[results doubleForColumn:@"sale_price"] andColors:[[results stringForColumn:@"colors"] componentsSeparatedByString:@","] andStores:productStores];
        [products addObject:product];
    }
    return products;
}

- (NSMutableArray *)fetchedStores:(NSArray *)storeIds {
    NSMutableArray *stores = [[NSMutableArray alloc] init];
    FMDatabase *database = [FMDatabase databaseWithPath:self.databasePath];
    [database open];
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM stores WHERE id in (%@)", [storeIds componentsJoinedByString:@","]];
    FMResultSet *results = [database executeQuery:queryString];
    while ([results next]) {
        Store *store = [[Store alloc] initWithId:[results intForColumn:@"id"] andName:[results stringForColumn:@"name"]];
        [stores addObject:store];
    }
    return stores;
}
 
@end
