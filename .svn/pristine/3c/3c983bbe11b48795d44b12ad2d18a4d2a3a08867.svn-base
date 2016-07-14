//
//  DateView.h
//  wenyao-store
//
//  Created by Meng on 15/4/2.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateViewProtocol <NSObject>
/**
 *  @brief 点击取消按钮
 *
 *  @param buttom <#buttom description#>
 */
- (void)timeSureButtonClick:(NSString *)timeStr;

/**
 *  @brief 点击确定按钮
 *
 *  @param button <#button description#>
 */
- (void)timeCancelButtonClick;

@end

@interface DateView : UIView

{
    NSString *timeStr;
}

@property (nonatomic ,strong) UIDatePicker *datePicker;
//设置代理
@property (nonatomic ,strong) id<DateViewProtocol>delegate;

@end
