//
//  HotCircleViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 15/12/17.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "HotCircleViewController.h"
#import "HotCircleCell.h"
#import "Circle.h"
#import "CircleModel.h"
#import "ExpertPageViewController.h"
#import "UserPageViewController.h"
#import "HotCirclePostCover.h"
#import "SendPostViewController.h"
#import "PostDetailViewController.h"

@interface HotCircleViewController ()<UITableViewDataSource,UITableViewDelegate,HotCircleCellDelegate>
{
    NSInteger currentPage;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;

//发帖按钮
@property (weak, nonatomic) IBOutlet UIButton *postCircleButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postBtn_layout_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postBtn_layout_bottom;
- (IBAction)postTopicAction:(id)sender;

@end

@implementation HotCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    currentPage = 1;
    
    self.dataList = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.postCircleButton.layer.cornerRadius = 24;
    self.postCircleButton.layer.masksToBounds = YES;
    
    [QWGLOBALMANAGER statisticsEventId:@"热门帖页面_出现" withLable:@"圈子" withParams:nil];
    
    //下拉刷新
    __weak HotCircleViewController *weakSelf = self;
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
    
    //暂时隐藏发帖
    //显示蒙层
//    ShowHotCirclePostCover();
    self.postCircleButton.hidden = YES;
    self.postCircleButton.enabled = NO;
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
    
    [Circle TeamGetTeamHotInfoWithParams:setting success:^(id obj) {
        
        self.tableView.footer.canLoadMore = YES;
        [self.tableView headerEndRefreshing];
        [self.dataList removeAllObjects];
        
        if ([obj[@"apiStatus"] integerValue] == 0)
        {
            NSMutableArray *keyArr = [NSMutableArray array];
            [keyArr addObject:NSStringFromClass([HotCircleTopModel class])];
            [keyArr addObject:NSStringFromClass([HotCircleNoticeModel class])];
            [keyArr addObject:NSStringFromClass([TopicListModel class])];
            NSMutableArray *valueArr = [NSMutableArray array];
            [valueArr addObject:@"teamList"];
            [valueArr addObject:@"noticePushList"];
            [valueArr addObject:@"postInfoList"];
            HotCirclePageModel *page = [HotCirclePageModel parse:obj ClassArr:keyArr Elements:valueArr];
            
            NSArray *arr = page.postInfoList;
            if (arr.count>0)
            {
                currentPage++;
                [self.dataList addObjectsFromArray:arr];
                [self.tableView reloadData];
                
            }else
            {
                [self showInfoView:@"您还没有热议帖子" image:@"ic_img_fail" appearBtn:YES];
            }
        }else
        {
            [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"]];
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
    
    [Circle TeamGetTeamHotInfoWithParams:setting success:^(id obj) {
        [self.tableView footerEndRefreshing];
        
        if ([obj[@"apiStatus"] integerValue] == 0)
        {
            NSMutableArray *keyArr = [NSMutableArray array];
            [keyArr addObject:NSStringFromClass([HotCircleTopModel class])];
            [keyArr addObject:NSStringFromClass([HotCircleNoticeModel class])];
            [keyArr addObject:NSStringFromClass([TopicListModel class])];
            NSMutableArray *valueArr = [NSMutableArray array];
            [valueArr addObject:@"teamList"];
            [valueArr addObject:@"noticePushList"];
            [valueArr addObject:@"postInfoList"];
            HotCirclePageModel *page = [HotCirclePageModel parse:obj ClassArr:keyArr Elements:valueArr];
            
            NSArray *arr = page.postInfoList;
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
                    [self showInfoView:@"您还没有热议帖子" image:@"ic_img_fail" appearBtn:YES];
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

    [cell configureData:self.dataList[indexPath.row] type:2];
    cell.topView.obj = indexPath;
    cell.hotCircleCellDelegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [QWGLOBALMANAGER statisticsEventId:@"热门帖_帖子列表" withLable:@"圈子" withParams:nil];
    
    //帖子详情
    PostDetailViewController* postDetailVC = [[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"PostDetailViewController"];
    TopicListModel* topic = self.dataList[indexPath.row];
    postDetailVC.postId = topic.postId;
    postDetailVC.hidesBottomBarWhenPushed = YES;
    [self.cusNavigationController pushViewController:postDetailVC animated:YES];
}

#pragma mark ---- 发帖 ----
- (IBAction)postTopicAction:(id)sender
{
    if (QWGLOBALMANAGER.configure.silencedFlag) {
        [SVProgressHUD showErrorWithStatus:@"您已被禁言"];
        return;
    }
    
    SendPostViewController* sendPostVC = [[UIStoryboard storyboardWithName:@"Forum" bundle:nil] instantiateViewControllerWithIdentifier:@"SendPostViewController"];
    sendPostVC.hidesBottomBarWhenPushed = YES;
    sendPostVC.needChooseCircle = YES;
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

#pragma mark ---- 无数据背景提示 ----
-(void)showInfoView:(NSString *)text image:(NSString*)imageName appearBtn:(BOOL)appear{
    [self showInfoView:text image:imageName tag:0 appearBtn:appear];
}

-(void)showInfoView:(NSString *)text image:(NSString*)imageName tag:(NSInteger)tag appearBtn:(BOOL)appear
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
    CGSize sz=[QWGLOBALMANAGER sizeText:text font:lblInfo.font limitWidth:lw];
    frm=RECT((vw-lw)/2, lh, lw,sz.height);
    lblInfo.frame=frm;
    lblInfo.text = text;
    
    [self.view addSubview:self.vInfo];
    [self.view bringSubviewToFront:self.vInfo];
    
    if (appear == YES) {
//        [self.view bringSubviewToFront:self.postCircleButton];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
