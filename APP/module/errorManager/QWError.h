/*!
 @header QWError.h
 @abstract SDK错误信息定义文件
 @author
 @version 1.0
 */


#import <Foundation/Foundation.h>
#import "QWErrorDefines.h"


/*!
 @class
 @brief SDK错误信息定义类
 @discussion
 */

@interface QWError : NSObject

/*!
 @property
 @brief 错误代码
 */
@property (nonatomic) NSInteger errorCode;

/*!
 @property
 @brief 错误信息描述
 */
@property (nonatomic, copy) NSString *Edescription;

/*!
 @method
 @brief 创建一个EMError实例对象
 @param errCode 错误代码
 @param description 错误描述信息
 @discussion
 @result 错误信息描述实例对象
 */
+ (QWError *)errorWithCode:(QWErrorType)errCode
            andDescription:(NSString *)description;

/*!
 @method
 @brief 通过NSError对象, 生成一个EMError对象
 @param error NSError对象
 @discussion
 @result 错误信息描述实例对象
 */
+ (QWError *)errorWithNSError:(NSError *)error;
@end
