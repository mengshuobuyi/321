//
//  IndexViewController.m
//  wenYao-store
//
//  Created by YYX on 15/8/17.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "IndexViewController.h"
#import "IndexCollectionViewCell.h"
#import "IndexTopCollectionCell.h"
#import "IndexAuthCollectionCell.h"
#import "QWYSViewController.h"
#import "OrganAuthTotalViewController.h"
#import "OrganAuthBridgeViewController.h"
#import "OrganAuthCommitOkViewController.h"

//其他的模块--验证码
#import "CustomVerify.h"
#import "VerifyDetailViewController.h"
#import "Verify.h"
#import "MyStatiticsViewController.h"
#import "EvaluationViewController.h"
#import "SearchSliderViewController.h"
#import "HealthQASearchViewController.h"
#import "MyActivityViewController.h"
#import "AllTipsViewController.h"
#import "BranchViewController.h"
#import "HomePageViewController.h"
#import "AllScanReaderViewController.h"
#import "QYPhotoAlbum.h"
#import "ShowBranchCodeViewController.h"
#import "SendPromotionViewController.h"
#import "IMApi.h"
#import "InfoNotifiViewController.h"
#import "MyIndentViewController.h"
#import "BranchAppraiseViewController.h"
#import "FinderSearchViewController.h"
#import "IndentDetailListViewController.h"
#import "Circle.h"
#import "InternalProductListViewController.h"
#import "WechatActivityViewController.h"
@interface IndexViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,IndexTopCollectionCellDelegate,CustomVerifyDelegate,IndexAuthCollectionCellDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionview;

@property (strong, nonatomic) NSMutableArray *titleItems;

@property (strong, nonatomic) NSMutableArray *imageArray;

// 请输入验证码的view 固定不滑动
@property (weak, nonatomic) IBOutlet UIView *inputTopView;

// 输入框的背景图片
@property (weak, nonatomic) IBOutlet UIImageView *inputTextFieldBg;

// 消息盒子的未读小红点
@property (strong, nonatomic) UIImageView *rightRedDot;


// 接通知 1数字 0红点 －1无
@property (assign, nonatomic) int passNumber;

// collectionView 距离view 的top 约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionTopConstraint;

@property (weak, nonatomic) IBOutlet UIView *inputTapView;

// 扫码，验证判断两证是否齐全
@property (strong, nonatomic) BaseAPIModel *isScanModel;

//其他的模块---验证码
@property (nonatomic,assign)BOOL isOpen;
@property (nonatomic)CustomVerify *padView;
@property (nonatomic, strong) NSMutableString *strContent;

@property (nonatomic, assign) NSInteger intOrderNum;

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitleItem];
    [self configureCollectionView];
    
    if (AUTHORITY_ROOT){ // 全维药事
        [self setUpRightItem];
    }
    
    // 输入框背景 UI
    self.inputTopView.backgroundColor = RGBHex(qwColor1);
    self.inputTextFieldBg.backgroundColor = RGBHex(0x57b2a3);
    self.inputTextFieldBg.layer.cornerRadius = 4.0;
    self.inputTextFieldBg.layer.masksToBounds = YES;
    
    // 弹出自定义键盘，输入验证码
    [self.codeInputFiled setValue:RGBAHex(qwColor4, 0.5) forKeyPath:@"_placeholderLabel.textColor"];
    self.codeInputFiled.placeholder = @"请输入验证码/收货码";
    self.codeInputFiled.font = fontSystem(kFontS2);
    self.padView = nil;
    
    //点击输入框 键盘 up down
    self.inputTapView.userInteractionEnabled = YES;
    UITapGestureRecognizer * t = [[UITapGestureRecognizer alloc] init];
    [t addTarget:self action:@selector(tapInputView)];
    [self.inputTapView addGestureRecognizer:t];
    
    //增加上滑的手势
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:recognizer];
}

#pragma mark ---- 点击输入框 ----
- (void)tapInputView
{
    if([self.isScanModel.apiStatus integerValue] == 4) {
        [SVProgressHUD showErrorWithStatus:@"证照不全,无法验证！" duration:2.0f];
        return;
    }
    
    [self inputVerifyCodeAction];
}

#pragma mark ---- 上滑键盘消失 ----

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(self.isOpen){
        if(recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
            
            // 清空输入的数字
            self.strContent = [@"" mutableCopy];
            self.codeInputFiled.text = self.strContent;
            
            // 隐藏删除按钮
            self.deleteCodeButton.hidden=YES;
            
            // 键盘view消失
            [self inputVerifyCodeAction];
            return;
        }
    }else{
        return;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 首页的 数字 与 红点 变化通知
    [QWGLOBALMANAGER refreshAllHint];
    
    //全局拉消息，更新红点
    [QWGLOBALMANAGER getAllConsult];
    
    //判断两证是否齐全
    [self checkCertVaildate];
    
    // 判断机构是否认证
    [self configureAuthView];
    
    [self configureArray];
    
    //验证码
    self.isOpen=YES;
    self.strContent = [@"" mutableCopy];
    self.codeInputFiled.text = self.strContent;
    self.deleteCodeButton.hidden = YES;
    [self inputVerifyCodeAction];
}

