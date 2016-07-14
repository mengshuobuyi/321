//
//  QWInputTextField.h
//  PayPassWord
//
//  Created by 度周末网络-王腾 on 16/4/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QWInputTextField : UITextField

/**
 *  输入框的数量
 */
@property (nonatomic, assign) NSInteger inputCount;

/**
 *  线的颜色
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 *  是否是密码
 */
@property (nonatomic, assign) BOOL isPassWord;

/**
 *  清除内容
 */
-(void)clearText;

@end
