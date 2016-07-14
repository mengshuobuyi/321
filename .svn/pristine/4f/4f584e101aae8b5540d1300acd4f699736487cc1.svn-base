//
//  basePage.h
//  Show
//
//  Created by YAN Qingyang on 15-2-11.
//  Copyright (c) 2015年 YAN Qingyang. All rights reserved.
//

#import "QWBaseView.h"
#import "MBProgressHUD.h"
#import "css.h"

@interface QWBasePage : QWBaseViewController
<MBProgressHUDDelegate,UITextFieldDelegate,UIScrollViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
    MBProgressHUD *HUD;
    
    IBOutlet UIButton *btnPopVC;
}

/**
 *  touch up inside动作，返回上一页
 *
 *  @param sender 触发返回动作button
 */
- (IBAction)popVCAction:(id)sender;

/**
 *  显示等待菊花
 */
- (void)showLoading;

/**
 *  关闭等待
 */
- (void)didLoad;

/**
 *  显示提示信息，显示时常1.5秒
 *
 *  @param txt <#txt description#>
 */
- (void)showMessage:(NSString*)txt;

/**
 *  显示错误信息
 *
 *  @param error 错误对象
 */
- (void)showErrorMessage:(NSError*)error;

/**
 *  调试用
 *
 *  @param msg 多字符串参数，结尾加nil
 */
- (void)showLog:(NSString*)msg, ...;

@end