#pragma mark ---- 设置CollectionView属性 ----

- (void)configureCollectionView
{
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc ] init];
    layOut.minimumLineSpacing = 0;
    layOut.minimumInteritemSpacing = 0;
    layOut.sectionInset = UIEdgeInsetsMake(0 , 0, 0, 0);
    self.myCollectionview.collectionViewLayout = layOut;
    self.myCollectionview.alwaysBounceVertical = YES;
}

#pragma mark ---- 初始化数组 ----

- (void)configureArray
{
    if (AUTHORITY_ROOT) {
        
        // 主账号
        if (OrganAuthPass) {
            
            // 已认证
            
            if (QWGLOBALMANAGER.configure.storeType == 3)
            {
                //开通微商
                self.titleItems = [NSMutableArray arrayWithObjects:@"咨询",@"统计",@"本店活动",@"本店优惠",@"本店商品",@"本店二维码",@"药病症问答库",@"本店评价",@"", nil];
                self.imageArray = [NSMutableArray arrayWithObjects:@"icon_consultation",@"icon_statistics",@"icon_shopActivity1",@"icon_shopDiscount",@"icon_shopgoods",@"icon_index_code",@"icon_knowledgeBase",@"icon_shopEvaluation",@"", nil];
            }else
            {
                //未开通微商
                self.titleItems = [NSMutableArray arrayWithObjects:@"咨询",@"统计",@"本店活动",@"本店优惠",@"本店二维码",@"药病症问答库",@"本店评价",@"",@"", nil];
                self.imageArray = [NSMutableArray arrayWithObjects:@"icon_consultation",@"icon_statistics",@"icon_shopActivity1",@"icon_shopDiscount",@"icon_index_code",@"icon_knowledgeBase",@"icon_shopEvaluation",@"",@"", nil];
            }
            
        }else{
            
            // 未认证
            
            if (QWGLOBALMANAGER.configure.storeType == 3)
            {
                //开通微商
                self.titleItems = [NSMutableArray arrayWithObjects:@"咨询",@"统计",@"本店活动",@"本店优惠",@"本店商品",@"本店二维码",@"本店评价",@"",@"", nil];
                self.imageArray = [NSMutableArray arrayWithObjects:@"icon_consultation",@"icon_statistics",@"icon_shopActivity1",@"icon_shopDiscount",@"icon_shopgoods",@"icon_index_code",@"icon_shopEvaluation",@"",@"", nil];
            }else
            {
                //未开通微商
                self.titleItems = [NSMutableArray arrayWithObjects:@"咨询",@"统计",@"本店活动",@"本店优惠",@"本店二维码",@"本店评价", nil];
                self.imageArray = [NSMutableArray arrayWithObjects:@"icon_consultation",@"icon_statistics",@"icon_shopActivity1",@"icon_shopDiscount",@"icon_index_code",@"icon_shopEvaluation", nil];
            }
            
        }
    }else
    {
        // 子账号
        if (OrganAuthPass) {
            
            // 已认证
            
            if (QWGLOBALMANAGER.configure.storeType == 3)
            {
                //开通微商
                self.titleItems = [NSMutableArray arrayWithObjects:@"本店活动",@"本店优惠",@"本店商品",@"本店二维码",@"药病症问答库",@"本店评价", nil];
                self.imageArray = [NSMutableArray arrayWithObjects:@"icon_shopActivity1",@"icon_shopDiscount",@"icon_shopgoods",@"icon_index_code",@"icon_knowledgeBase",@"icon_shopEvaluation",nil];
            }else
            {
                //未开通微商
                self.titleItems = [NSMutableArray arrayWithObjects:@"本店活动",@"本店优惠",@"本店二维码",@"药病症问答库",@"本店评价",@"", nil];
                self.imageArray = [NSMutableArray arrayWithObjects:@"icon_shopActivity1",@"icon_shopDiscount",@"icon_index_code",@"icon_knowledgeBase",@"icon_shopEvaluation",@"", nil];
            }
            
        }else{
            
            // 未认证
            
            if (QWGLOBALMANAGER.configure.storeType == 3)
            {
                //开通微商
                self.titleItems = [NSMutableArray arrayWithObjects:@"本店优惠",@"本店商品",@"本店活动",@"本店评价",@"本店二维码",@"", nil];
                self.imageArray = [NSMutableArray arrayWithObjects:@"icon_shopDiscount",@"icon_shopgoods",@"icon_shopActivity1",@"icon_shopEvaluation",@"icon_index_code",@"", nil];
            }else
            {
                //未开通微商
                self.titleItems = [NSMutableArray arrayWithObjects:@"本店优惠",@"本店活动",@"本店评价",@"本店二维码",@"",@"", nil];
                self.imageArray = [NSMutableArray arrayWithObjects:@"icon_shopDiscount",@"icon_shopActivity1",@"icon_shopEvaluation",@"icon_index_code",@"",@"", nil];
            }
            
        }
    }

}

