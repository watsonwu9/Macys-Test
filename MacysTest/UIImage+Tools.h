//
//  UIImage+Tools.h
//
//  Created by Paul Wong on 1/24/14.
//  Copyright (c) 2014 self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tools)

- (UIImage *)resizedImageToWidth:(float)width andHeight:(float)height;

- (UIImage *)fixOrientation;

@end
