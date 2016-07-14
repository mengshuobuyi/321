//
//  MyCircleViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/6/15.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "MyCircleViewController.h"
#import "HotCircleCell.h"
#import "Circle.h"
#import "CircleModel.h"
#import "ExpertPageViewController.h"
#import "UserPageViewController.h"
#import "HotCirclePostCover.h"
#import "SendPostViewController.h"
#import "PostDetailViewController.h"
#import "MyBrandViewController.h"

@interface MyCircleViewController ()<UITableViewDataSource,UITableViewDelegate,HotCircleCellDelegate>
{
    NSInteger currentPage;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (assign, nonatomic) int expertType; //3药师  4营养师

//发帖
@property (weak, nonatomic) IBOutlet UIButton *postCircleButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postBtn_layout_bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postBtn_layout_right;
@property (strong, nonatomic) HotCirclePageModel *circlePage;
- (IBAction)postCircleAction:(id)sender;

@end

@implementation MyCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    currentPage = 1;
    
    [QWGLOBALMANAGER statisticsEventId:@"我的圈页面_出现" withLable:@"圈子" withParams:nil];
    
    self.dataList = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.postCircleButton.layer.cornerRadius = 24;
    self.postCircleButton.layer.masksToBounds = YES;
    
    //下拉刷新
    __weak MyCircleViewController *weakSelf = self;
    [self enableSimpleRefresh:self.tableView block:^(SRRefreshView *sender) {
        if (QWGLOBALMANAGER.currentNetWork != kNotReachable) {
            HttpClientMgr.progressEnabled = NO;
            [weakSelf headerRefreshing];
        }else{
            [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试！" duration:0.8];
        }
    }];
    
    //分页加载
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.footerPullToRefreshText = kWaring6;
    self.tableView.footerReleaseToRefreshText = kWaring7;
    self.tableView.footerRefreshingText = kWaring9;
    self.tableView.footerNoDataText = kWaring55;
    
    //发帖按钮适配
    if (IS_IPHONE_6) {
        self.postBtn_layout_right.constant = 16;
        self.postBtn_layout_bottom.constant = 21;
    }else if (IS_IPHONE_6P){
        self.postBtn_layout_right.constant = 21;
        self.postBtn_layout_bottom.constant = 33;
    }
    
    //获取数据
    [self footerRereshing];
    
    //显示蒙层
    ShowHotCirclePostCover();
}

- (void)viewInfoClickAction:(id)sender
{
    currentPage = 1;
    [self removeInfoView];
    [self footerRereshing];
}

#pragma mark ---- 获取帖子列表数据 ----
- (void)headerRefreshing
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"page"] = @"1";
    setting[@"pageSize"] = @"10";
    
    currentPage = 1;
    [Circle TeamMyTeamWithParams:setting success:^(id DFUserModel) {
        
        [self.tableView headerEndRefreshing];
        self.tableView.footer.canLoadMore = YES;
        [self.dataList removeAllObjects];
        
        HotCirclePageModel *page = [HotCirclePageModel parse:DFUserModel Elements:[TopicListModel class] forAttribute:@"postInfoList"];
        
        self.circlePage = page;
        
        if ([page.apiStatus integerValue] == 0)
        {
            NSArray *arr = page.postInfoList;
            self.expertType = page.expertType;
            
            if (arr.count>0)
            {
                currentPage++;
                [self.dataList addObjectsFromArray:arr];
                [self.tableView reloadData];
                
            }else
            {
                if (StrIsEmpty(page.groupId))
                {
                    [self showLocalInfoView:@"还没有挂靠商家" textTwo:@"去我的资料申请认证吧～" isProved:YES];
                }else
                {
                    [self showLocalInfoView:@"还没有帖子" textTwo:@"赶快去发一个吧～" isProved:NO];
                }
            }
        }else
        {
            [SVProgressHUD showErrorWithStatus:page.apiMessage];
        }
        
    } failure:^(HttpException *e) {
        [self.tableView headerEndRefreshing];
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [self showInfoView:kWaring12 image:@"img_network"];
        }else
        {
            if(e.errorCode != -999){
                if(e.errorCode == -1001){
                    [self showInfoView:kWarning215N54 image:@"ic_img_fail"];
                }else{
                    [self showInfoView:kWarning215N0 image:@"ic_img_fail"];
                }
            }
        }
    }];
}

