
//
//  DrugDetailViewController.m
//  wenyao
//
//  Created by Meng on 14-9-28.
//  Copyright (c) 2014年 xiezhenghong. All rights reserved.
//

#import "DrugDetailViewController.h"
#import "Drug.h"
#import "Order.h"
#import "ZhPMethod.h"
#import "KnowLedgeViewController.h"
#import "SVProgressHUD.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "DrugDetailViewController.h"
#import "UIViewController+isNetwork.h"
#import "DrugDetailCell.h"
//#import "CouponGenerateViewController.h"
#import "KnowLedgeViewController.h"
//#import "CouponDeatilViewController.h"


@interface DrugDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIFont * titleFont;
    UIFont * contentFont;
    UIFont * topTitleFont;
    TopView * topView;
    UIView *footView;
    UIImageView * buttonImage;
    
    NSInteger m_descFont;
    NSInteger m_titleFont;
    NSInteger m_topTitleFont;
    UIFont          *defaultFont;
    BOOL isUp;
    int startTime;
}

@property (strong, nonatomic) NSString *collectButtonImageName;
@property (nonatomic ,strong) NSMutableArray * dataSource;
@property (nonatomic ,strong) NSString * sid;//收藏时传入得id
@property(nonatomic,strong)NSString *medicineName;
@property(nonatomic,strong)NSString *medicineKnowledge;

//收藏按钮
@property (strong, nonatomic) UIButton *collectButton;
@end

@implementation DrugDetailViewController

- (id)init{
    
    if (self = [super init]) {
        
    }
    return self;
}

- (void)subViewDidLoad{
    
    
    topView = [[TopView alloc] init];
    isUp = YES;
    m_descFont = kFontS4;
    m_titleFont = kFontS3;
    m_topTitleFont = kFontS2;
    defaultFont = fontSystem(kFontS5);
    
    self.dataSource = [NSMutableArray array];
    self.tableViews=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableViews.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableViews.dataSource=self;
    self.tableViews.delegate=self;
    self.tableViews.backgroundColor =RGBHex(qwColor11);
    
    self.tableViews.tableHeaderView = topView;
    [self.view addSubview:self.tableViews];
    footView = [[UIView alloc]initWithFrame:CGRectMake(0, APP_H -NAV_H, SCREEN_W, 40)];
    UIButton *pushBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, SCREEN_W - 20, 30)];
    [pushBtn setTitle:@"立即享受优惠" forState:UIControlStateNormal];
    [pushBtn setTitleColor: RGBHex(qwColor4) forState:UIControlStateNormal];
    [pushBtn setBackgroundColor:RGBHex(qwColor2)];
    pushBtn.layer.masksToBounds = YES;
    pushBtn.layer.cornerRadius = 2.0f;
    [pushBtn addTarget:self action:@selector(pushToGenerateView:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:pushBtn];
    [self.view addSubview:footView];
    
    titleFont=fontSystemBold(kFontS3);
    topTitleFont=fontSystemBold(kFontS2);
    contentFont=fontSystem(kFontS4);
    topView.titleFont=fontSystemBold(kFontS3);
    topView.topTitleFont=fontSystemBold(kFontS2);
    topView.contentFont=fontSystem(kFontS4);
    

    [self ifHasCoupon];
    [self initrightButton];
    self.tableViews.backgroundColor =RGBHex(qwColor11);
    topView.facComeFrom = self.facComeFrom;
}
-(void)initrightButton{
    UIBarButtonItem *button=[[UIBarButtonItem alloc]initWithTitle:@"Aa" style:UIBarButtonItemStylePlain target:self action:@selector(zoomButtonClick)];
    [self.navigationItem setRightBarButtonItem:button];
}
-(void)popVCAction:(id)sender{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        
//        if ([temp isKindOfClass:[CouponDeatilViewController class]]) {
//            [self.navigationController popToViewController:temp animated:YES];
//            return;
//        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)ifHasCoupon{
    
    
    
//    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
//    if(QWGLOBALMANAGER.loginStatus){
//        setting[@"token"] = QWGLOBALMANAGER.configure.userToken;
//    }
//    setting[@"proId"] = self.proId;
//    [Order promotionScanWithParms:setting success:^(id DFUserModel) {
//        CouponEnjoyModel *enjoymode=DFUserModel;
//        /**
//         *  0 正常
//         -10 商品不存在
//         -11 商品不适用
//         -2 活动未开始
//         -1 活动已结束
//         -4 活动异常
//         -13 总次数不足
//         -14 总人次不足
//         */
//        if([enjoymode.status intValue] == 0 || [enjoymode.status intValue] == -13 || [enjoymode.status intValue] == -14){
//            
//                footView.hidden = NO;
//                footView.frame = CGRectMake(0, APP_H -NAV_H - 40, SCREEN_W, 40);
//                [self.tableViews setFrame:CGRectMake(0, 0, APP_W, APP_H -NAV_H - 40)];
//        }else{
//                footView.hidden = YES;
//                footView.frame = CGRectMake(0, APP_H -NAV_H , SCREEN_W, 40);
//                [self.tableViews setFrame:CGRectMake(0, 0, APP_W, APP_H -NAV_H )];
//        }
//        [self obtainDataSource];
//     
//    } failure:^(HttpException *e) {
//        footView.hidden = YES;
//        [self.tableViews setFrame:CGRectMake(0, 0, APP_W, APP_H -NAV_H )];
//        [self obtainDataSource];
//        return;
//    }];
    
}

