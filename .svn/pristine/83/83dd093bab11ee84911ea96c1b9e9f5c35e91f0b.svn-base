//
//  basePage.m
//  Show
//
//  Created by YAN Qingyang on 15-2-11.
//  Copyright (c) 2015年 YAN Qingyang. All rights reserved.
//

#import "QWBaseVC.h"
#import "AppDelegate.h"
#import "viewCustomAnimate.h"
#import "QWGlobalManager.h"
#import "CustomShareView.h"
#import "System.h"
#import "SystemModel.h"
#import "Forum.h"
#import "QWProgressHUD.h"

static float kTopBarItemWidth = 40;
static float kDelay = 1.2f;
static float kTopBackBtnMargin = -13.f;
static float kTopBtnMargin = -16.f;

@interface QWBaseVC ()<UIGestureRecognizerDelegate,UINavigationBarDelegate,UMSocialUIDelegate,UMSocialDataDelegate>
{
    UIView *vQLog;
    SRRefreshView   *_slimeView;
//    UIView *vInfo;
    UITextView *txtQLog;
    
}
@property (strong, nonatomic) ShareContentModel *modelShare;
@property (strong, nonatomic) CustomShareView *viewCusShare;
@property (strong, nonatomic) NSString *strChannel;
@end

@implementation QWBaseVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (self.navigationController.viewControllers.count<=1 && _backButtonEnabled == NO)
        return;
    else
        [self naviBackBotton];
    
    //[MobClick beginLogPageView:StrFromObj([self class])];
    
    [QWCLICKEVENT qwTrackPageBegin:StrFromObj([self class])];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[MobClick endLogPageView:StrFromObj([self class])];
    
    [QWCLICKEVENT qwTrackPageEnd:StrFromObj([self class])];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _refreshTops = [NSMutableArray arrayWithCapacity:3];
    if (iOSv7 && self.view.frame.origin.y==0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    [self UIGlobal];
    
    /**
     *  如果不要显示头部的下拉刷新，添加header              `              Hidden=YES;
     */
    //self.tableMain.headerHidden=YES;
    
//    self.tableMain.dataSource = self;
//    self.tableMain.delegate = self;
}


- (void)enableSimpleRefresh:(UIScrollView *)scrollView  block:(SRRefreshBlock)block
{
    [[scrollView viewWithTag:1018] removeFromSuperview];
    SRRefreshView *slimeView = [[SRRefreshView alloc] init];
    [_refreshTops addObject:slimeView];
    slimeView.delegate = self;
    slimeView.upInset = scrollView.contentInset.top;
    slimeView.slimeMissWhenGoingBack = YES;
    slimeView.slime.bodyColor = RGBHex(qwColor1);
    slimeView.slime.skinColor = RGBHex(qwColor1);
    slimeView.slime.lineWith = 1;
//    slimeView.slime.shadowBlur = 4;
//    slimeView.slime.shadowColor = RGBHex(qwColor1);
    slimeView.block = block;
    slimeView.tag = 1018;
    if(!scrollView.delegate)
        scrollView.delegate = self;
    [scrollView addSubview:slimeView];
}

- (void)endHeaderRefresh
{
    [_refreshTops enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SRRefreshView *refreshView = obj;
        [refreshView endRefresh];
    }];
}

