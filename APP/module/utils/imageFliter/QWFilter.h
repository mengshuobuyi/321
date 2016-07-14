
/*!
 @header QWFilter.h
 @abstract 图片滤镜类
 @author .
 @version 1.00 2015/01/01  (1.00)
 */

#import <Foundation/Foundation.h>

@interface QWFilter : NSObject

/*!
 @method
 @brief 获取图片数据
 @param 图片
 @discussion
 @result NSData数据
 */

+(NSData *)getDataFromImage:(UIImage *)image;

/*!
 @method
 @brief 获取图片
 @param 图片数据
 @param 图片大小
 @discussion
 @result 图片
 */

+(UIImage *)getImageFromData:(NSData *)data imageSize:(CGSize)imageSize;
/*!
 @method
 @brief 反色
 @param 图片
 @discussion
 @result 反色图片
 */
+(UIImage *)QWFilter_Inverse:(UIImage *)image;


/*!
 @method
 @brief 平滑
 @param 图片
 @discussion
 @result 平滑图片
 */

+(UIImage *)QWFilter_Smooth:(UIImage *)image;

/*!
 @method
 @brief 霓虹
 @param 图片
 @discussion
 @result 霓虹图片
 */

+(UIImage *)QWFilter_RainBow:(UIImage *)image;

/*!
 @method
 @brief 锐化
 @param 图片
 @discussion
 @result 锐化图片
 */

+(UIImage *)QWFilter_Sharpen:(UIImage *)image sharpNum:(float)sharpNum;


@end