- (void)pushToGenerateView:(id)sender{
    UIButton *btn = (UIButton *)sender;
    btn.userInteractionEnabled = NO;
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    if(QWGLOBALMANAGER.loginStatus){
        setting[@"token"] = QWGLOBALMANAGER.configure.userToken;
    }
    setting[@"proId"] = self.proId;
    
//    [Order promotionScanWithParms:setting success:^(id DFUserModel) {
//        CouponEnjoyModel *enjoymode=DFUserModel;
//        if ([enjoymode.status intValue] == 0) {
//            CouponGenerateViewController *generateView = [[CouponGenerateViewController alloc]initWithNibName:@"CouponGenerateViewController" bundle:nil];
//            generateView.useType = 3;
//            //传值：优惠活动详情
//            generateView.enjoy = enjoymode;
//            //传值：商品编码
//            generateView.proId = self.proId;
//            
//            for(id view in self.navigationController.viewControllers){
//                if([view isKindOfClass:[CouponGenerateViewController class]]){
//                    [self.navigationController popToViewController:view animated:YES];
//                    return;
//                }
//            }
//            generateView.delegatePopVC = self;
//            [self.navigationController pushViewController:generateView animated:YES];
//            btn.userInteractionEnabled = YES;
//            
//        }else{
//            btn.userInteractionEnabled = YES;
//        }
//    } failure:^(HttpException *e) {
//        btn.userInteractionEnabled = YES;
//        return;
//    }];
    
    
}

- (void)BtnClick{
    
    if(![self isNetWorking]){
        for(UIView *v in [self.view subviews]){
            if(v.tag == 999){
                [v removeFromSuperview];
            }
        }
        [self subViewDidLoad];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"详情";
    if([self isNetWorking]){
        [self addNetView];
        return;
    }
    if(startTime == 0){
        [self subViewDidLoad];
    }
    startTime ++;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    startTime = 0;
}


- (void)setRightItems{
  
    UIView *ypDetailBarItems=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 55, 55)];
    
    UIButton * zoomButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [zoomButton setFrame:CGRectMake(28, 0, 55,55)];
    [zoomButton addTarget:self action:@selector(zoomButtonClick) forControlEvents:UIControlEventTouchUpInside];
    zoomButton.titleLabel.font = [UIFont systemFontOfSize:19.0f];
    zoomButton.titleLabel.textColor = [UIColor whiteColor];
    [zoomButton setTitle:@"Aa" forState:UIControlStateNormal];
    [ypDetailBarItems addSubview:zoomButton];
    
    UIBarButtonItem *fix=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fix.width=-20;
    self.navigationItem.rightBarButtonItems=@[fix,[[UIBarButtonItem alloc]initWithCustomView:ypDetailBarItems]];
}
- (void)delayPopToHome
{
    [QWGLOBALMANAGER.tabBar setSelectedIndex:0];
}
#pragma mark---------------------------------------------跳转到首页-----------------------------------------------

- (void)zoomButtonClick{
    if (m_descFont == 20) {
        isUp = NO;
    }else if(m_descFont == 14){
        isUp = YES;
    }
    if (isUp) {
        m_descFont+=3;
        m_titleFont+=3;
        m_topTitleFont+=3;
    }else{
        m_descFont = 14;
        m_titleFont = 16;
        m_topTitleFont = 18;
    }
    topView.titleFont = [UIFont boldSystemFontOfSize:m_titleFont];
    topView.topTitleFont = [UIFont boldSystemFontOfSize:m_topTitleFont];
    topView.contentFont = [UIFont systemFontOfSize:m_descFont];
    
    titleFont = [UIFont boldSystemFontOfSize:m_titleFont];
    topTitleFont = [UIFont boldSystemFontOfSize:m_topTitleFont];
    contentFont = [UIFont systemFontOfSize:m_descFont];
    self.tableViews.tableHeaderView = topView;
    [self.tableViews reloadData];
}

