//
//  Store.m
//  MacysTest
//
//  Created by Paul Wong on 5/13/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import "Store.h"

@implementation Store

- (id)initWithId:(NSInteger)storeId andName:(NSString *)storeName {
    self = [super init];
    if (self) {
        self.storeId = storeId;
        self.storeName = storeName;
    }
    return self;
}

@end
