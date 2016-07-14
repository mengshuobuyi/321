//
//  QWBaseTableVC.m
//  wenYao-store
//
//  Created by PerryChen on 7/29/15.
//  Copyright (c) 2015 carret. All rights reserved.
//

#import "QWBaseTableVC.h"
#import "AppDelegate.h"
#import "viewCustomAnimate.h"

static float kTopBarItemWidth = 40;
static float kDelay = 1.2f;
static float kTopBackBtnMargin = -13.f;
static float kTopBtnMargin = -16.f;
@interface QWBaseTableVC ()
{
    UIView *vQLog;
    //    UIView *vInfo;
    UITextView *txtQLog;
}
@end

@implementation QWBaseTableVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.navigationController.viewControllers.count<=1 && _backButtonEnabled == NO)
        return;
    else
        [self naviBackBotton];
    
    //[MobClick beginLogPageView:StrFromObj([self class])];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[MobClick endLogPageView:StrFromObj([self class])];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
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

- (void)removeInfoView{
    [self.vInfo removeFromSuperview];
}

- (IBAction)viewInfoClickAction:(id)sender{
    
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

    hud.removeFromSuperViewOnHide = YES;
    
    double dl=(delay>0)?delay:1.f;
    [hud hide:YES afterDelay:dl];
}

- (void)showErrorMessage:(NSError*)error{

}
#pragma mark alert
- (void)showAlert:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion{
    
}
#pragma mark 错误处理
- (NSString*)getErrCode:(id)obj{
    NSMutableString *str=[NSMutableString stringWithString:@"UNKNOW"];
    
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
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

#pragma mark 用来slide的View
- (void)viewDidCurrentView{
    
}

- (void)zoomClick{
    
}


@end