#pragma mark ---- 判断机构是否经过认证 改变列表的 frame ----

- (void)configureAuthView
{
    // 判断机构是否经过认证
    
    if (OrganAuthPass)
    {
        // 已认证
        self.collectionTopConstraint.constant = 74;
        self.inputTopView.hidden = NO;
       
    }else
    {
        // 未认证
        self.collectionTopConstraint.constant = 0;
        self.inputTopView.hidden = YES;
    }
}

#pragma mark ---- 设置title ----

- (void)setTitleItem
{
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 22)];
    titleLab.text = @"问药商家";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = font(kFont2, kFontS2);
    self.navigationItem.titleView = titleLab;
}

#pragma mark ---- 设置rightItem ----

- (void)setUpRightItem
{
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = -15;
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    bg.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(18, -1, 60, 44);
    [btn setImage:[UIImage imageNamed:@"icon_index_news"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_index_news"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(pushToQWYS) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightRedDot = [[UIImageView alloc] initWithFrame:CGRectMake(52, 8, 10, 10)];
    [self.rightRedDot setImage:[UIImage imageNamed:@"img_redDot"]];
    
    [bg addSubview:btn];
    [bg addSubview:self.rightRedDot];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:bg];
   self.navigationItem.rightBarButtonItems = @[fixed,item];
}

#pragma mark ---- 进入全维消息 ----

- (void)pushToQWYS
{
    self.deleteCodeButton.hidden = YES;
    self.padView.hidden=YES;
    
    InfoNotifiViewController *demoViewController = [[UIStoryboard storyboardWithName:@"InfoNotifi" bundle:nil] instantiateViewControllerWithIdentifier:@"InfoNotifiViewController"];
    demoViewController.hidesBottomBarWhenPushed = YES;
    demoViewController.isAppearQWYSRedDot = self.rightRedDot.hidden;
    [self.navigationController pushViewController:demoViewController animated:YES];
}

#pragma mark ---- CollectionView 代理 ----

//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titleItems.count+1;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (OrganAuthPass) {
        
        // 已认证
        
        if (indexPath.item == 0)
        {
            IndexTopCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IndexTopCollectionCell" forIndexPath:indexPath];
            if (self.intOrderNum > 0) {
                cell.redDotOrder.hidden = NO;
            } else {
                cell.redDotOrder.hidden = YES;
            }
            cell.indexTopCollectionCellDelegate = self;
            return cell;
            
        }else
        {
            IndexCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IndexCollectionViewCell" forIndexPath:indexPath];
            cell.titleText.text = self.titleItems[indexPath.item-1];
            cell.contentImage.image = [UIImage imageNamed:self.imageArray[indexPath.item-1]];
            
            if (AUTHORITY_ROOT && indexPath.item == 1)
            {
                // 主账号 咨询
                
                if (self.passNumber > 0)
                {
                    //显示数字
                    cell.redDot.hidden = YES;
                    cell.redNumLabel.hidden = NO;
                    cell.redNumLabel.text = [NSString stringWithFormat:@"%d",self.passNumber];
                    
                }else if (self.passNumber == 0)
                {
                    //显示小红点
                    cell.redDot.hidden = NO;
                    cell.redNumLabel.hidden = YES;
                    
                }else if (self.passNumber < 0)
                {
                    //全部隐藏
                    cell.redDot.hidden = YES;
                    cell.redNumLabel.hidden = YES;
                }
            }else{
                cell.redNumLabel.hidden = YES;
                cell.redDot.hidden = YES;
            }
            
            return cell;
        }
        
    }else
    {
        // 未认证
        
        if (indexPath.item == 0)
        {
            IndexAuthCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IndexAuthCollectionCell" forIndexPath:indexPath];
            cell.indexAuthCollectionCellDelegate = self;
            cell.accountLabel.text = QWGLOBALMANAGER.configure.userName;
            
            if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 1) {
                // 1, 待审核  资料已提交页面
                [cell.authButton setTitle:@"审核中" forState:UIControlStateNormal];
            }else if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 2){
                // 2, 审核不通过  带入老数据的认证流程
                [cell.authButton setTitle:@"立即认证" forState:UIControlStateNormal];
            }else if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 4){
                // 4, 未提交审核  认证流程
                [cell.authButton setTitle:@"立即认证" forState:UIControlStateNormal];
            }else{
                // 3, 审核通过    功能正常
            }

            return cell;
            
        }else
        {
            IndexCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IndexCollectionViewCell" forIndexPath:indexPath];
            cell.titleText.text = self.titleItems[indexPath.item-1];
            cell.contentImage.image = [UIImage imageNamed:self.imageArray[indexPath.item-1]];
            return cell;
        }
    }
    
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (OrganAuthPass) {
        
        // 已认证
        
        if (indexPath.item == 0) {
            return CGSizeMake(SCREEN_W, 83);
        }else{
            
            if (IS_IPHONE_6 || IS_IPHONE_6P) {
                return CGSizeMake((SCREEN_W/3)-0.7, 100);
            }else{
                return CGSizeMake(floorf(SCREEN_W/3), 100);
            }
        }
        
    }else
    {
        // 未认证
        if (indexPath.item == 0) {
            return CGSizeMake(SCREEN_W, 170);
        }else{
            
            if (IS_IPHONE_6 || IS_IPHONE_6P) {
                return CGSizeMake((SCREEN_W/3)-0.7, 100);
            }else{
                return CGSizeMake(floorf(SCREEN_W/3), 100);
            }
        }
    }
    
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    self.padView.hidden=YES;
    
    if (OrganAuthPass) {
        
        // 已认证
        
        if (AUTHORITY_ROOT) {
            
            // 主账号
            
            if (QWGLOBALMANAGER.configure.storeType == 3)
            {
                //开通微商
                if (indexPath.item == 1) {
                    
                    // 咨询
                    HomePageViewController *vc = [[HomePageViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else if (indexPath.item == 2){
                    
                    // 统计
                    MyStatiticsViewController *viewcontroller=[[UIStoryboard storyboardWithName:@"MyStatistics" bundle:nil] instantiateViewControllerWithIdentifier:@"MyStatiticsViewController"];
                    viewcontroller.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:viewcontroller animated:YES];
                    
                }else if (indexPath.item == 3){
                    
                    // 本店活动
                    MyActivityViewController *myorder=[[MyActivityViewController alloc]init];
                    myorder.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:myorder animated:YES];
                    
                }else if (indexPath.item == 4){
                    
                    // 本店优惠
                    BranchViewController *vc = [[BranchViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else if (indexPath.item == 5){
                    
                    //本店商品
                    UIStoryboard *sbInternalProduct = [UIStoryboard storyboardWithName:@"InternalProduct" bundle:nil];
                    InternalProductListViewController *vcProductList = [sbInternalProduct instantiateViewControllerWithIdentifier:@"InternalProductListViewController"];
                    vcProductList.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vcProductList animated:YES];
                    
                }else if (indexPath.item == 6){
                    
                    //本店二维码
                    ShowBranchCodeViewController *branchCodeViewController = [[ShowBranchCodeViewController alloc] initWithNibName:@"ShowBranchCodeViewController" bundle:nil];
                    branchCodeViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:branchCodeViewController animated:YES];
                    
                }else if (indexPath.item == 7){
                    
                    // 药病症问答库
                    FinderSearchViewController * searchViewController = [[FinderSearchViewController alloc] initWithNibName:@"FinderSearchViewController" bundle:nil];
                    searchViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:searchViewController animated:YES];
                    
                }else if (indexPath.item == 8){
                    
                    // 本店评价  判断是否开通微商
                    if (QWGLOBALMANAGER.configure.storeType == 3) {
                        //开通微商药房
                        BranchAppraiseViewController *vc = [[UIStoryboard storyboardWithName:@"BranchAppraise" bundle:nil] instantiateViewControllerWithIdentifier:@"BranchAppraiseViewController"];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }else{
                        //不开通微商药房
                        EvaluationViewController *viewcontroller=[[EvaluationViewController alloc] init];
                        viewcontroller.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:viewcontroller animated:YES];
                    }
                }
            }else
            {
                //未开通微商
                if (indexPath.item == 1) {
                    
                    // 咨询
                    HomePageViewController *vc = [[HomePageViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else if (indexPath.item == 2){
                    
                    // 统计
                    MyStatiticsViewController *viewcontroller=[[UIStoryboard storyboardWithName:@"MyStatistics" bundle:nil] instantiateViewControllerWithIdentifier:@"MyStatiticsViewController"];
                    viewcontroller.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:viewcontroller animated:YES];
                    
                }else if (indexPath.item == 3){
                    
                    // 本店活动
                    MyActivityViewController *myorder=[[MyActivityViewController alloc]init];
                    myorder.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:myorder animated:YES];
                    
                }else if (indexPath.item == 4){
                    
                    // 本店优惠
                    BranchViewController *vc = [[BranchViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else if (indexPath.item == 5){
                    
                    //本店二维码
                    ShowBranchCodeViewController *branchCodeViewController = [[ShowBranchCodeViewController alloc] initWithNibName:@"ShowBranchCodeViewController" bundle:nil];
                    branchCodeViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:branchCodeViewController animated:YES];
                    
                }else if (indexPath.item == 6){
                    
                    // 药病症问答库
                    FinderSearchViewController * searchViewController = [[FinderSearchViewController alloc] initWithNibName:@"FinderSearchViewController" bundle:nil];
                    searchViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:searchViewController animated:YES];
                    
                }else if (indexPath.item == 7){
                    
                    // 本店评价  判断是否开通微商
                    if (QWGLOBALMANAGER.configure.storeType == 3) {
                        //开通微商药房
                        BranchAppraiseViewController *vc = [[UIStoryboard storyboardWithName:@"BranchAppraise" bundle:nil] instantiateViewControllerWithIdentifier:@"BranchAppraiseViewController"];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }else{
                        //不开通微商药房
                        EvaluationViewController *viewcontroller=[[EvaluationViewController alloc] init];
                        viewcontroller.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:viewcontroller animated:YES];
                    }
                }
            }
            
        }else
        {
            // 子账号
            
            if (QWGLOBALMANAGER.configure.storeType == 3)
            {
                //开通微商
                if (indexPath.item == 1){
                    
                    // 本店活动
                    MyActivityViewController *myorder=[[MyActivityViewController alloc]init];
                    myorder.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:myorder animated:YES];
                    
                }else if (indexPath.item == 2){
                    
                    // 本店优惠
                    BranchViewController *vc = [[BranchViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else if (indexPath.item == 3){
                    
                    //本店商品
                    UIStoryboard *sbInternalProduct = [UIStoryboard storyboardWithName:@"InternalProduct" bundle:nil];
                    InternalProductListViewController *vcProductList = [sbInternalProduct instantiateViewControllerWithIdentifier:@"InternalProductListViewController"];
                    vcProductList.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vcProductList animated:YES];
                    
                }else if (indexPath.item == 4){
                    
                    //本店二维码
                    ShowBranchCodeViewController *branchCodeViewController = [[ShowBranchCodeViewController alloc] initWithNibName:@"ShowBranchCodeViewController" bundle:nil];
                    branchCodeViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:branchCodeViewController animated:YES];
                    
                }else if (indexPath.item == 5){
                    
                    // 药病症问答库
                    FinderSearchViewController * searchViewController = [[FinderSearchViewController alloc] initWithNibName:@"FinderSearchViewController" bundle:nil];
                    searchViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:searchViewController animated:YES];
                    
                }else if (indexPath.item == 6){

                    // 本店评价  判断是否开通微商
                    if (QWGLOBALMANAGER.configure.storeType == 3) {
                        //开通微商药房
                        BranchAppraiseViewController *vc = [[UIStoryboard storyboardWithName:@"BranchAppraise" bundle:nil] instantiateViewControllerWithIdentifier:@"BranchAppraiseViewController"];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }else{
                        //不开通微商药房
                        EvaluationViewController *viewcontroller=[[EvaluationViewController alloc] init];
                        viewcontroller.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:viewcontroller animated:YES];
                    }
                }
            }else
            {
                //未开通微商
                if (indexPath.item == 1){
                    
                    // 本店活动
                    MyActivityViewController *myorder=[[MyActivityViewController alloc]init];
                    myorder.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:myorder animated:YES];
                    
                }else if (indexPath.item == 2){
                    
                    // 本店优惠
                    BranchViewController *vc = [[BranchViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else if (indexPath.item == 3){
                    
                    //本店二维码
                    ShowBranchCodeViewController *branchCodeViewController = [[ShowBranchCodeViewController alloc] initWithNibName:@"ShowBranchCodeViewController" bundle:nil];
                    branchCodeViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:branchCodeViewController animated:YES];
                    
                }else if (indexPath.item == 4){
                    
                    // 药病症问答库
                    FinderSearchViewController * searchViewController = [[FinderSearchViewController alloc] initWithNibName:@"FinderSearchViewController" bundle:nil];
                    searchViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:searchViewController animated:YES];
                    
                }else if (indexPath.item == 5){
                    
                    // 本店评价  判断是否开通微商
                    if (QWGLOBALMANAGER.configure.storeType == 3) {
                        //开通微商药房
                        BranchAppraiseViewController *vc = [[UIStoryboard storyboardWithName:@"BranchAppraise" bundle:nil] instantiateViewControllerWithIdentifier:@"BranchAppraiseViewController"];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }else{
                        //不开通微商药房
                        EvaluationViewController *viewcontroller=[[EvaluationViewController alloc] init];
                        viewcontroller.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:viewcontroller animated:YES];
                    }
                }
            }
        }
        
    }else
    {
        // 未认证
        
        /*
         1, 待审核  资料已提交页面
         2, 审核不通过  带入老数据的认证流程
         3, 审核通过    功能正常
         4, 未提交审核  认证流程
         */
        
        if (indexPath.item == 0) {
            
        }else
        {
            if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 4 || [QWGLOBALMANAGER.configure.approveStatus integerValue] == 2)
            {
                OrganAuthBridgeViewController *vc = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganAuthBridgeViewController"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 1)
            {
                OrganAuthCommitOkViewController *vc = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganAuthCommitOkViewController"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}


#pragma mark ---- 键盘 up down Action ----

- (void)inputVerifyCodeAction
{
    if(!self.padView){
        self.padView = [CustomVerify getInstanceWithDelegate:self withCurView:[UIApplication sharedApplication].keyWindow];
        [[UIApplication sharedApplication].keyWindow addSubview:self.padView];
        self.strContent = [@"" mutableCopy];
        [self.codeInputFiled becomeFirstResponder];
        self.codeInputFiled.inputView = UIView.new;
    }
    
    if (self.isOpen)
    {
        // 消失键盘
        self.padView.hidden=YES;
        [self.codeInputFiled resignFirstResponder];
        self.tabBarController.tabBar.hidden=NO;
        [UIView animateWithDuration:0.5
                              delay:0.0
             usingSpringWithDamping:0.6
              initialSpringVelocity:1.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.padView.frame =CGRectMake(0, 138, APP_W, 0);
                             
                         } completion:^(BOOL finished) {
                             self.isOpen = NO;
                         }];
    } else
    {
        // 弹出键盘
        self.padView.hidden=NO;
        [self.codeInputFiled becomeFirstResponder];
        self.tabBarController.tabBar.hidden=YES;
        [UIView animateWithDuration:0.5
                              delay:0.0
             usingSpringWithDamping:0.6
              initialSpringVelocity:1.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                           self.padView.frame = CGRectMake(0, 138, APP_W, APP_H-NAV_H-74);
                         } completion:^(BOOL finished) {
                             self.isOpen = YES;
                         }];
    }
}


#pragma mark ---- 点击自定义键盘 ----

- (void)clickBtnIndex:(TagClicked)clickIndex
{
    NSInteger intClicked = [self convertVerifyPadToValue:clickIndex];
    if (intClicked < 0) { //点击验证按钮
        [self confirmVerifyCode];
        return;
    }
    if(intClicked==12){ //点击最底部按钮键盘消失
        [self inputVerifyCodeAction];
        return;
    }
    if (self.strContent.length >= 12) {
        return;
    }

    NSRange cursorRange = [self getInputPanelCursorPosition:self.codeInputFiled];
    if(cursorRange.location==4){
        [self.strContent insertString:[NSString stringWithFormat:@"%@",@" "] atIndex:cursorRange.location];
         cursorRange.location=cursorRange.location+1;
        [self.strContent insertString:[NSString stringWithFormat:@"%ld",(long)intClicked] atIndex:cursorRange.location];
       
    }else if(cursorRange.location==9){
        [self.strContent insertString:[NSString stringWithFormat:@"%@",@" "] atIndex:cursorRange.location];
         cursorRange.location=cursorRange.location+1;
        [self.strContent insertString:[NSString stringWithFormat:@"%ld",(long)intClicked] atIndex:cursorRange.location];
    }else{
        [self.strContent insertString:[NSString stringWithFormat:@"%ld",(long)intClicked] atIndex:cursorRange.location];
    }
    self.codeInputFiled.text = self.strContent;
    [self setTextFieldCursorPosition:YES withCurRange:cursorRange];
}

//判断是神马数字
- (NSInteger)convertVerifyPadToValue:(TagClicked)tagClick
{
    NSInteger intNum = 0;
    switch (tagClick) {
        case TagOneClick:
            intNum = 1;
            break;
        case TagTwoClick:
            intNum = 2;
            break;
        case TagThreeClick:
            intNum = 3;
            break;
        case TagFourClick:
            intNum = 4;
            break;
        case TagFiveClick:
            intNum = 5;
            break;
        case TagSixClick:
            intNum = 6;
            break;
        case TagSevenClick:
            intNum = 7;
            break;
        case TagEightClick:
            intNum = 8;
            break;
        case TagNineClick:
            intNum = 9;
            break;
        case TagZeroClick:
            intNum = 0;
            break;
        case TagConfirmClick:
            intNum = -1;
            break;
        case TagCancleClick:
            intNum = 12;
            break;
        default:
            break;
    }
    return intNum;
}

#pragma mark ---- 点击验证按钮 Action ----

- (void)confirmVerifyCode
{
    
    if (self.strContent.length == 0) {
        [SVProgressHUD showErrorWithStatus:Kwarning220N54 duration:0.8];
        return;
    }

    if (QWGLOBALMANAGER.currentNetWork == NotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8];
        return;
    }
    
    InputVerifyModelR *modelR = [InputVerifyModelR new];
    NSString *code=self.strContent;
    code = [self.strContent stringByReplacingOccurrencesOfString:@" " withString:@""];
    modelR.code = code;
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    
    [Verify GetVerifyWithParams:modelR success:^(id UFModel) {
        
        InputVerifyModel *resonModel = (InputVerifyModel *)UFModel;
        //增加收货码
        if([resonModel.apiStatus intValue] == 0)
        {
            //验证成功之后，输入框内容删除
            self.deleteCodeButton.hidden = YES;
            self.padView.hidden = YES;
            self.codeInputFiled.text = @"";
            if ([resonModel.scope intValue]==4) {//订单收货码的确认
//                IndentDetailListViewController *vc = [IndentDetailListViewController new];
//                vc.hidesBottomBarWhenPushed = YES;
//                vc.modelShop=resonModel.shopOrderDetailVO;
//                self.deleteCodeButton.hidden = YES;
//                self.padView.hidden=YES;
//               [self.navigationController pushViewController:vc animated:YES];
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"确认成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alert.tag=Enum_TypeAlert_Verify;
                [alert show];
                return ;
                
                
                
            }else if ([resonModel.scope intValue]==3) {  // 兑换商品
                
                NSMutableDictionary *setting = [NSMutableDictionary dictionary];
                setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
                setting[@"orderId"] = StrFromObj(resonModel.mallOrder.orderId);
                [Order mallOrderCompleteWithParams:setting success:^(id obj) {
                    
                    if ([obj[@"apiStatus"] integerValue] == 0) {
                        self.deleteCodeButton.hidden = YES;
                        self.strContent = [@"" mutableCopy];
                        self.codeInputFiled.text = self.strContent;
                        self.isOpen=YES;
                        [self inputVerifyCodeAction];
                       
                    }
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:obj[@"apiMessage"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                    return ;
                } failure:^(HttpException *e) {
                    [SVProgressHUD showErrorWithStatus:@"服务器异常，请稍后重试"];
                }];
                
            }else{
                VerifyDetailViewController *vc = [[VerifyDetailViewController alloc] initWithNibName:@"VerifyDetailViewController" bundle:nil];
                vc.hidesBottomBarWhenPushed = YES;
                if([resonModel.scope intValue]==1){ //优惠券
                    vc.typeCell=@"1";
                    vc.CoupnList=resonModel.coupon;
                }else if([resonModel.scope intValue]==2){ // 优惠商品
                    vc.typeCell=@"2";
                    vc.drugList=resonModel.promotion;
                }
                self.deleteCodeButton.hidden = YES;
                self.padView.hidden=YES;
                vc.scope = resonModel.coupon.scope;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:resonModel.apiMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alert.tag=Enum_TypeAlert_Verify;
            [alert show];
            return ;
        }
    } failure:^(HttpException *e) {

    }];
}

#pragma mark ---- 输入框 删除按钮 ----

- (IBAction)delecodeAction:(id)sender {
    
    /****************** 逐个删除 ******************
     
    NSRange cursorRange = [self getInputPanelCursorPosition:self.codeInputFiled];
    if (self.strContent.length > 0 && cursorRange.location > 0) {
        if(cursorRange.location==11){
         [self.strContent deleteCharactersInRange:NSMakeRange(cursorRange.location-1, 1)];
         cursorRange.location--;
         [self.strContent deleteCharactersInRange:NSMakeRange(cursorRange.location-1, 1)];
        }else if (cursorRange.location==6) {
        [self.strContent deleteCharactersInRange:NSMakeRange(cursorRange.location-1, 1)];
         cursorRange.location--;
         [self.strContent deleteCharactersInRange:NSMakeRange(cursorRange.location-1, 1)];
        }else{
         [self.strContent deleteCharactersInRange:NSMakeRange(cursorRange.location-1, 1)];
        }
        if (self.strContent.length == 0) {
            self.strContent = [@"" mutableCopy];
        }
        [self updateInputPanel];
        [self setTextFieldCursorPosition:NO withCurRange:cursorRange];
    }else{
         self.strContent = [@"" mutableCopy];
         [self updateInputPanel];
         [self setTextFieldCursorPosition:NO withCurRange:cursorRange];
    }
     ****************** 逐个删除 ******************/
    
    self.strContent = [@"" mutableCopy];
    self.codeInputFiled.text = self.strContent;
    self.deleteCodeButton.hidden=YES;
    [self setTextFieldCursorPosition:NO withCurRange:NSMakeRange(0, 0)];
    
}

// 获取键盘光标所在位置
- (NSRange)getInputPanelCursorPosition:(UITextField *)tfInput
{
    UITextRange *selectedTextRange = tfInput.selectedTextRange;
    NSUInteger location = [tfInput offsetFromPosition:tfInput.beginningOfDocument
                                           toPosition:selectedTextRange.start];
    NSUInteger length = [tfInput offsetFromPosition:selectedTextRange.start
                                         toPosition:selectedTextRange.end];
    NSRange selectedRange = NSMakeRange(location, length);
    return selectedRange;
}

- (void)setTextFieldCursorPosition:(BOOL)isAppend withCurRange:(NSRange)curRange
{
    if (self.strContent.length == 0) {
        return;
    }
    self.deleteCodeButton.hidden=NO;
    UITextPosition *beginning = self.codeInputFiled.beginningOfDocument;
    UITextPosition *start = beginning;
    if (isAppend) {
        start = [self.codeInputFiled positionFromPosition:beginning offset:curRange.location+1];
    } else {
        start = [self.codeInputFiled positionFromPosition:beginning offset:curRange.location-1];
    }
    UITextPosition *end = [self.codeInputFiled positionFromPosition:start offset:curRange.length];
    UITextRange *textRange = [self.codeInputFiled textRangeFromPosition:start toPosition:end];
    [self.codeInputFiled setSelectedTextRange:textRange];
}

#pragma mark ---- 立即认证 代理 ----

- (void)goToAuthAction
{
    /*
     1, 待审核  资料已提交页面
     2, 审核不通过  带入老数据的认证流程
     3, 审核通过    功能正常
     4, 未提交审核  认证流程
     */
    
    
    if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 4 || [QWGLOBALMANAGER.configure.approveStatus integerValue] == 2)
    {
        
        OrganAuthTotalViewController *vc = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganAuthTotalViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 1)
    {
        OrganAuthCommitOkViewController *vc = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganAuthCommitOkViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ---- 扫码验证 代理 ----

- (void)scanVerifyCodeAction
{
    if([self.isScanModel.apiStatus integerValue] == 4) {
        [SVProgressHUD showErrorWithStatus:@"证照不全,无法验证！" duration:2.0f];
        return;
    }
    
    if (![QYPhotoAlbum checkCameraAuthorizationStatus]) {
        [QWGLOBALMANAGER getCramePrivate];
        return;
    }
    AllScanReaderViewController *vc = [[AllScanReaderViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.scanType=Enum_Scan_Items_Index;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---- 我的订单 代理 ----

- (void)uploadReceiptAction
{
    if (QWGLOBALMANAGER.configure.storeType == 3) {
        //开通微商药房
        MyIndentViewController *vc = [MyIndentViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        //不开通微商药房
        AllTipsViewController *vc=[[AllTipsViewController alloc] init];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ---- 接收通知 ----

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{

    if (NotifKickOff == type)
    {
//        [self quitAccount];
        [QWGLOBALMANAGER postNotif:NotifQuitOut data:nil object:nil];
        QWGLOBALMANAGER.configure.passWord = @"";
        [QWGLOBALMANAGER saveAppConfigure];
        [QWGLOBALMANAGER clearAccountInformation];
        [QWUserDefault setBool:NO key:APP_LOGIN_STATUS];
        
        QWGLOBALMANAGER.isCheckToken = YES;
        
    }else if (NotifiIndexRedDotOrNumber == type)
    {
        // 首页咨询小红点
        NSDictionary *dd=data;
        if (dd[@"conslut"]) {
            self.passNumber = [dd[@"conslut"] integerValue];
            [self.myCollectionview reloadData];
        }
        self.rightRedDot.hidden = YES;
        if (dd[@"hadMessage"]) {
            //判断是非有药师消息
            if ([dd[@"hadMessage"] integerValue]) {
                self.rightRedDot.hidden = NO;   // 显示
            }
            else self.rightRedDot.hidden = YES;  // 隐藏全维消息红点
        }
        if ([QWGLOBALMANAGER calculateUnreadNum]) {
            self.rightRedDot.hidden = NO;
        }

    }else if (NotifiOrganAuthPass == type)
    {
        // 机构认证通过
        [self configureAuthView];
        [self configureArray];
        [self.myCollectionview reloadData];
        
    }else if (NotifiOrganAuthFailure == type)
    {
        // 机构认证失败
        [self configureAuthView];
        [self configureArray];
        [self.myCollectionview reloadData];
    }else if (NotifNewOrderCount == type)
    {
        NSString *strCount = (NSString *)data;
        self.intOrderNum = [strCount intValue];
        [self.myCollectionview reloadData];
    }
}

#pragma mark ---- 账号被抢登 ----

- (void)quitAccount
{
    QWGLOBALMANAGER.isCheckToken = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:Kwarning220N81 delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    alert.tag=Enum_TypeAlert_Quite;
    [alert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==Enum_TypeAlert_Quite){
        [QWGLOBALMANAGER postNotif:NotifQuitOut data:nil object:nil];
        QWGLOBALMANAGER.configure.passWord = @"";
        [QWGLOBALMANAGER saveAppConfigure];
        [QWGLOBALMANAGER clearAccountInformation];
        [QWUserDefault setBool:NO key:APP_LOGIN_STATUS];

        QWGLOBALMANAGER.isCheckToken = YES;
    
    }else if(alertView.tag==Enum_TypeAlert_Verify){
    }
}

#pragma mark ---- 扫码／输入验证码，检测两证是否齐全 ----
- (void)checkCertVaildate
{
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"branchId"] = QWGLOBALMANAGER.configure.groupId;
    setting[@"endpoint"] = @"2";
    [IMApi certcheckIMWithParams:setting success:^(BaseAPIModel *model) {
        self.isScanModel = model;
    } failure:^(HttpException *e) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8f];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
