//
//  WebDirectViewController.h
//  APP
//
//  Created by PerryChen on 8/20/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "QWBaseVC.h"
#import "WebDirectModel.h"
#import "QWWebViewController.h"
#import "QWCallbackPluginExt.h"
#import "NSString+TransDomain.h"

typedef void(^RefreshTrainingList)();

@protocol WebDirectCallBackDelegate <NSObject>

- (void)runCallbackWithPageType:(NSInteger)pageType;

@end

@interface WebDirectViewController : QWWebViewController

@property (nonatomic, strong) WebDirectModel *modelDir;

@property (nonatomic, strong) NSString *webURL;

@property (nonatomic, strong) QWCallbackPluginExt *extShare;

@property (nonatomic, strong) RefreshTrainingList blockRefresh;

@property (nonatomic, assign) NSInteger pageType;               // HTML 页面类型

@property (nonatomic, weak) id<WebDirectCallBackDelegate> callBackDelegate;

@property (nonatomic, strong) WebDirectLocalModel *modelLocal;

// 设置h5跳转h5
- (void)setWVWithModel:(WebDirectModel *)modelDir withType:(WebTitleType)enumType;

// 本地跳转H5 设置相应HTML界面信息
- (void)setWVWithLocalModel:(WebDirectLocalModel *)modelDir;

// 跳转本地界面
- (void)jumpToLocalVC:(WebDirectModel *)modelDir;
// 跳转H5页面
- (void)jumpToH5Page:(WebDirectModel *)modelDir;

// 以后弃用
- (void)setWVWithURL:(NSString *)strURL title:(NSString *)strTitle withType:(WebTitleType)enumType;

// H5通知分享
- (void)actionShare:(WebPluginModel *)modelPlugin;

// H5通知弹框
- (void)showAlertWithMessage:(NSString *)strMsg;

// H5通知打电话
- (void)actionPhoneWithNumber:(NSString *)phoneNum;

- (void)popCurVC;                                       // 跳出当前页面

// 通知H5进行操作 传入callback type
- (void)actionInformH5:(CallbackType)typeCallback;

- (void)actionInformPageType:(NSInteger)pageType;

// H5通知加分享
- (void)rightItemNeedShare;

@end