#pragma mark ---- 分页加载 ----
- (void)footerRereshing
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"page"] = [NSString stringWithFormat:@"%ld",(long)currentPage];
    setting[@"pageSize"] = @"10";
    HttpClientMgr.progressEnabled = NO;
    
    [Circle TeamMyTeamWithParams:setting success:^(id DFUserModel) {
        
        [self.tableView footerEndRefreshing];
        
        HotCirclePageModel *page = [HotCirclePageModel parse:DFUserModel Elements:[TopicListModel class] forAttribute:@"postInfoList"];
        
        self.circlePage = page;
        
        if ([page.apiStatus integerValue] == 0)
        {
            NSArray *arr = page.postInfoList;
            self.expertType = page.expertType;
            
            if (arr.count == 0) {
                self.tableView.footer.canLoadMore = NO;
                [self.tableView footerEndRefreshing];
            }
            if (arr.count>0)
            {
                [self.dataList addObjectsFromArray:arr];
                [self.tableView reloadData];
                currentPage++;
            }else
            {
                if (currentPage == 1) {
                    
                    if (StrIsEmpty(page.groupId))
                    {
                        [self showLocalInfoView:@"还没有挂靠商家" textTwo:@"去我的资料申请认证吧～" isProved:YES];
                    }else
                    {
                        [self showLocalInfoView:@"还没有帖子" textTwo:@"赶快去发一个吧～" isProved:NO];
                    }
                }
            }
        }
    } failure:^(HttpException *e) {
        [self.tableView footerEndRefreshing];
    }];
}

#pragma mark ---- UITableViewDelegate ----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HotCircleCell getCellHeight:self.dataList[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *circleDetailCell = @"CircleDetailCell";
    HotCircleCell *cell = (HotCircleCell *)[tableView dequeueReusableCellWithIdentifier:circleDetailCell];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"HotCircleCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:circleDetailCell];
        cell = (HotCircleCell *)[tableView dequeueReusableCellWithIdentifier:circleDetailCell];
    }
    
    [cell configureData:self.dataList[indexPath.row] type:1];
    cell.topView.obj = indexPath;
    cell.hotCircleCellDelegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [QWGLOBALMANAGER statisticsEventId:@"我的圈_帖子列表" withLable:@"圈子" withParams:nil];
    
    //帖子详情
    PostDetailViewController* postDetailVC = [[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"PostDetailViewController"];
    TopicListModel* topic = self.dataList[indexPath.row];
    postDetailVC.postId = topic.postId;
    postDetailVC.hidesBottomBarWhenPushed = YES;
    [self.cusNavigationController pushViewController:postDetailVC animated:YES];
}

