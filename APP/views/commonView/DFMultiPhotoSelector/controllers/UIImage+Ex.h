//
//  UIImage+Ex.h
//  Mike Ching
//
//  Created by Cheng Yin on 11-8-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface UIImage (Ex)
//+ (UIImage *)imageNamed:(NSString *)imageName;
- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToMinSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)grayScale;
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
+ (UIImage *)scaleAndRotateImage:(UIImage *)image;
+ (UIImage *)redrawImageInContext:(UIImage *)sourceImage inRect:(CGRect)rect;
+ (UIImage *)imageFromView:(UIView *)aView;
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImageView*)screenshotForScreen;
- (UIImage*)getSubImage:(CGRect)rect;
- (CGFloat)compressionQualityWithMaxSize:(CGFloat)maxSize;//KB
- (NSData *)compressedData:(CGFloat)compressionQuality;
- (UIImage *)imageWithCover;
- (UIImage *)createRoundedRectWithRadius:(CGFloat)r;
- (UIImage *)boxblurImageWithBlur:(CGFloat)blur;
- (UIImage *)imageByScalingToPreView;
@end;
