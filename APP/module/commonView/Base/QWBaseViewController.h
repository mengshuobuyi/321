//
//  baseView.h
//  Show
//
//  Created by YAN Qingyang on 15-2-7.
//  Copyright (c) 2015年 YAN Qingyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QWConstant.h"
#import "QWcss.h"
#import "UIImageView+WebCache.h"

@interface QWBaseViewController : UIViewController
/* delegate */
@property (nonatomic, assign) id delegate;

/**
 *  传递需要返回到的页面位置
 */
@property (nonatomic, assign) id delegatePopVC;


/**
 *  app的UI全局设置，包括背景色，top bar背景等
 */
- (void)UIGlobal;

/**
 *  获取全局通知
 *
 *  @param type 通知类型
 *  @param data 数据
 *  @param obj  通知来源
 */
- (void)getNotifType:(NSInteger)type data:(id)data target:(id)obj;
@end