// 换掉标题
- (void)convertButtonTitle:(NSString *)from toTitle:(NSString *)to inView:(UIView *)view
{
    if ([view isKindOfClass:[UIButton class]])
    {
        UIButton *button = (UIButton *)view;
        button.enabled = YES;
        if ([[button titleForState:UIControlStateNormal] isEqualToString:from])
        {
            [button setTitle:to forState:UIControlStateNormal];
            button.enabled = YES;
        }
        if ([[button titleForState:UIControlStateDisabled] isEqualToString:from])
        {
            [button setTitle:to forState:UIControlStateDisabled];
            button.enabled = YES;
        }
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    for (UIView *subview in view.subviews)
    {
        [self convertButtonTitle:from toTitle:to inView:subview];
    }
}


#pragma mark - 全局界面UI
- (void)UIGlobal{
    [super UIGlobal];
    
    self.view.backgroundColor=RGBHex(qwColor11);
    
    
    if (self.tableMain==nil) {
        self.tableMain = [[UITableView alloc]initWithFrame:self.view.bounds];
    }
    
    _tableMain.backgroundColor=RGBAHex(qwColor4, 1);
    _tableMain.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _tableMain.allowsSelection = NO;
    
    //[self.tableMain addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableMain addFooterWithTarget:self action:@selector(footerRereshing)];
    
    self.tableMain.footerPullToRefreshText = kWaring6;
    self.tableMain.footerReleaseToRefreshText = kWaring7;
    self.tableMain.footerRefreshingText = kWaring9;
    self.tableMain.footerNoDataText = kWaring55;
}

#pragma mark - table 刷新
- (void)headerRereshing{
    
}

- (void)footerRereshing{
    
}

#pragma mark - 左上按钮
- (void)naviLeftBottonImage:(UIImage*)aImg highlighted:(UIImage*)hImg action:(SEL)action{
    //[self.navigationItem setHidesBackButton:YES];
    
    
    CGFloat margin=10;
    CGFloat ww=kTopBarItemWidth, hh=44;
    CGFloat bw,bh;
    
    //12,21 nav_btn_back
    bw=aImg.size.width;
    bh=aImg.size.height;
    
    CGRect frm = CGRectMake(0,0,ww,hh);
    UIButton* btn= [[UIButton alloc] initWithFrame:frm];
    
    [btn setImage:aImg forState:UIControlStateNormal];
    if (hImg)
        [btn setImage:hImg forState:UIControlStateHighlighted];
    [btn setImageEdgeInsets:UIEdgeInsetsMake((hh-bh)/2, margin, (hh-bh)/2, ww-margin-bw)];
    
    
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor=[UIColor clearColor];
    
    
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = kTopBackBtnMargin;
    //
    UIBarButtonItem* btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItems = @[fixed,btnItem];
}
#pragma mark - 右侧文字按钮
- (void)naviRightBotton:(NSString*)aTitle action:(SEL)action
{
    UIFont *ft=fontSystemBold(kFontS1);
    CGFloat ww=kTopBarItemWidth, hh=44;
    
    CGSize sz=[GLOBALMANAGER sizeText:aTitle font:ft];
    if (sz.width>ww) {
        ww=sz.width;
    }
    
    CGRect frm = CGRectMake(0,0,ww,hh);
    UIButton* btn= [[UIButton alloc] initWithFrame:frm];
    
    
    [btn setTitle:aTitle forState:UIControlStateNormal];
    btn.titleLabel.font=ft;
    btn.titleLabel.textColor=RGBHex(qwColor4);
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor=[UIColor clearColor];
    
    
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = kTopBtnMargin;
    
    UIBarButtonItem* btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItems = @[fixed,btnItem];
}
#pragma mark - 导航返回按钮自定义
- (void)naviBackBotton
{
    [self naviLeftBottonImage:[UIImage imageNamed:@"nav_btn_back"] highlighted:[UIImage imageNamed:@"nav_btn_back_sel"] action:@selector(popVCAction:)];
    
}

#pragma mark - 导航返回按钮自定义
- (void)naviBackBottonTitle:(NSString*)ttl{
    
    if (self.navigationController.viewControllers.count<=1) {
        return;
    }
    [self.navigationItem setHidesBackButton:YES];
    
    NSString *txt=(ttl)?ttl:@"";
    
    UIImage* backImage = [UIImage imageNamed:@"nav_btn_back"];//24,42 nav_btn_back
    
    CGRect frm = CGRectMake(0,0,80,44);
    UIButton* btn= [[UIButton alloc] initWithFrame:frm];
    
//    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [btn setImage:backImage forState:UIControlStateNormal];
    
    [btn setTitle:txt forState:UIControlStateNormal];
    btn.titleLabel.font=fontSystem(kFontS2);
    btn.titleLabel.textColor=RGBHex(qwColor1);
    [btn addTarget:self action:@selector(popVCAction:) forControlEvents:UIControlEventTouchUpInside];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
//    btn.backgroundColor=[UIColor redColor];
    
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = -6;
   
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItems = @[fixed,leftBarButtonItem];
}

#pragma mark - 返回主页，收藏等列表
//- (void)setUpRightItem
//{
//    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    fixed.width = -6;
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-unfold.PNG"] style:UIBarButtonItemStylePlain target:self action:@selector(returnIndex)];
//    self.navigationItem.rightBarButtonItems = @[fixed,rightItem];
//}

//- (void)returnIndex
//{
//    self.indexView = [ReturnIndexView sharedManagerWithImage:@[@"icon home.PNG"] title:@[@"首页"]];
//    self.indexView.delegate = self;
//    [self.indexView show];
//}
//
//- (void)RetunIndexView:(ReturnIndexView *)ReturnIndexView didSelectedIndex:(NSIndexPath *)indexPath
//{
//    [self.indexView hide];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self performSelector:@selector(delayPopToHome) withObject:nil afterDelay:0.01];
//}

//- (void)delayPopToHome
//{
//    [[QWGlobalManager sharedInstance].tabBar setSelectedIndex:0];
//}

#pragma mark 全局通知
- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj{
    
}

#pragma mark - tmp
- (CGSize)sizeText:(NSString*)text
              font:(UIFont*)font
        limitWidth:(float)width
{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin//|NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    rect.size.width=width;
    rect.size.height=ceil(rect.size.height);
    return rect.size;
}

#pragma mark - 无数据页面水印---有选择框的

-(void)showInfoView:(NSString *)text image:(NSString*)imageName flatY:(NSInteger)y {
    [self showInfoView:text image:imageName tag:0 flatY:(NSInteger)y];
}


-(void)showInfoView:(NSString *)text image:(NSString*)imageName tag:(NSInteger)tag flatY:(NSInteger)y
{
    UIImage * imgInfoBG = [UIImage imageNamed:imageName];
    
    
    if (self.vInfo==nil) {
        self.vInfo = [[UIView alloc]initWithFrame:self.view.bounds];
        self.vInfo.backgroundColor = RGBHex(qwColor11);
    }
    CGRect rect = self.view.bounds;
    rect.origin.y = y;
    
    
    self.vInfo.frame = rect;
    
    
    for (id obj in self.vInfo.subviews) {
        [obj removeFromSuperview];
    }
    
    UIImageView *imgvInfo;
    UILabel* lblInfo;
    
    imgvInfo=[[UIImageView alloc]init];
    [self.vInfo addSubview:imgvInfo];
    
    lblInfo = [[UILabel alloc]init];
    lblInfo.numberOfLines=0;
    lblInfo.font = fontSystem(kFontS1);
    lblInfo.textColor = RGBHex(qwColor7);//0x89889b 0x6a7985
    lblInfo.textAlignment = NSTextAlignmentCenter;
    [self.vInfo addSubview:lblInfo];
    
    UIButton *btnClick = [[UIButton alloc] initWithFrame:self.vInfo.bounds];
    btnClick.tag=tag;
    [btnClick addTarget:self action:@selector(viewInfoClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.vInfo addSubview:btnClick];
    
    
    float vw=CGRectGetWidth(self.vInfo.bounds);
    
    CGRect frm;
    frm=RECT((vw-imgInfoBG.size.width)/2,90, imgInfoBG.size.width, imgInfoBG.size.height);
    imgvInfo.frame=frm;
    imgvInfo.image = imgInfoBG;
    
    float lw=vw-40*2;
    float lh=(imageName!=nil)?CGRectGetMaxY(imgvInfo.frame) + 24:40;
    CGSize sz=[self sizeText:text font:lblInfo.font limitWidth:lw];
    frm=RECT((vw-lw)/2, lh, lw,sz.height);
    lblInfo.frame=frm;
    lblInfo.text = text;
    
    [self.view addSubview:self.vInfo];
    [self.view bringSubviewToFront:self.vInfo];
}



#pragma mark - 无数据页面水印

-(void)showInfoView:(NSString *)text image:(NSString*)imageName {
    [self showInfoView:text image:imageName tag:0];
}

-(void)showInfoView:(NSString *)text image:(NSString*)imageName tag:(NSInteger)tag
{
    UIImage * imgInfoBG = [UIImage imageNamed:imageName];
    
    
    if (self.vInfo==nil) {
        self.vInfo = [[UIView alloc]initWithFrame:self.view.bounds];
        self.vInfo.backgroundColor = RGBHex(qwColor11);
    }
    
    self.vInfo.frame = self.view.bounds;
    
    for (id obj in self.vInfo.subviews) {
        [obj removeFromSuperview];
    }
    
    UIImageView *imgvInfo;
    UILabel* lblInfo;
    
    imgvInfo=[[UIImageView alloc]init];
    [self.vInfo addSubview:imgvInfo];
    
    lblInfo = [[UILabel alloc]init];
    lblInfo.numberOfLines=0;
    lblInfo.font = fontSystem(kFontS1);
    lblInfo.textColor = RGBHex(qwColor8);//0x89889b 0x6a7985
    lblInfo.textAlignment = NSTextAlignmentCenter;
    [self.vInfo addSubview:lblInfo];
    
    UIButton *btnClick = [[UIButton alloc] initWithFrame:self.vInfo.bounds];
    btnClick.tag=tag;
    [btnClick addTarget:self action:@selector(viewInfoClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.vInfo addSubview:btnClick];
    
    
    float vw=CGRectGetWidth(self.vInfo.bounds);
    
    CGRect frm;
    frm=RECT((vw-imgInfoBG.size.width)/2,90, imgInfoBG.size.width, imgInfoBG.size.height);
    imgvInfo.frame=frm;
    imgvInfo.image = imgInfoBG;
    
    float lw=vw-40*2;
    float lh=(imageName!=nil)?CGRectGetMaxY(imgvInfo.frame) + 24:40;
    CGSize sz=[self sizeText:text font:lblInfo.font limitWidth:lw];
    frm=RECT((vw-lw)/2, lh, lw,sz.height);
    lblInfo.frame=frm;
    lblInfo.text = text;
    
    [self.view addSubview:self.vInfo];
    [self.view bringSubviewToFront:self.vInfo];
}


//-(void)showInfoView:(NSString *)text image:(NSString*)imageName
//{
//    UIImage * imgInfoBG = [UIImage imageNamed:imageName];
//    
//    
//    if (vInfo==nil) {
//        vInfo = [[UIView alloc]initWithFrame:self.view.bounds];
//        vInfo.backgroundColor = RGBHex(qwColor11);
//    }
//    
//    for (id obj in vInfo.subviews) {
//        [obj removeFromSuperview];
//    }
//    
//    UIImageView *imgvInfo;
//    UILabel* lblInfo;
//    
//    imgvInfo=[[UIImageView alloc]init];
//    [vInfo addSubview:imgvInfo];
//    
//    lblInfo = [[UILabel alloc]init];
//    lblInfo.font = fontSystem(kFontS5);
//    lblInfo.textColor = RGBHex(qwColor8);
//    lblInfo.textAlignment = NSTextAlignmentCenter;
//    [vInfo addSubview:lblInfo];
//    
//    UIButton *btnClick = [[UIButton alloc] initWithFrame:vInfo.bounds];
//    [btnClick addTarget:self action:@selector(viewInfoClickAction:) forControlEvents:UIControlEventTouchUpInside];
//    [vInfo addSubview:btnClick];
//    
//    CGRect frm;
//    
//    frm=RECT(0, 0, imgInfoBG.size.width, imgInfoBG.size.height);
//    imgvInfo.frame=frm;
//    imgvInfo.center = CGPointMake(APP_W/2, self.view.center.y-40);
//    imgvInfo.image = imgInfoBG;
//    
//    frm=RECT(0, CGRectGetMaxY(imgvInfo.frame) + 10, text.length*20,30);
//    lblInfo.frame=frm;
//    lblInfo.center = CGPointMake(APP_W/2, lblInfo.center.y);
//    lblInfo.text = text;
//    
//    [self.view insertSubview:vInfo atIndex:self.view.subviews.count ];
//}

- (void)removeInfoView{
    [self.vInfo removeFromSuperview];
}

- (IBAction)viewInfoClickAction:(id)sender{
    
}


#pragma mark - 手动
//- (void)showLoading {
//    if (HUD==nil) {
//        HUD = [[MBProgressHUD alloc] initWithView:self.view];
//        HUD.minShowTime=0.5;
//        [self.view addSubview:HUD];
//        [self.view bringSubviewToFront:HUD];
//        viewCustomAnimate *customView = [[[NSBundle mainBundle] loadNibNamed:@"viewCustomAnimate" owner:self options:nil] objectAtIndex:0];
//        HUD.mode = MBProgressHUDModeCustomView;
//        HUD.color = [UIColor clearColor];
//        HUD.customView = customView;
//        
//        HUD.delegate = self;
//    }
//    
//    [HUD show:YES];
//}

- (void)showLoadingWithMessage:(NSString*)msg {
    if (HUD==nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        [self.view bringSubviewToFront:HUD];
        
        HUD.delegate = self;
    }
    HUD.labelText=msg;
    
    [HUD show:YES];
}

- (void)didLoad{
    
    [HUD hide:YES];
}




#pragma mark - 自动消息
- (void)showText:(NSString*)txt{
    [self showText:txt delay:1.5];
}

- (void)showText:(NSString*)txt delay:(double)delay{
    [self.view endEditing:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = txt;
//    hud.margin = 10.f;
//    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    
    double dl=(delay>0)?delay:1.f;
    [hud hide:YES afterDelay:dl];
}

- (void)showError:(NSString *)msg{
    [self showMessage:msg icon:@"error.png" afterDelay:1.2 ];
//    [self show:error icon:@"error.png" view:view];
}

- (void)showSuccess:(NSString *)msg
{
    [self showMessage:msg icon:@"success.png" afterDelay:1.2 ];
}

- (void)showMessage:(NSString*)txt icon:(NSString *)icon afterDelay:(double)delay{
    [self.view endEditing:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = txt;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
//    hud.margin = 10.f;
//    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    
    double dl=(delay>0)?delay:1.f;
    [hud hide:YES afterDelay:dl];
}

- (void)showErrorMessage:(NSError*)error{
//    NSDictionary *errs=error.userInfo;
//    NSString *code=[self getErrCode:[errs objectForKey:@"errors"]];
//    NSString *err_code=[NSString stringWithFormat:@"ERR_%@",code];
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[AppDelegate localized:@"ERROR" defaultValue:nil]
//                                                       message:[AppDelegate localized:err_code defaultValue:code]
//                                                      delegate:self
//                                             cancelButtonTitle:[AppDelegate localized:@"btnClose" defaultValue:nil]
//                                             otherButtonTitles:nil, nil];
//    
//    [alertView show];
}
#pragma mark alert
- (void)showAlert:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion{
    
}
#pragma mark 错误处理
- (NSString*)getErrCode:(id)obj{
    NSMutableString *str=[NSMutableString stringWithString:@"UNKNOW"];
//    NSArray *arrErrs;
//    if (!ObjClass(obj, [NSArray class])) {
//        return str;
//    }
//    arrErrs=(NSArray*)obj;
//    if (arrErrs.count) {
//        NSDictionary *dd=[arrErrs objectAtIndex:0];
//        if ([dd objectForKey:@"err_code"]) {
//            return [dd objectForKey:@"err_code"];
//            //[str appendString:[dd objectForKey:@"err_code"]];
//            //            [str stringByAppendingString:[dd objectForKey:@"err_code"]];
//        }
//    }
    
    return str;
}
#pragma mark 控制台
- (void)showLog:(NSString*)firstObject, ...{

    NSMutableString *allStr=[[NSMutableString alloc]initWithCapacity:0];
    
    NSString *eachObject=nil;
    va_list argumentList;
    if (firstObject>=0)
    {
        [allStr appendFormat:@"%@",firstObject];
        
        va_start(argumentList, firstObject);          // scan for arguments after firstObject.
        eachObject = va_arg(argumentList, NSString*);
        while (eachObject!=nil) // get rest of the objects until nil is found
        {
//            NSLog(@"%@",eachObject);
            [allStr appendFormat:@"\n-------------------------------------------------\n%@",eachObject];
            
            eachObject = va_arg(argumentList, NSString*);
        }
        va_end(argumentList);
    }
    
    CGRect frm=self.view.bounds;
    if (vQLog==nil) {
        vQLog=[[UIView alloc]initWithFrame:frm];
        
        frm.size.height-=80;
        frm.size.width-=2;
        frm.origin.x=1;
        frm.origin.y=20;
        txtQLog=[[UITextView alloc]initWithFrame:frm];
        txtQLog.editable=NO;
        [vQLog addSubview:txtQLog];
        
        frm.size.height=60;
        
        frm.origin.y=CGRectGetMaxY(txtQLog.frame)+1;
        UIButton *btn=[[UIButton alloc]initWithFrame:frm];
        [btn addTarget:self action:@selector(hideLogAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor=[UIColor redColor];//[QYGlobal colorWithHexString:kMainColor alpha:1];
        [btn setTitle:@"关........闭" forState:UIControlStateNormal];
        [vQLog addSubview:btn];
        
        [self.view addSubview:vQLog];
    }
    
//    NSString *ss=allStr;
    if ([txtQLog.text length]) {
        [allStr appendFormat:@"\n\n++++++++++++++++++++++++++++++++++++++++++++++\n\n%@",txtQLog.text];
    }
    txtQLog.text=allStr;
    vQLog.hidden=NO;
}

- (void)hideLogAction:(id)sender{
    vQLog.hidden=YES;
    txtQLog.text=nil;
}

#pragma mark - Delegate 托管模块
#pragma mark MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    /**
     *  HUD消失，添加对应方法
     */
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    
    return YES;
}

#pragma mark UIScrollViewDelegate
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshTops enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SRRefreshView *refreshView = obj;
        [refreshView scrollViewDidScroll];
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshTops enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SRRefreshView *refreshView = obj;
        [refreshView scrollViewDidEndDraging];
    }];
    
}

#pragma mark - slimeRefresh delegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [_refreshTops enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SRRefreshView *refreshView = obj;
        [refreshView performSelector:@selector(endRefresh)
                          withObject:nil afterDelay:1.5
                             inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }];
    
}


#pragma mark －
#pragma mark 返回上一页
- (IBAction)popVCAction:(id)sender{
    if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
        if (self.navigationController.viewControllers.count>1)
            [self.navigationController popViewControllerAnimated:YES];
        else if ([self.navigationController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                //
            }];
        }
        
    }
    else if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:^{
            //
        }];
    }
}