#pragma mark ------网络数据请求及解析------
- (void)obtainDataSource
{
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"proId"] = self.proId;
    [Drug drugqueryProductDetailWithParam:setting Success:^(id DFModel) {
        
        
        if([DFModel[@"apiStatus"] intValue]==1){
        
            [self showInfoView:@"该药品已不存在" image:nil];
        }else{
        
            self.collectButton.enabled = YES;
            
            [self fillupBaseInfo:DFModel];
            
            NSLog(@"药品详情 = %@",DFModel);
            self.sid = DFModel[@"sid"];
            NSLog(@"药品详情%@",self.sid);
            self.medicineName = DFModel[@"shortName"];
            self.medicineKnowledge = DFModel[@"knowledgeTitle"];
        
        }
        
        
       
    } failure:^(HttpException *e) {
    }];
}
- (void)fillupBaseInfo:(NSDictionary *)baseInfo{
    [self.dataSource removeAllObjects];
    topView.dataDictionary = baseInfo;
    self.tableViews.tableHeaderView = topView;
    NSMutableDictionary *change=[baseInfo mutableCopy];
    for (NSDictionary * dicT in change[@"useNotice"]) {
        NSMutableDictionary *dic = [dicT mutableCopy];
        NSString * t = dic[@"title"];
        ;NSString * c = dic[@"content"];
        if (t.length > 0 && ([c isEqualToString:@""]||c.length == 0)) {
            dic[@"content"] = @"尚不";
        }
        if (![dic[@"content"] isEqualToString:@"尚不"])
        {
            [self.dataSource addObject:dic];
        }
    }
    if (self.dataSource.count == 0&&!baseInfo) {
        self.tableViews.hidden = YES;
    }else{
        topView.backgroundColor=RGBHex(qwColor4);
    }
    NSString *title = baseInfo[@"knowledgeTitle"];
    NSString *content = baseInfo[@"knowledgeContent"];
    if (title.length > 0) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setValue:@"用药小知识" forKey:@"title"];
        [dic setValue:title forKey:@"knowledgeTitle"];
        [dic setValue:content forKey:@"content"];
        [self.dataSource addObject:dic];
    }
    [self.tableViews reloadData];
}
#pragma mark ------UITableViewDelegate------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 10)];
    [view setBackgroundColor:RGBHex(qwColor11)];
    view.layer.masksToBounds=YES;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = RGBHex(qwColor10).CGColor;
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * dic = self.dataSource[indexPath.section];
    if (indexPath.row == 0) {
        return [self height:titleFont withtext:dic[@"title"]];
    }
    if (indexPath.row == 1) {
        if ([dic[@"title"] isEqualToString:@"用药小知识"]) {
            return [self height:titleFont withtext:dic[@"title"]];
        }
//        return [self height:contentFont withtext:dic[@"content"]];
        return  getTempTextSize([QWGLOBALMANAGER replaceSpecialStringWith:dic[@"content"]], contentFont, APP_W-16).height+18;
    }
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentifier = @"cellIdentifier";
    DrugDetailCell * cell = (DrugDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DrugDetailCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    cell.titleTextView.scrollEnabled=NO;
    cell.titleTextView.textContainer.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    [[cell viewWithTag:1008] removeFromSuperview];
    [[cell viewWithTag:1009] removeFromSuperview];
    NSDictionary * dic = self.dataSource[indexPath.section];
    if(indexPath.row == 0) {
        cell.titleTextView.font = titleFont;
        cell.titleTextView.text = dic[@"title"];
        cell.titleTextView.frame = CGRectMake(8, 5, APP_W-16, [self height:titleFont withtext:dic[@"title"]]);
        UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 0.5)];
        [topSeparatorView setBackgroundColor:RGBHex(qwColor11)];
        topSeparatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        topSeparatorView.tag = 1009;
        [cell addSubview:topSeparatorView];
    }else{
//        cell.titleTextView.font = contentFont;
        UIView *bottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, MAX(cell.frame.size.height - 0.5,0), APP_W, 0.5)];
        [bottomSeparatorView setBackgroundColor:RGBHex(qwColor11)];
        bottomSeparatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        bottomSeparatorView.tag = 1008;
        [cell addSubview:bottomSeparatorView];
    }
    
    if(indexPath.row == 1) {
        if ([dic[@"title"] isEqualToString:@"用药小知识"]) {
           CGSize titleSize = getTempTextSize(@"用药小知识", contentFont, APP_W);
            cell.titleTextView.text = [QWGLOBALMANAGER replaceSpecialStringWith:dic[@"content"]];
            [cell.titleTextView setFrame:CGRectMake(8 , 0 ,APP_W-30 ,titleSize.height + 10)];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.titleTextView.font = contentFont;
            cell.titleTextView.userInteractionEnabled = NO;
            cell.titleTextView.textColor = RGBHex(qwColor6);
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.titleTextView.textColor = RGBHex(qwColor6);
            cell.titleTextView.font = contentFont;
            cell.titleTextView.text = [QWGLOBALMANAGER replaceSpecialStringWith:dic[@"content"]];
            CGSize contentSize = getTempTextSize([QWGLOBALMANAGER replaceSpecialStringWith:dic[@"content"]], contentFont, APP_W-16);
            cell.titleTextView.frame = CGRectMake(8, 0, APP_W-16, contentSize.height+18);
        }
        
    }
    return cell;
}

