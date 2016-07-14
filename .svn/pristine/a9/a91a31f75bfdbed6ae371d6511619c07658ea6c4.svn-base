//
//  MADateView.h
//  MADateViewDemo
//
//  Created by Meng on 15/4/14.
//  Copyright (c) 2015年 Meng. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  点击操作
 */
typedef NS_ENUM(NSInteger, MyWindowClick){
    /**
     *
     *  点击确定按钮
     */
    MyWindowClickForOK = 0,
    /**
     *
     *  点击取消按钮
     */
    MyWindowClickForCancel
};

typedef NS_ENUM(NSInteger, DateViewStyle){
    /**
     *  只显示显示时间,格式 HH:mm
     */
    DateViewStyleTime,
    
    /**
     *  只显示日期,格式 yyyy-MM-dd
     */
    DateViewStyleDate
};
//目前只支持两种样式:1.我的机构证件有效期日期样式 2.我的机构营业时间样式

/**
 *  @brief 回调block
 *
 *  @param buttonIndex 索引
 *  @param timeStr     返回的时间字符串
 */

typedef void (^CallBack) (MyWindowClick buttonIndex, NSString *timeStr);


@interface MADateView : UIWindow



/**
*  @brief 创建dateView并显示
*
*  @param date          传入日期,如果日期为空,默认显示当前日期
*  @param dateViewStyle 根据问药业务需求,目前只定义两种显示样式
*  @param callBack      触发事件回调
*
*  @return @return 成功buttonIndex = MyWindowClickForOK,失败buttonIndex = MyWindowClickForCancel
*/
+ (instancetype)showDateViewWithDate:(NSDate *)date Style:(DateViewStyle)dateViewStyle CallBack:(CallBack)callBack;

/**
 *  @brief 隐藏dateView控件
 *
 *  @param animated 是否使用动画
 */
//+ (void)dismissDateViewAnimated:(BOOL)animated;
@end
