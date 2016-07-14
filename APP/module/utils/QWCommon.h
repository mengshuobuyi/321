/*!
 @header QWCommon.h
 @abstract 此组件包括一些处理常用功能的方法
 @author .
 @version 1.00 2015/01/01  (1.00)
 */

#import <Foundation/Foundation.h>

extern int QWCommon_GameID;


typedef enum {
    QWDevice_iPhone = 1,
    QWDevice_iPad,
    QWDevice_iPhoneRetina,
    QWDevice_iPadRetina
}QWDevice;

@interface QWCommon : NSObject


/*!
 @method
 @brief 振动调用
 @param
 @discussion
 @result
 */

+(void)invokeVibration;


/*!
 @method
 @brief 显示AppStore中某个应用的评论
 @param appleId
 @discussion
 @result
 */

+(void)showAppStoreCommentWithAppID:(int)appID;

/*!
 @method
 @brief 获得系统版本
 @param
 @discussion
 @result 系统版本
 */

+(float)getSystemVersion;

/*!
 @method
 @brief 获得设备标识
 @param
 @discussion
 @result 设备标示
 */

+(QWDevice)getDevice;

/*!
 @method
 @brief 接近传感器
 @param 监听传感器的对象
 @param 监听到传感器后的处理方法
 @discussion
 @result  
 */

+(void)addProximityWithObserver:(id)observer sel:(SEL)sel;

/*!
 @method
 @brief UIButton设置高亮模式
 @param btn
 @discussion
 @result 设置成高亮的btn
 */


+(void)exchangeButtonBackgroundImage:(UIButton *)btn;

/*!
 @method
 @brief 获得对应的ipad坐标
 @param phone的坐标
 @discussion
 @result pad的坐标
 */

+(CGPoint)getLargePoint:(CGPoint)point;

/*!
 @method
 @brief 强制旋转屏幕
 @param 转屏的类型
 @discussion
 @result
 */

//TODO:
+(void)forceRotateInterfaceOrientation:(UIInterfaceOrientation)orientation;


/*!
 @method
 @brief 获取APNS设备令牌
 @param deviceToken数据
 @discussion
 @result deviceToken
 */

+(NSString *)getDeviceTokenFromData:(NSData *)deviceToken;


/*!
 @method
 @brief 从字符串中获得英文其中包含的英文个数
 @param 需要遍历的String
 @discussion
 @result 英文个数
 */


+(int)getEnglishCharacterLength:(NSString *)str;

/*!
 @method
 @brief 字母顺序从小到达排序
 @param
 @discussion
 @result 返回排序后的数组
 */

+(NSArray *)sortChaFromSmallToLarge:(NSArray *)arry;

/*!
 @method
 @brief 获得GBK编码
 @param
 @discussion
 @result 返回GBK编码字符串
 */

+(NSStringEncoding)getGBKEncoding;

/*!
 @method
 @brief 调整坐标
 @param 传入想要调整的坐标
 @discussion
 @result 返回调整后的坐标
 */

+(CGRect)rescale:(CGRect)oldRect toRect:(CGRect)toRect;


/*!
 @method
 @brief 截屏
 @param 所要截屏的view
 @discussion
 @result 截屏所得图像
 */

+(UIImage *)getImageFromView:(UIView *)view;

@end
