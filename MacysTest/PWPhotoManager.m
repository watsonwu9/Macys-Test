//
//  PWPhotoManager.m
//  MacysTest
//
//  Created by Paul Wong on 5/12/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import "PWPhotoManager.h"

@implementation PWPhotoManager

+ (id)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (BOOL)saveImage:(UIImage *)image toPath:(NSString *)pathName {
    // Save the image to the Documents Directory asynchronously.
    __block BOOL success;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = UIImagePNGRepresentation([image fixOrientation]);
        
        NSError *error;
        if (![imageData writeToFile:pathName options:NSDataWritingAtomic error:&error]) {
            NSLog(@"Error saving the photo: %@", error);
        }
        else {
            success = YES;
        }
    });
    return success;
}

- (BOOL)deleteImageAtPath:(NSString *)pathName {
    BOOL success = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if (![fileManager removeItemAtPath:pathName error:&error]) {
        NSLog(@"Error deleting the photo: %@", [error userInfo]);
    }
    else {
        success = YES;
    }
    return success;
}

- (BOOL)updateImage:(UIImage *)image atPath:(NSString *)pathName {
    // Update the image at the desired path asynchronously.
    __block BOOL success;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = UIImagePNGRepresentation([image fixOrientation]);
        
        NSError *error;
        if (![imageData writeToFile:pathName options:NSDataWritingAtomic error:&error]) {
            NSLog(@"Error updating the photo: %@", error);
        }
        else {
            success = YES;
        }
    });
    return success;
}

@end