- (float)height:(UIFont *)font withtext:(NSString *)text
{
    text = [QWGLOBALMANAGER replaceSpecialStringWith:text];
    UITextView *t = [[UITextView alloc] initWithFrame:CGRectMake(8, 0, APP_W-16, 5000)];
    t.font = font;
    t.textContainer.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    t.text = text;
    t.scrollEnabled=NO;
    [t sizeToFit];
    return t.frame.size.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * dic = self.dataSource[indexPath.section];
    if ([dic[@"title"] isEqualToString:@"用药小知识"]) {
        if (indexPath.row == 1) {
                        KnowLedgeViewController * knowLedge = [[KnowLedgeViewController alloc] init];
                        knowLedge.knowledgeTitle = dic[@"knowledgeTitle"];
                        knowLedge.knowledgeContent = dic[@"content"];
                        [self.navigationController pushViewController:knowLedge animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



@implementation TopView
{
    CGFloat h;
    UIView *warning;
}
- (id)init{
    if (self = [super init]) {
        [self initLabel];
        self.backgroundColor = RGBHex(qwColor11);
    }
    return self;
}

- (void)initLabel
{
    self.titleTextView = [[UITextView alloc] init];
    [self textViewOptions:self.titleTextView];
    self.specTextView = [[UITextView alloc] init];
    [self textViewOptions:self.specTextView];
    self.factoryTextView = [[UITextView alloc]init];
    [self textViewOptions:self.factoryTextView];
    
    self.firstTextView = [[UITextView alloc] init];
    [self textViewOptions:self.firstTextView];
    self.secondTextView = [[UITextView alloc] init];
    [self textViewOptions:self.secondTextView];
    self.firstImageView = [[UIImageView alloc] init];
    self.secondImageView = [[UIImageView alloc] init];
}

- (void)textViewOptions:(UITextView *)textView
{
    textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    textView.editable = NO;
}

- (void)setDataDictionary:(NSDictionary *)dataDictionary{
    _dataDictionary = dataDictionary;
    [self setUpView];
}



- (void)setContentFont:(UIFont *)contentFont{
    _contentFont = contentFont;
    [self setUpView];
}

- (void)setUpView{
    /*
     headerInfo =         {
     factory = "广州奇星药业有限公司";
     factoryAuth = 0;
     registerNo = "国药准字Z44022417";
     shortName = "奇星,新雪颗粒";
     sid = 5da18eb453ab3c869ab4011cac2b88fe;
     signCode = 1b;
     spec = "1.53g*6";
     type = "处方药中成药";
     unit = "盒";
     };
     */
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 0.5)];
    [topSeparatorView setBackgroundColor:RGBHex(qwColor11)];
    topSeparatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    topSeparatorView.tag = 1009;
    [self addSubview:topSeparatorView];
    
    UIView *bottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, MAX(self.frame.size.height - 0.5, 0), APP_W, 0.5)];
    [bottomSeparatorView setBackgroundColor:RGBHex(qwColor11)];
    bottomSeparatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    bottomSeparatorView.tag = 1008;
    [self addSubview:bottomSeparatorView];
    
    NSString * str = [QWGLOBALMANAGER replaceSpecialStringWith:self.dataDictionary[@"shortName"]];
    
    
    [self.titleTextView setFrame:CGRectMake(8, 10, APP_W-16, getTempTextSize(str, self.topTitleFont, APP_W-20).height)];
    self.titleTextView.text = str;
    self.titleTextView.font = self.topTitleFont;//[UIFont boldSystemFontOfSize:18.0f];
    self.titleTextView.textColor = RGBHex(qwColor6);
    [self addSubview:self.titleTextView];
    
    NSString *signcode = self.dataDictionary[@"signCode"];
    UIImage * firstImage = [[UIImage alloc] init];
    NSString * firstString = nil;
    NSString *recipeString = nil;
    
    if([signcode isEqualToString:@"1a"])
    {
        firstImage = [UIImage imageNamed:@"处方药.png"];
        firstString = @"处方药";
        recipeString = @"西药";
    }else if([signcode isEqualToString:@"1b"]){
        firstImage = [UIImage imageNamed:@"处方药.png"];
        firstString = @"处方药";
        recipeString = @"中成药";
    }else if([signcode isEqualToString:@"2a"]){
        firstImage = [UIImage imageNamed:@"otc-甲类.png"];
        firstString = @"甲类OTC非处方药";
        recipeString = @"西药";
    }else if([signcode isEqualToString:@"2b"]){
        firstImage = [UIImage imageNamed:@"otc-甲类.png"];
        firstString = @"甲类OTC非处方药";
        recipeString = @"中成药";
    }
    else if ([signcode isEqualToString:@"3a"]){
        firstImage = [UIImage imageNamed:@"otc-乙类.png"];
        firstString = @"乙类OTC非处方药";
        recipeString = @"西药";
    }else if([signcode isEqualToString:@"3b"]) {
        firstImage = [UIImage imageNamed:@"otc-乙类.png"];
        firstString = @"乙类OTC非处方药";
        recipeString = @"中成药";
    }else if([signcode isEqualToString:@"4c"]) {
        firstImage = nil;
        firstString = @"定型包装中药饮片";
    }else if([signcode isEqualToString:@"4d"]) {
        firstImage = nil;
        firstString = @"散装中药饮片";
    }else if([signcode isEqualToString:@"5"]) {
        firstImage = nil;
        firstString = @"保健食品";
    }else if([signcode isEqualToString:@"6"]) {
        firstImage = nil;
        firstString = @"食品";
    }else if([signcode isEqualToString:@"7"]) {
        firstImage = nil;
        firstString = @"械字号一类";
    }else if([signcode isEqualToString:@"8"]) {
        firstImage = nil;
        firstString = @"械字号二类";
    }else if([signcode isEqualToString:@"10"]) {
        firstImage = nil;
        firstString = @"消字号";
    }else if([signcode isEqualToString:@"11"]) {
        firstImage = nil;
        firstString = @"妆字号";
    }else if([signcode isEqualToString:@"12"]) {
        firstImage = nil;
        firstString = @"无批准号";
    }else if([signcode isEqualToString:@"13"]) {
        firstImage = nil;
        firstString = @"其他";
    }else if([signcode isEqualToString:@"9"]) {
        firstImage = nil;
        firstString = @"械字号三类";
    }
    
    //药品标签
    float logo_Y = self.titleTextView.frame.origin.y + self.titleTextView.frame.size.height + 8;
    //第一个view
    
    [self.firstImageView setFrame:CGRectMake(8, logo_Y, 25, 14)];
    self.firstImageView.image = firstImage;
    if(firstImage) {
        [self addSubview:self.firstImageView];
    }
    CGSize firstSize = getTempTextSize(firstString, self.contentFont, 1000);
    
    //第一个label
    float first_label_X = 0;
    if(firstImage) {
        first_label_X = self.firstImageView.frame.origin.x + self.firstImageView.frame.size.width + 5;
    }else{
        first_label_X = 10;
    }
    [self.firstTextView setFrame:CGRectMake(first_label_X, logo_Y, firstSize.width + 10, firstSize.height)];
    self.firstTextView.text = firstString;
    self.firstTextView.font = self.contentFont;
    self.firstTextView.textColor =RGBHex(qwColor7);
    [self addSubview:self.firstTextView];
    if(recipeString)
    {
        self.recipeImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.firstTextView.frame.origin.x + self.firstTextView.frame.size.width + 8, self.firstTextView.frame.origin.y + self.firstTextView.frame.size.height / 2 - 7.5, 20, 14)];
        if([recipeString isEqualToString:@"西药"]) {
            self.recipeImage.image = [UIImage imageNamed:@"西药.png"];
        }else{
            self.recipeImage.image = [UIImage imageNamed:@"中成药-1.png"];
        }
        [self addSubview:self.recipeImage];
        
        self.recipeTextView = [[UITextView alloc] initWithFrame:RECT(self.recipeImage.frame.origin.x + self.recipeImage.frame.size.width + 8, 35 , 100, 21)];
        [self textViewOptions:self.recipeTextView];
        [self.recipeTextView setFrame:CGRectMake(self.recipeImage.frame.origin.x + self.recipeImage.frame.size.width + 8, logo_Y - 2.5, APP_W-20,getTempTextSize(recipeString, self.titleFont, APP_W-20).height)];
        self.recipeTextView.textColor = RGBHex(qwColor7);
        self.recipeTextView.font = self.contentFont;
        self.recipeTextView.text = recipeString;
        [self addSubview:self.recipeTextView];
    }
    
    str = [QWGLOBALMANAGER replaceSpecialStringWith:self.dataDictionary[@"spec"]];
    [self.specTextView setFrame:CGRectMake(8, self.firstTextView.frame.origin.y + self.firstTextView.frame.size.height + 8, APP_W-16,getTempTextSize(str, self.titleFont, APP_W-20).height)];
    self.specTextView.text = str;
    self.specTextView.textColor = RGBHex(qwColor7);
    [self.specTextView setFont:_contentFont];
    [self addSubview:self.specTextView];
    
    
    str = [QWGLOBALMANAGER replaceSpecialStringWith:self.dataDictionary[@"factory"]];
    [self.factoryTextView setFrame:CGRectMake(8, self.specTextView.frame.origin.y + self.specTextView.frame.size.height + 8, APP_W-16,getTempTextSize(str, self.titleFont, APP_W-20).height)];
    self.factoryTextView.text = str;
    self.factoryTextView.font = self.contentFont;
    [self addSubview:self.factoryTextView];
    
    //    if([self.facComeFrom isEqualToString:@"1"]){
    //        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"认证V@2x.png"]];
    //        imageView.frame = CGRectMake(10 + self.factoryLabel.text.length *self.contentFont.pointSize + 5, self.specLabel.frame.origin.y + self.specLabel.frame.size.height + 8, getTextSize(str, self.titleFont, APP_W-20).height, getTextSize(str, self.titleFont, APP_W-20).height);
    //        [self addSubview:imageView];
    //    }
    
    self.ephedrineTextView = [[UITextView alloc] init];
    [self.ephedrineTextView setFrame:CGRectMake(30, 8, (self.contentFont.pointSize - 1.5) * 16+10,self.contentFont.pointSize)];
