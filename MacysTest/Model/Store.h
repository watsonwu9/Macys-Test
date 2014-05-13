//
//  Store.h
//  MacysTest
//
//  Created by Paul Wong on 5/13/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Store : NSObject

/**
 the id of the store.
 */
@property (nonatomic) NSInteger storeId;

/**
 the name of the store.
 */
@property (nonatomic) NSString *storeName;

/**
 @params storeId the id for the store.
 @params storeName the name for the store.
 @returns an instance of Store.
 */
- (id)initWithId:(NSInteger)storeId andName:(NSString *)storeName;

@end