#pragma mark - share
- (void)shareService:(ShareContentModel *)modelShare
{
    if (modelShare == nil) {
        return;
    }
    self.modelShare = modelShare;
    [[UMSocialControllerService defaultControllerService] setShareText:@"分享" shareImage:[UIImage imageNamed:@"icon"] socialUIDelegate:self];        //设置分享内容和回调对象
    [self selectPlatformService];
    
}

- (void)selectPlatformService
{
    NSString *strPlatform = @"";
    NSString *channel = @"";
    switch (self.modelShare.platform) {
        case SharePlatformSina:
        {
            strPlatform = UMShareToSina;
            channel = @"2";
        }
            break;
        case SharePlatformQQ:
        {
            strPlatform = UMShareToQzone;
            channel = @"3";
            if ([QQApiInterface isQQInstalled]) {
            } else {
                [self showError:@"您未安装QQ客户端，请先安装"];
                [self dismissShareView];
                return;
            }
        }
            break;
        case SharePlatformWechatSession:
        {
            strPlatform = UMShareToWechatSession;
            channel = @"1";
        }
            break;
        case SharePlatformWechatTimeline:
        {
            strPlatform = UMShareToWechatTimeline;
            channel = @"4";
        }
            break;
        default:
            break;
    }
    self.strChannel = channel;
    if (![self setupShareContent:strPlatform]) {
        return;
    }
//    if (self.modelShare.modelSavelog != nil) {
//        RptShareSaveLogModelR *modelR = [RptShareSaveLogModelR new];
//        modelR.channel = channel;
//        modelR.client = @"2";
//        modelR.device = @"2";
//        modelR.obj = self.modelShare.modelSavelog.shareObj;
//        modelR.objId = self.modelShare.modelSavelog.shareObjId;
//        modelR.province = self.modelShare.modelSavelog.province;
////        modelR.city = self.modelShare.modelSavelog.city;
//        modelR.city = QWGLOBALMANAGER.configure.storeCity;
//        if (modelR.city.length == 0) {
//            modelR.city = @"苏州市";
//        }
//        
//        modelR.token = QWGLOBALMANAGER.configure.userToken;//self.modelShare.modelSavelog.token;
//        [System rptShareSaveLog:modelR success:^(id responseModel) {
//            NSLog(@"success");
//        } failure:^(HttpException *e) {
//            NSLog(@"fail");
//        }];
//    }
    [UMSocialSnsPlatformManager getSocialPlatformWithName:strPlatform].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    [self dismissShareView];
}

