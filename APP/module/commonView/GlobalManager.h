//
//  GlobalManager.h
//  APP
//
//  Created by carret on 15/1/16.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BaseModel.h"
#import "DemoModel.h"
#import "QWcss.h"

#define  GLOBALMANAGER [GlobalManager sharedInstance]

#define StrFromInt(IntValue)     [NSString stringWithFormat: @"%ld", (long)IntValue]
#define StrFromFloat(FloatValue)     [NSString stringWithFormat: @"%f", FloatValue]
#define StrFromDouble(DoubleValue)     [NSString stringWithFormat: @"%f", DoubleValue]
#define StrFromObj(objValue)     [NSString stringWithFormat: @"%@", objValue]
#define StrIsEmpty(strObj)      [GLOBALMANAGER isStringEmpty:strObj]
#define StrDFString(targetStr, defaultStr) [GLOBALMANAGER targetString:targetStr defaultString:defaultStr]

@interface GlobalManager : NSObject
@property(nonatomic ,strong)DemoModel *demoModel;
@property (nonatomic,strong)BodyModel *body;

+ (GlobalManager *)sharedInstance;

- (BOOL)console ;
- (BOOL)iPhone ;
- (BOOL)iPad;


/**
 *  判断是不是某类
 *
 *  @param obj    判断对象
 *  @param aClass 类类型
 *
 *  @return 返回BOOL
 */
- (BOOL)object:(id)obj isClass:(Class)aClass;

/**
 *  判断字符串是空
 *
 *  @param obj <#obj description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)isStringEmpty:(id)obj;

/**
 *  如果目标字符串不为空，返回目标字符串，反则返回默认字符串
 *
 *  @param targetString    目标字符串
 *  @param defaultString    默认字符串
 *  @return 返回BOOL
 */
- (NSString*)targetString:(NSString*)targetString defaultString:(NSString*)defaultString;

/**
 *  判断是不是手机号码
 *
 *  @param obj    判断对象
 *
 *  @return 返回BOOL
 */
- (BOOL)isPhoneNumber:(NSString*)text;

/**
 *  判断是不是电话号码
 *
 *  @param obj    判断对象
 *
 *  @return 返回BOOL
 */
- (BOOL)isTelPhoneNumber:(NSString*)text;


/**
 *  @brief 判断是否包含数字或字母
 *
 *  @return YES表示包含, NO表示不包含
 */

- (BOOL)isContainNumOrABC:(NSString *)str;


/**
 *  校验身份证号码
 *
 *  @param obj    判断对象
 *
 *  @return 返回BOOL
 */
+ (BOOL)validateIDCardNumber:(NSString *)value;

+ (BOOL)checkIDCard:(NSString *)str;

/**
 *  判断邮件格式是否正确
 *
 *  @param obj    判断对象
 *
 *  @return 返回BOOL
 */
- (BOOL)isEmailAddress:(NSString*)text;

/**
 *  判断字符串是否都为数字
 *
 *  @param obj    判断对象
 *
 *  @return 返回BOOL
 */
- (BOOL)isAllNum:(NSString *)string;
/**
 *  发出全局通知
 *
 *  @param type 通知类型
 *  @param data 数据
 *  @param object  通知来源对象，填self
 *  @return @{type:,data:,object:}
 */
- (NSDictionary *)postNotif:(NSInteger)type data:(id)data object:(id)object;

/**
 *  文字限宽下高度计算
 *
 *  @param text  文字内容
 *  @param font  字体
 *  @param width 宽度
 *
 *  @return 返回高度,如果带emoji表情，要加2
 */
- (CGSize)sizeText:(NSString*)text
              font:(UIFont*)font
        limitWidth:(float)width;

- (CGSize)sizeText:(NSString*)text
              font:(UIFont*)font
       limitHeight:(float)height;
/**
 *  返回文字的size
 *
 *  @param text 内容
 *  @param font 字体
 *
 *  @return size
 */
- (CGSize)sizeText:(NSString*)text font:(UIFont*)font;

- (CGSize)sizeText:(NSString*)text font:(UIFont*)font constrainedToSize:(CGSize)size;

/**
 *  设置边距
 *
 *  @param object UI控件
 *  @param margin 边距
 *  @param edge   方位
 */
- (void)setObject:(UIView*)object margin:(CGFloat)margin edge:(Enum_Edge)edge;

/**
 *  @brief 判断键盘当前是否是表情输入模式
 *
 *  @param inputControl 传入调出键盘的控件对象 例如:UITextField UITextView UISearchBar
 *
 *  @return YES表示是表情输入模式, NO表示不是表情模式
 */
- (BOOL)judgeTheKeyboardInputModeIsEmojiOrNot:(id)inputControl;
@end
