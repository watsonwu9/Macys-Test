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

//  CREATE TABLE products ( id INTEGER PRIMARY KEY, name TEXT, description TEXT, regular_price REAL, sale_price REAL, product_photo VARCHAR(255), colors TEXT, stores TEXT )
- (BOOL)add:(Product *)product {
    FMDatabase *database = [FMDatabase databaseWithPath:self.databasePath];
    [database open];
    BOOL success = [database executeUpdate:@"INSERT INTO products (name, description, regular_price, sale_price) VALUES (?, ?, ?, ?)", product.productName, product.productDescription, @(product.productRegularPrice), @(product.productSalePrice)];
    [database close];
    return success;
}

- (BOOL)remove:(Product *)product {
    FMDatabase *database = [FMDatabase databaseWithPath:self.databasePath];
    [database open];
    BOOL success = [database executeUpdate:@"DELETE FROM products WHERE id=?", @(product.productId)];
    [database close];
    return success;
}

- (BOOL)update:(Product *)product {
    return YES;
}

//  CREATE TABLE products ( id INTEGER PRIMARY KEY, name TEXT, description TEXT, regular_price REAL, sale_price REAL, product_photo VARCHAR(255), colors TEXT, stores TEXT )
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

- (void)storeImage:(UIImage *)image forProduct:(Product *)product {
    // Save the image to DocumentsDirectory
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSData *originalData = UIImagePNGRepresentation([image fixOrientation]);

        NSError *error3;
        if (![originalData writeToFile:[product originalPhotoPath] options:NSDataWritingAtomic error:&error3]) {
            NSLog(@"Error saving original photo: %@", error3);
        }
    });
}

- (void)deleteImageForProduct:(Product *)product {
    
}

@end
