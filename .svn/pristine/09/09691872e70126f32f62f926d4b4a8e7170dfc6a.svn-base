//
//  UIImage+Tint.h
//  EpointFrame5
//
//  Created by Pill.Gong on 14-2-28.
//  Copyright (c) Pill.Gong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage(Tint)

- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;
- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

- (UIImage *)grayImage;
+ (UIImage *)grayImage:(UIImage *)sourceImage;

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha image:(UIImage *)image;

+ (UIImage *)fixOrientation:(UIImage *)aImage;

+ (UIImage *)scale:(UIImage *)image toSize:(CGSize)size;

- (UIImage *)convertToGrayscale;

@end
