//
//  PWSQLiteManager.h
//  MacysTest
//
//  Created by Paul Wong on 5/11/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "Store.h"
#import "UIImage+Tools.h"
#import <sqlite3.h>
#import "FMDatabase.h"
#import "PWPhotoManager.h"

@interface PWSQLiteManager : NSObject

/**
 @returns a singleton instance of PWSQLiteManager.
 */
+ (id)sharedInstance;

/**
 Check if the SQL database has already been saved to the user's phone (if not, then copy it over).
 */
- (void)checkAndCreateDatabase;

/**
 INSERT a row into the products table.
 
 Schema of the products table in MacysDB.sql:
  
 CREATE TABLE products ( id INTEGER PRIMARY KEY, name TEXT, description TEXT, regular_price REAL, sale_price REAL, product_photo VARCHAR(255), colors TEXT, stores TEXT )
 @returns YES if INSERT is successful.
 */
- (BOOL)add:(Product *)product;

/**
 DELETE a row from the products table.
 
 Schema of the products table in MacysDB.sql:
 
 CREATE TABLE products ( id INTEGER PRIMARY KEY, name TEXT, description TEXT, regular_price REAL, sale_price REAL, product_photo VARCHAR(255), colors TEXT, stores TEXT )
 @returns YES if DELETE is successful.
 */
- (BOOL)remove:(Product *)product;

/**
 UPDATE a row in the products table.
 
 Schema of the products table in MacysDB.sql:
 
 CREATE TABLE products ( id INTEGER PRIMARY KEY, name TEXT, description TEXT, regular_price REAL, sale_price REAL, product_photo VARCHAR(255), colors TEXT, stores TEXT )
 @returns YES if UPDATE is successful.
 */
- (BOOL)update:(Product *)product;

/**
 SELECT * from the products table.
 
 Schema of the products table in MacysDB.sql:
 
 CREATE TABLE products ( id INTEGER PRIMARY KEY, name TEXT, description TEXT, regular_price REAL, sale_price REAL, product_photo VARCHAR(255), colors TEXT, stores TEXT )
 @returns all the stored products.
 */
- (NSMutableArray *)fetchedProducts;

/**
 SELECT * from the products table.
 
 Schema of the products table in MacysDB.sql:
 
 CREATE TABLE products ( id INTEGER PRIMARY KEY, name TEXT, description TEXT, regular_price REAL, sale_price REAL, product_photo VARCHAR(255), colors TEXT, stores TEXT )
 @params storeIds the set of store ids.
 @returns the corresponding set of stores.
 */
- (NSMutableArray *)fetchedStores:(NSArray *)storeIds;

@end
