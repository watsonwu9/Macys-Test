//
//  PWSQLiteManager.h
//  MacysTest
//
//  Created by Paul Wong on 5/11/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWSQLiteManager : NSObject

/**
 @returns a singleton instance of PWSQLiteManager
 */
+ (id)sharedInstance;

/**
Check if the SQL database has already been saved to the user's phone (if not, then copy it over)
 */
- (void)checkAndCreateDatabase;

@end
