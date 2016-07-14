/*************************************************  
 
 Description: 
 
 不规则图片点的判断
 
 *************************************************/ 

#import <UIKit/UIKit.h>

@interface UIImage(Alpha)
- (NSData *)ARGBData;
- (BOOL)isPointTransparent:(CGPoint)point pointScale:(int) pointScale ;
@end
