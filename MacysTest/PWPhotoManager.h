//
//  PWPhotoManager.h
//  MacysTest
//
//  Created by Paul Wong on 5/12/14.
//  Copyright (c) 2014 Paul Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+Tools.h"

@interface PWPhotoManager : NSObject

/**
 @returns a singleton instance of the PWPhotoManager.
 */
+ (id)sharedInstance;

/**
 @params image the image to be saved.
 @params pathName the path for the image to be saved.
 */
- (void)saveImage:(UIImage *)image toPath:(NSString *)pathName;

/**
 @params pathName the path of the photo to be deleted.
 @returns YES if the image is successfully deleted.
 */
- (BOOL)deleteImageAtPath:(NSString *)pathName;

/**
 @params image the image to be updated.
 @params pathName the path of the image to be updated.
 */
- (void)updateImage:(UIImage *)image atPath:(NSString *)pathName;

@end