- (BOOL)setupShareContent:(NSString *)platformName
{
    UIImage *imgShareContent = (self.modelShare.imgURL.length <= 0) ? [UIImage imageNamed:@"share_logo"] : [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.modelShare.imgURL]]];
    NSString *shareTextContent = @"";
    NSString *shareTextTitle = @"";
    NSString *shareURL = @"";
    
    switch (self.modelShare.typeShare) {
        case ShareTypeCoupon:         //促销活动分享
        {
            shareTextTitle = (self.modelShare.title.length > 0) ? self.modelShare.title : @"分享促销";
            shareTextContent = [NSString stringWithFormat:@"我在问药客户端发现了%@，很不错噢！",self.modelShare.title];
            shareURL = (self.modelShare.shareLink.length > 0) ? self.modelShare.shareLink : SHARE_URL_SYMPTOM(QWGLOBALMANAGER.configure.groupId,self.modelShare.shareID,DEVICE_IDD,QWGLOBALMANAGER.configure.userName,QWGLOBALMANAGER.configure.type);
        }
            break;
            case ShareTypeCouponProduct:    // 优惠商品分享
        {
            shareTextTitle = (self.modelShare.title.length > 0) ? self.modelShare.title : @"劲爆优惠，一手掌握";
            shareTextContent = (self.modelShare.content.length > 0) ? self.modelShare.content : @"劲爆优惠 全民疯抢 问药领优惠 购药更实惠";
            shareURL = self.modelShare.shareLink;

        }
            break;
            case ShareTypeCouponQuan:       // 优惠券分享
        {
            shareTextTitle = (self.modelShare.title.length > 0) ? self.modelShare.title : @"比快不如比实在，用问药优惠实在太赞了，你也赶紧来试试吧";
            shareTextContent = (self.modelShare.content.length > 0) ? self.modelShare.content : @"劲爆优惠 全民疯抢 问药领优惠 购药更实惠";
            NSArray *arr = [NSArray array];
            if (self.modelShare.shareID.length >0) {
                arr = [self.modelShare.shareID componentsSeparatedByString:SeparateStr];
            }
            
            shareURL = (self.modelShare.shareLink.length > 0) ? self.modelShare.shareLink : SHARE_URL_COUPON_SUCCESS_WITHVERSION(DEVICE_IDD,arr[0],arr[1],QWGLOBALMANAGER.configure.userName,QWGLOBALMANAGER.configure.type);
            
        }
            break;
            case ShareTypeChronicCouponQuan:    // 慢病券分享
        {
            shareTextTitle = (self.modelShare.title.length > 0) ? self.modelShare.title : @"比快不如比实在，用问药优惠实在太赞了，你也赶紧来试试吧";
            shareTextContent = (self.modelShare.content.length > 0) ? self.modelShare.content : @"劲爆优惠 全民疯抢 问药领优惠 购药更实惠";
            NSArray *arr = [NSArray array];
            if (self.modelShare.shareID.length >0) {
                arr = [self.modelShare.shareID componentsSeparatedByString:SeparateStr];
            }
            
            shareURL = (self.modelShare.shareLink.length > 0) ? self.modelShare.shareLink : SHARE_URL_COUPON_SUCCESS_WITHVERSION(DEVICE_IDD,arr[0],arr[1],QWGLOBALMANAGER.configure.userName,QWGLOBALMANAGER.configure.type);

            imgShareContent = [UIImage imageNamed:@"img_share_money"];
        }
            break;
        case ShareTypeStorePoster:     // 门店海报分享
        {
            NSArray *arr = [NSArray array];
            if (self.modelShare.shareID.length >0) {
                arr = [self.modelShare.shareID componentsSeparatedByString:SeparateStr];
            }
            shareTextTitle = (self.modelShare.title.length > 0) ? self.modelShare.title : @"分享优惠活动";
            shareTextContent = (self.modelShare.content.length > 0) ? self.modelShare.content : @"";
            shareURL = (self.modelShare.shareLink.length > 0) ? self.modelShare.shareLink : [NSString stringWithFormat:@"%@pharmacy/html/store_poster.html?id=%@&branchId=%@&type=1",H5_WAP_URL,arr[0],arr[1]];
        }
            break;
        case ShareTypeBranchLogoPreview:     // 商家门店宣传预览
        {
            shareTextTitle = (self.modelShare.title.length > 0) ? self.modelShare.title : @"";
            shareTextContent = (self.modelShare.content.length > 0) ? self.modelShare.content : @"";
            shareURL = (self.modelShare.shareLink.length > 0) ? [NSString stringWithFormat:@"%@&account=%@&accountType=%@",self.modelShare.shareLink,QWGLOBALMANAGER.configure.userName,QWGLOBALMANAGER.configure.type] : SHARE_URL_WITHSTOREPOSTER(self.modelShare.shareID,QWGLOBALMANAGER.configure.userName,QWGLOBALMANAGER.configure.type);
        }
            break;
        case ShareTypePostDetail:
        {
            // 帖子详情分享
            shareTextTitle = self.modelShare.title;
            shareTextContent = self.modelShare.content;
            shareURL = (self.modelShare.shareLink.length > 0) ? self.modelShare.shareLink : SHARE_URL_POST_DETAIL(self.modelShare.shareID,DEVICE_ID);
        }
            break;
        case ShareTypeInternalProduct:      //分享本店商品
        {
            shareTextTitle = self.modelShare.title;
            shareTextContent = self.modelShare.content;
            shareURL = self.modelShare.shareLink;
            shareTextContent = @"可以线上下单，送药上门喽，快来体验啊";
        }
            break;
        case ShareTypeMerchant:      //分享本店商品
        {
            shareTextTitle = self.modelShare.title;
            shareTextContent = self.modelShare.content;
            shareURL = self.modelShare.shareLink;
        }
            break;
        case ShareTypeOuterLink:   //外链的分享
        {
            // 分享外链
            shareTextTitle = self.modelShare.title;//[NSString stringWithFormat:@"劲爆优惠，一手掌握"];
            shareTextContent = (self.modelShare.content.length > 0) ? self.modelShare.content : [NSString stringWithFormat:@""];
            shareURL = self.modelShare.shareLink;
        }
            break;
        default:
            break;
    }
    //短信、qq好友
    if (shareTextTitle.length == 0) {
        [self showError:@"无法获取分享内容，请稍后重试"];
        [self dismissShareView];
        return NO;
    }
    if (shareURL.length == 0) {
        [self showError:@"无法获取分享内容，请稍后重试"];
        [self dismissShareView];
        return NO;
    }
    if (imgShareContent == nil) {
        imgShareContent = [UIImage imageNamed:@"share_logo"];
    }
    if (platformName == UMShareToQzone) {
        
        [UMSocialData defaultData].extConfig.qzoneData.shareImage = imgShareContent;
        [UMSocialData defaultData].extConfig.qzoneData.title = shareTextTitle;
        [UMSocialData defaultData].extConfig.qzoneData.shareText = shareTextContent;
        [UMSocialData defaultData].extConfig.qzoneData.url = shareURL;

        //微信
    }else if (platformName == UMShareToWechatSession){
        
        [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTextTitle;
        [UMSocialData defaultData].extConfig.wechatSessionData.shareText = shareTextContent;
        [UMSocialData defaultData].extConfig.wechatSessionData.shareImage = imgShareContent;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = shareURL;

    }//微信朋友圈
    else if (platformName == UMShareToWechatTimeline){
        
        if ((self.modelShare.typeShare == ShareTypeCouponProduct)||
            (self.modelShare.typeShare == ShareTypeChronicCouponQuan)||
            (self.modelShare.typeShare == ShareTypeCouponQuan)) {
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTextContent;
        } else {
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTextTitle;
        }
        [UMSocialData defaultData].extConfig.wechatTimelineData.shareText = shareTextContent;
        [UMSocialData defaultData].extConfig.wechatTimelineData.shareImage = imgShareContent;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareURL;
        
        //新浪微博、腾讯微博 self.infoDict[@"htmlUrl"]
    }else if (platformName == UMShareToSina) {
        
        [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@,%@",shareTextContent,shareURL];
        [UMSocialData defaultData].extConfig.sinaData.shareImage = imgShareContent;
        [[UMSocialData defaultData].extConfig.sinaData.urlResource setResourceType:UMSocialUrlResourceTypeDefault url:shareURL];
        
 
    } else {
        //其他分享平台
    }
    return YES;
}

- (void)popUpShareView:(ShareContentModel *)modelShare
{
    if (modelShare == nil) {
        return;
    }

    self.modelShare = modelShare;
    if (self.viewCusShare == nil) {
        self.viewCusShare = (CustomShareView *)[[NSBundle mainBundle] loadNibNamed:@"CustomShareView" owner:self options:nil][0];
        [[[[UIApplication sharedApplication] delegate] window] addSubview:self.viewCusShare];
        [self.viewCusShare.btnDismissShareView addTarget:self
                                                  action:@selector(dismissShareView)
                                        forControlEvents:UIControlEventTouchUpInside];
        [self.viewCusShare.btnShareWeChatTimeline addTarget:self
                                                     action:@selector(btnPressedShareToPlatform:) forControlEvents:UIControlEventTouchUpInside];
        [self.viewCusShare.btnShareWeChatSession addTarget:self
                                                    action:@selector(btnPressedShareToPlatform:) forControlEvents:UIControlEventTouchUpInside];
        [self.viewCusShare.btnShareQZone addTarget:self
                                            action:@selector(btnPressedShareToPlatform:) forControlEvents:UIControlEventTouchUpInside];
        [self.viewCusShare.btnShareSina addTarget:self
                                           action:@selector(btnPressedShareToPlatform:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    self.viewCusShare.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [UIView animateWithDuration:0.25 animations:^{
        self.viewCusShare.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)btnPressedShareToPlatform:(id)sender
{
    UIButton *btnShare = (UIButton *)sender;
    if (btnShare == self.viewCusShare.btnShareWeChatTimeline) {
        self.modelShare.platform = SharePlatformWechatTimeline;
    } else if (btnShare == self.viewCusShare.btnShareWeChatSession) {
        self.modelShare.platform = SharePlatformWechatSession;
    } else if (btnShare == self.viewCusShare.btnShareQZone) {
        self.modelShare.platform = SharePlatformQQ;
    } else if (btnShare == self.viewCusShare.btnShareSina) {
        self.modelShare.platform = SharePlatformSina;
    }

    NSString *strShareLink = @"";
    
    switch (self.modelShare.typeShare) {
        case ShareTypeCoupon:         //促销活动分享
        {
            
            NSString *userInfo = @"";
            if (QWGLOBALMANAGER.configure.userName && ![QWGLOBALMANAGER.configure.userName isEqualToString:@""]) {
                userInfo = QWGLOBALMANAGER.configure.userName;
            }else{
                userInfo = @"11111111111";
            }

            strShareLink = (self.modelShare.shareLink.length > 0) ? self.modelShare.shareLink : SHARE_URL_SYMPTOM(QWGLOBALMANAGER.configure.groupId,self.modelShare.shareID,DEVICE_IDD,userInfo,QWGLOBALMANAGER.configure.type);
        }
            break;
        case ShareTypeCouponProduct:    // 优惠商品分享
        {
            strShareLink = [NSString stringWithFormat:@"%@&account=%@&accountType=%@",self.modelShare.shareLink,QWGLOBALMANAGER.configure.userName,QWGLOBALMANAGER.configure.type];
        }
            break;
        case ShareTypeCouponQuan:       // 优惠券分享
        {
            NSArray *arr = [NSArray array];
            if (self.modelShare.shareID.length >0) {
                arr = [self.modelShare.shareID componentsSeparatedByString:SeparateStr];
            }
            
            strShareLink = (self.modelShare.shareLink.length > 0) ? self.modelShare.shareLink : SHARE_URL_COUPON_SUCCESS_WITHVERSION(DEVICE_IDD,arr[0],arr[1],QWGLOBALMANAGER.configure.userName,QWGLOBALMANAGER.configure.type);
            
        }
            break;
        case ShareTypeChronicCouponQuan:    // 慢病券分享
        {
            NSArray *arr = [NSArray array];
            if (self.modelShare.shareID.length >0) {
                arr = [self.modelShare.shareID componentsSeparatedByString:SeparateStr];
            }
            
            strShareLink = (self.modelShare.shareLink.length > 0) ? self.modelShare.shareLink : SHARE_URL_COUPON_SUCCESS_WITHVERSION(DEVICE_IDD,arr[0],arr[1],QWGLOBALMANAGER.configure.userName,QWGLOBALMANAGER.configure.type);
         
        }
            break;
        case ShareTypeStorePoster:     // 门店海报分享
        {
            NSArray *arr = [NSArray array];
            if (self.modelShare.shareID.length >0) {
                arr = [self.modelShare.shareID componentsSeparatedByString:SeparateStr];
            }
            strShareLink = (self.modelShare.shareLink.length > 0) ? self.modelShare.shareLink : [NSString stringWithFormat:@"%@pharmacy/html/store_poster.html?id=%@&branchId=%@&type=1",H5_WAP_URL,arr[0],arr[1]];
        }
            break;
        case ShareTypeBranchLogoPreview:     // 商家门店宣传预览
        {
            strShareLink = (self.modelShare.shareLink.length > 0) ? [NSString stringWithFormat:@"%@&account=%@&accountType=%@",self.modelShare.shareLink,QWGLOBALMANAGER.configure.userName,QWGLOBALMANAGER.configure.type] : SHARE_URL_WITHSTOREPOSTER(self.modelShare.shareID,QWGLOBALMANAGER.configure.userName,QWGLOBALMANAGER.configure.type);
        }
            break;
        case ShareTypePostDetail:
        {
            strShareLink = (self.modelShare.shareLink.length > 0) ? self.modelShare.shareLink : SHARE_URL_POST_DETAIL(self.modelShare.shareID,DEVICE_ID);
        }
            break;
        case ShareTypeInternalProduct:      // 分享本店商品
        {
            strShareLink = self.modelShare.shareLink;
        }
            break;
        case ShareTypeMerchant:              // 本店分享
        {
            strShareLink = self.modelShare.shareLink;
        }
            break;
        case ShareTypeOuterLink://外链分享
        {
            strShareLink = self.modelShare.shareLink;
        }
            break;
        default:
            break;
    }
    
    // 长连接转换短链接
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"originalUrl"] = StrFromObj(strShareLink);
    [System systemShortWithParams:setting success:^(id obj) {
        if ([obj[@"apiStatus"] integerValue] == 0) {
            NSString * sinaUrl = obj[@"shortUrl"];
            self.modelShare.shareLink = sinaUrl;
            if (btnShare == self.viewCusShare.btnShareWeChatTimeline) {
                self.modelShare.platform = SharePlatformWechatTimeline;
            } else if (btnShare == self.viewCusShare.btnShareWeChatSession) {
                self.modelShare.platform = SharePlatformWechatSession;
            } else if (btnShare == self.viewCusShare.btnShareQZone) {
                self.modelShare.platform = SharePlatformQQ;
            } else if (btnShare == self.viewCusShare.btnShareSina) {
                self.modelShare.platform = SharePlatformSina;
            }
            [self shareService:self.modelShare];
        }else{
            if (btnShare == self.viewCusShare.btnShareWeChatTimeline) {
                self.modelShare.platform = SharePlatformWechatTimeline;
            } else if (btnShare == self.viewCusShare.btnShareWeChatSession) {
                self.modelShare.platform = SharePlatformWechatSession;
            } else if (btnShare == self.viewCusShare.btnShareQZone) {
                self.modelShare.platform = SharePlatformQQ;
            } else if (btnShare == self.viewCusShare.btnShareSina) {
                self.modelShare.platform = SharePlatformSina;
            }
            [self shareService:self.modelShare];
        }
    } failure:^(HttpException *e) {
        if (btnShare == self.viewCusShare.btnShareWeChatTimeline) {
            self.modelShare.platform = SharePlatformWechatTimeline;
        } else if (btnShare == self.viewCusShare.btnShareWeChatSession) {
            self.modelShare.platform = SharePlatformWechatSession;
        } else if (btnShare == self.viewCusShare.btnShareQZone) {
            self.modelShare.platform = SharePlatformQQ;
        } else if (btnShare == self.viewCusShare.btnShareSina) {
            self.modelShare.platform = SharePlatformSina;
        }
        [self shareService:self.modelShare];
    }];

}

- (void)dismissShareView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.viewCusShare.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{

}

#pragma mark -
#pragma mark 社会分享delegate
//- (void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response
//{
//    NSLog(@"+++++++ success");
//}
//
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"+++++++ success");
    if (response.responseCode == UMSResponseCodeSuccess) {
        [self shareFeedbackSuccess];
    } else {
        DDLogError(@"fail error %@",response.description);
    }
    //    [self didFinishGetUMSocialDataInViewController:response];
}

- (void)callSaveLogRequest:(RptShareSaveLogModelR *)modelSave
{
    [System rptShareSaveLog:modelSave success:^(id responseModel) {
        NSString *strChanged = responseModel[@"taskChanged"];
        DDLogVerbose(@"success, response is %@",strChanged);
        if ([strChanged intValue] == 1) {
            //  NSInteger intScore = [QWGLOBALMANAGER rewardScoreWithTaskKey:[NSString stringWithFormat:@"SHARE"]];
            [QWProgressHUD showSuccessWithStatus:@"分享成功!" hintString:[NSString stringWithFormat:@"+%@",responseModel[@"score"]] duration:2.0];
            //                [self reloadDataAfterShare];
            
            
        }
    } failure:^(HttpException *e) {
        NSLog(@"fail");
    }];

}

- (void)shareFeedbackSuccess
{
    NSLog(@"### 分享成功");
    NSLog(@"model share is %d",self.modelShare.typeShare);
    if (self.modelShare.typeShare == ShareTypePostDetail) {
        PostShareR* postShareR = [PostShareR new];
        postShareR.token = QWGLOBALMANAGER.configure.expertToken;
        postShareR.postId = self.modelShare.shareID;
        // （1:微信, 2:微博, 3:QQ, 4:朋友圈）
        switch (self.modelShare.platform) {
            case SharePlatformWechatTimeline:
                postShareR.channel = 4;
                break;
            case SharePlatformWechatSession:
                postShareR.channel = 1;
                break;
                
            case SharePlatformQQ:
                postShareR.channel = 3;
                break;
            case SharePlatformSina:
                postShareR.channel = 2;
                break;
            default:
                break;
        }
        
        [Forum sharePost:postShareR success:^(BaseAPIModel *baseAPIModel) {
            if ([baseAPIModel.apiStatus integerValue] == 0) {
                DebugLog(@"分享成功  渠道: %@", postShareR);
            }
        } failure:^(HttpException *e) {
            DebugLog(@"分享失败  error : %@", e);
        }];
    } else {
        RptShareSaveLogModelR *modelR = [RptShareSaveLogModelR new];
        modelR.channel = self.strChannel;
        modelR.client = @"2";
        modelR.device = @"2";
        modelR.obj = self.modelShare.modelSavelog.shareObj;
        modelR.objId = self.modelShare.modelSavelog.shareObjId;
        modelR.province = self.modelShare.modelSavelog.province;
        modelR.city = self.modelShare.modelSavelog.city;
        if (modelR.city.length == 0) {
            modelR.city = @"苏州市";
        }
        modelR.token = QWGLOBALMANAGER.configure.userToken;//self.modelShare.modelSavelog.token;
        [self callSaveLogRequest:modelR];
    }
}

- (void)shareFeedbackFailed
{
    NSLog(@"### 分享失败");
    NSLog(@"model share is %d",self.modelShare.typeShare);
}

#pragma mark 用来slide的View
- (void)viewDidCurrentView{

}

- (void)zoomClick{
    
}
@end