#pragma mark ---- 发帖至本商家圈 ----
- (IBAction)postCircleAction:(id)sender
{
    if (QWGLOBALMANAGER.configure.silencedFlag) {
        [SVProgressHUD showErrorWithStatus:@"您已被禁言"];
        return;
    }
    
    [QWGLOBALMANAGER statisticsEventId:@"我的圈_发帖按键" withLable:@"圈子" withParams:nil];
    
    QWCircleModel *model = [QWCircleModel new];
    model.teamId = self.circlePage.teamId;
    model.teamName = self.circlePage.teamName;
    
    SendPostViewController* sendPostVC = [[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"SendPostViewController"];
    sendPostVC.hidesBottomBarWhenPushed = YES;
    sendPostVC.needChooseCircle = NO;
    sendPostVC.isStoreCircle = YES;
    sendPostVC.sendCircle = model;
    [self.cusNavigationController pushViewController:sendPostVC animated:YES];

}

#pragma mark ---- 点击头像进入药师专栏 ----
- (void)tapHeader:(NSIndexPath *)indexPath
{
    TopicListModel *model = self.dataList[indexPath.row];
    
    //当前登陆用户 不可点击
    if ([model.posterId isEqualToString:QWGLOBALMANAGER.configure.expertPassportId]) {
        return;
    }
    
    if (model.flagAnon) {
        return;
    }
    
    if (model.posterType == 3 || model.posterType == 4)
    {
        //专家专栏
        ExpertPageViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertPage" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertPageViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.posterId = model.posterId;
        vc.expertType = model.posterType;
        [self.cusNavigationController pushViewController:vc animated:YES];
    }else
    {
        //用户个人主页
        UserPageViewController *vc = [[UIStoryboard storyboardWithName:@"UserPage" bundle:nil] instantiateViewControllerWithIdentifier:@"UserPageViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.mbrId = model.posterId;
        [self.cusNavigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ---- 无数据背景提示 是否显示发帖按钮 去认证按钮 ----

-(void)showLocalInfoView:(NSString *)textOne textTwo:(NSString *)textTwo isProved:(BOOL)isProved
{
    NSString *imageName = @"img_common_two";
    //判断专家是否有挂靠商家
    if (isProved){
        //没有挂靠商家
        imageName = @"img_common_three";
    }else{
        //有挂靠商家
        imageName = @"img_common_two";
    }
    UIImage * imgInfoBG = [UIImage imageNamed:imageName];
    
    
    if (self.vInfo==nil) {
        self.vInfo = [[UIView alloc]initWithFrame:self.view.bounds];
        self.vInfo.backgroundColor = RGBHex(qwColor11);
    }
    
    self.vInfo.frame = self.view.bounds;
    
    for (id obj in self.vInfo.subviews) {
        [obj removeFromSuperview];
    }
    
    UIButton *btnClick = [[UIButton alloc] initWithFrame:self.vInfo.bounds];
    btnClick.tag=0;
    [btnClick addTarget:self action:@selector(viewInfoClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.vInfo addSubview:btnClick];
    
    UIImageView *imageView;
    UILabel *label1;
    UILabel *label2;
    UIButton *proveButton;
    
    imageView=[[UIImageView alloc]init];
    [self.vInfo addSubview:imageView];
    
    label1 = [[UILabel alloc]init];
    label1.numberOfLines=0;
    label1.font = fontSystem(kFontS4);
    label1.textColor = RGBHex(qwColor8);
    label1.textAlignment = NSTextAlignmentCenter;
    [self.vInfo addSubview:label1];
    
    label2 = [[UILabel alloc]init];
    label2.numberOfLines=0;
    label2.font = fontSystem(kFontS4);
    label2.textColor = RGBHex(qwColor8);
    label2.textAlignment = NSTextAlignmentCenter;
    [self.vInfo addSubview:label2];
    
    proveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [proveButton setBackgroundColor:RGBHex(qwColor2)];
    proveButton.layer.cornerRadius = 3.0;
    proveButton.layer.masksToBounds = YES;
    [proveButton setTitle:@"去认证" forState:UIControlStateNormal];
    proveButton.titleLabel.font = fontSystem(kFontS1);
    [proveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [proveButton addTarget:self action:@selector(proveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.vInfo addSubview:proveButton];
    
    float vw=CGRectGetWidth(self.vInfo.bounds);
    
    CGRect frm;
    frm=RECT((vw-imgInfoBG.size.width)/2,90, imgInfoBG.size.width, imgInfoBG.size.height);
    imageView.frame=frm;
    imageView.image = imgInfoBG;
    
    float lw=vw-40*2;
    float lh=(imageName!=nil)?CGRectGetMaxY(imageView.frame) + 24:40;
    CGSize sz=[QWGLOBALMANAGER sizeText:textOne font:fontSystem(kFontS4) limitWidth:lw];
    lh = lh-6;
    frm=RECT((vw-lw)/2, lh, lw,sz.height);
    label1.frame=frm;
    label1.text = textOne;
    label2.frame =RECT((vw-lw)/2, lh+23, lw,sz.height);
    label2.text = textTwo;
    [proveButton setFrame:RECT(15, lh+60, APP_W-30,40)];
    
    [self.view addSubview:self.vInfo];
    [self.view bringSubviewToFront:self.vInfo];
    
    [self.view bringSubviewToFront:self.postCircleButton];
    
    //判断专家是否有挂靠商家
    if (isProved)
    {
        //没有挂靠商家：显示去认证按钮，隐藏发帖按钮
        self.postCircleButton.hidden = YES;
        self.postCircleButton.enabled = NO;
        proveButton.hidden = NO;
        proveButton.enabled = YES;

    }else
    {
        //有挂靠商家：隐藏去认证按钮，显示发帖按钮
        self.postCircleButton.hidden = NO;
        self.postCircleButton.enabled = YES;
        proveButton.hidden = YES;
        proveButton.enabled = NO;
    }

}

#pragma mark ---- 去认证 ----
- (void)proveAction
{
    
    [QWGLOBALMANAGER statisticsEventId:@"我的圈_去认证按键" withLable:@"圈子" withParams:nil];
    
    MyBrandViewController *vc = [[UIStoryboard storyboardWithName:@"MyInfomation" bundle:nil] instantiateViewControllerWithIdentifier:@"MyBrandViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    
    NSString *type = @"";
    if (self.expertType == 1){
        type = @"1";
    }else if (self.expertType == 2){
        type = @"2";
    }
    vc.expertType = type;
    [self.cusNavigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
