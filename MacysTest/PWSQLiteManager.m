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
    if (success) return;
    
    // If not, then copy the database from the application
    NSError *error;
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseName];
    if (![fileManager copyItemAtPath:databasePathFromApp toPath:self.databasePath error:&error]) {
        // Handle error
        NSLog(@"Copying error: %@", [error userInfo]);
    }
}

@end