//    self.ephedrineTextView.numberOfLines = 0;
    [self textViewOptions:self.ephedrineTextView];
    self.ephedrineTextView.textColor = RGBHex(qwColor7);
    self.ephedrineTextView.backgroundColor = RGBHex(qwColor11);
    self.ephedrineTextView.font = fontSystem(self.contentFont.pointSize - 1.5);
    self.ephedrineTextView.text = @"本品含麻黄碱，请遵医嘱谨慎使用。";
    
    self.ephedrineImage = [[UIImageView alloc] initWithFrame:CGRectMake(9, 8 , 15, 15)];
    self.ephedrineImage.image = [UIImage imageNamed:@"麻黄碱提醒icon.png"];
    self.ephedrineImage.backgroundColor =RGBHex(qwColor11);
    
    warning = [[UIView alloc]initWithFrame:CGRectMake(8, self.factoryTextView.frame.size.height + self.factoryTextView.frame.origin.y + 5, 30 + self.ephedrineTextView.frame.size.width, self.contentFont.pointSize + 16)];
    warning.backgroundColor =RGBHex(qwColor11);
    [warning addSubview:self.ephedrineTextView];
    [warning addSubview:self.ephedrineImage];
    [self addSubview:warning];
    
    if([self.dataDictionary[@"isContainEphedrine"] integerValue] == 1){
        //含麻黄碱
        h = warning.frame.origin.y + warning.frame.size.height + 8;
        warning.hidden = NO;
        
    }else{
        h = warning.frame.origin.y + 8;
        warning.hidden = YES;
        
    }
    //h = self.ephedrineLabel.frame.origin.y + self.ephedrineLabel.frame.size.height + 8;
    
    self.frame = CGRectMake(0, 0, APP_W, h);
}



@end
