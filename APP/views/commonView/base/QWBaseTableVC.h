//
//  QWBaseTableVC.h
//  wenYao-store
//
//  Created by PerryChen on 7/29/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "QWBaseTableViewController.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "QWGlobalManager.h"
#import "MJRefresh.h"
@interface QWBaseTableVC : QWBaseTableViewController<MBProgressHUDDelegate,UITextFieldDelegate,UIScrollViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
    MBProgressHUD *HUD;
    
    IBOutlet UIButton *btnPopVC;
}
@property (nonatomic, strong) UIView *vInfo;
@property (nonatomic, strong) IBOutlet UITableView               *tableMain;
/* delegate */
//@property (nonatomic, assign) id delegate;
//
///**
// *  传递需要返回到的页面位置
// */
//@property (nonatomic, assign) id delegatePopVC;

@property (assign) BOOL backButtonEnabled;
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
- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj;

/**
 *  touch up inside动作，返回上一页
 *
 *  @param sender 触发返回动作button
 */
- (IBAction)popVCAction:(id)sender;

/**
 *  显示等待菊花
 */
//- (void)showLoading;
/**
 *  等待并显示文字
 *
 *  @param msg 文字
 */
- (void)showLoadingWithMessage:(NSString*)msg;
/**
 *  关闭等待
 */
- (void)didLoad;

/**
 *  显示成功/失败
 *
 *  @param msg 文字
 */
- (void)showSuccess:(NSString *)msg;
- (void)showError:(NSString *)msg;

/**
 *  显示提示信息
 *
 *  @param txt 显示内容
 */
- (void)showText:(NSString*)txt;

/**
 *  显示提示信息
 *
 *  @param txt   内容
 *  @param delay 延迟几秒后消失
 */
- (void)showText:(NSString*)txt delay:(double)delay;

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


- (void)zoomClick;
//- (void)backToPreviousController:(id)sender;

//滑动
- (void)viewDidCurrentView;

- (void)naviBackBottonTitle:(NSString*)ttl;

- (void)convertButtonTitle:(NSString *)from toTitle:(NSString *)to inView:(UIView *)view;
/**
 *  显示无数据状态，断网状态
 *
 *  @param text      说明文字
 *  @param imageName 图片名字
 */
-(void)showInfoView:(NSString *)text image:(NSString*)imageName;
- (void)removeInfoView;
- (IBAction)viewInfoClickAction:(id)sender;


#pragma mark - 左上按钮
//- (void)naviLeftBottonImage:(UIImage*)aImg action:(SEL)action;
- (void)naviLeftBottonImage:(UIImage*)aImg highlighted:(UIImage*)hImg action:(SEL)action;

@end
