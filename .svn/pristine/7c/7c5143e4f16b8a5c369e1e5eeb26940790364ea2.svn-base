//
//  WechatActivityViewController.m
//  wenYao-store
//  微商活动列表页
//  请求微商活动列表接口：QueryMMallActivity
//  Created by qw_imac on 16/3/8.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "WechatActivityViewController.h"
#import "RightAccessButton.h"
#import "ComboxView.h"
#import "ComboxViewCell.h"
#import "WechatActivityCell.h"
#import "ActivityDetailViewController.h"
#import "WechatActivitySearchViewController.h"
#import "WechatActivity.h"
@interface WechatActivityViewController ()<UITableViewDataSource,UITableViewDelegate,ComboxViewDelegate>
{
    NSArray             *allArray;
    NSArray             *filtArray;
    NSArray             *btnArray;
    ComboxView          *filtView;
    RightAccessButton   *leftBtn;
    RightAccessButton   *midBtn;
    RightAccessButton   *rightBtn;
    NSInteger           leftIndex;
    NSInteger           midIndex;
    NSInteger           rightIndex;
    NSInteger           currPage;
    NSMutableArray      *dataSource;
}
@end

@implementation WechatActivityViewController
static NSString *const MenuIdentifier = @"MenuIdentifier";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品活动";
    leftIndex = 0;
    midIndex = 0;
    rightIndex = 0;
    currPage = 1;
    dataSource = [@[] mutableCopy];
    allArray = @[@[@"全部",@"全维",@"商家"],@[@"全部",@"优惠",@"抢购",@"套餐",@"换购"],@[@"全部",@"已上线",@"已下线"]];
    [self setUI];
    [self queryList];
}

- (void)setUI {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [button setImage:[UIImage imageNamed:@"navBar_icon_search_white"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoSearch) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *search = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = search;
    //创建顶部筛选
    UIView *filtrateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 40)];
    leftBtn = [[RightAccessButton alloc]initWithFrame:CGRectMake(0, 0, APP_W/3, 40)];
    midBtn = [[RightAccessButton alloc]initWithFrame:CGRectMake(APP_W/3, 0, APP_W/3, 40)];
    rightBtn = [[RightAccessButton alloc]initWithFrame:CGRectMake(APP_W/3 * 2, 0, APP_W/3, 40)];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(APP_W/3, 8, 0.5, 24)];
    line1.backgroundColor = RGBHex(qwColor10);
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(APP_W/3 * 2, 8, 0.5, 24)];
    line2.backgroundColor = RGBHex(qwColor10);
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0,39.5, APP_W, 0.5)];
    line3.backgroundColor = RGBHex(qwColor10);
    btnArray = @[leftBtn,midBtn,rightBtn];
    for (NSInteger index = 1; index <= btnArray.count; index ++) {
        RightAccessButton *btn = btnArray[index - 1];
        btn.tag = index;
        btn.backgroundColor = RGBHex(qwColor4);
        btn.customColor = RGBHex(qwColor6);
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 11)];
        [img setImage:[UIImage imageNamed:@"icon_downArrow"]];
        btn.accessIndicate = img;
        switch (index) {
            case 1:
                [btn setButtonTitle:@"来源"];
                break;
            case 2:
                [btn setButtonTitle:@"类型"];
                break;
            case 3:
                [btn setButtonTitle:@"状态"];
                break;
        }
        [btn addTarget:self action:@selector(showFilt:) forControlEvents:UIControlEventTouchUpInside];
        [filtrateView addSubview:btn];
    }
    [filtrateView addSubview:line1];
    [filtrateView addSubview:line2];
    [filtrateView addSubview:line3];
    self.tableMain =[[UITableView alloc] initWithFrame:CGRectMake(0, 40 , APP_W, [[UIScreen mainScreen] bounds].size.height - 64 - 40) style:UITableViewStylePlain];
    self.tableMain.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableMain.delegate = self;
    self.tableMain.dataSource = self;
    self.tableMain.backgroundColor = [UIColor clearColor];
    __weak typeof(self) weakSelf = self;
    [self.tableMain addFooterWithCallback:^{
        [weakSelf loadMore];
    }];
    [self enableSimpleRefresh:self.tableMain block:^(SRRefreshView *sender) {
        [weakSelf refresh];
    }];
    [self.view addSubview:self.tableMain];
    [self.view addSubview:filtrateView];
}

-(void)refresh {
    currPage = 1;
    HttpClientMgr.progressEnabled = NO;
    [self queryList];
}

-(void)loadMore {
    currPage++;
    HttpClientMgr.progressEnabled = NO;
    [self queryList];
}

- (void)gotoSearch {
    WechatActivitySearchViewController *vc = [WechatActivitySearchViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)comboxViewDidDisappear:(ComboxView *)combox {
    switch (combox.tag /100) {
        case 1:
            if (leftBtn.isToggle) {
                [leftBtn toggleButtonWithAccessView];
                [leftBtn setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
            }
            break;
        case 2:
            if (midBtn.isToggle) {
                [midBtn toggleButtonWithAccessView];
                [midBtn setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
            }
            break;
        case 3:
            if (rightBtn.isToggle) {
                [rightBtn toggleButtonWithAccessView];
                [rightBtn setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
            }
            break;
        default:
            break;
    }
}

- (void)showFilt:(UIButton *)sender {
    filtArray = allArray[sender.tag - 1];
    RightAccessButton *btn = (RightAccessButton *)sender;
    [btn toggleButtonWithAccessView];
    //修正其他筛选箭头
    for (RightAccessButton *button in btnArray) {
        if (btn != button) {
            if (button.isToggle) {
                //若其他筛选是展开的，先将其他展开的箭头修正，再移除视图
                [button toggleButtonWithAccessView];
                [button setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
                [filtView dismissView];
            }
        }
    }    
    if (!btn.isToggle) {
        [btn setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
        [filtView dismissView];
        return;
    }
    [btn setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
    filtView = [[ComboxView alloc] initWithFrame:CGRectMake(0, 40, APP_W, [filtArray count]*44)];
    filtView.tag = sender.tag *100;
    [filtView.tableView registerClass:[ComboxViewCell class] forCellReuseIdentifier:MenuIdentifier];
    filtView.delegate = self;
    filtView.comboxDeleagte = self;
    filtView.tableView.scrollEnabled = NO;
    [filtView showInView:self.view];
}

#pragma - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == filtView.tableView) {
        return 1;
    }else {
        return dataSource.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == filtView.tableView) {
        return filtArray.count;
    }else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == filtView.tableView) {
        ComboxViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MenuIdentifier];
        cell.textLabel.font = fontSystem(kFontS4);
        cell.textLabel.textColor = RGBHex(qwColor1);
        cell.separatorHidden = NO;
        NSString *content = filtArray[indexPath.row];
        switch (filtView.tag / 100) {
            case 1:
                [cell setCellWithContent:content showImage:leftIndex == indexPath.row];
                break;
            case 2:
                [cell setCellWithContent:content showImage:midIndex == indexPath.row];
                break;
            case 3:
                [cell setCellWithContent:content showImage:rightIndex == indexPath.row];
                break;
        }
        return cell;
    }else  {
        WechatActivityCell *cell = (WechatActivityCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"WechatActivityCell" owner:nil options:nil][0];
        }
        MicroMallActivityVO *vo = dataSource[indexPath.section];
        [cell setCell:vo];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   {
    if (tableView == filtView.tableView) {
        return 44;
    }else {
        return 94;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == filtView.tableView) {
        //点击筛选条件，筛选按钮相应变化
        NSInteger index = filtView.tag / 100;
        RightAccessButton *btn = (RightAccessButton *)[self.view viewWithTag:index];
        NSArray *contentArray = allArray[index - 1];
        [btn setButtonTitle:contentArray[indexPath.row]];
        [btn setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
        [filtView dismissView];
        [btn toggleButtonWithAccessView];
        //记录哪个筛选框下选中的筛选条件位置
        switch (index) {
            case 1:
                leftIndex = indexPath.row;
                break;
            case 2:
                midIndex = indexPath.row;
                break;
            case 3:
                rightIndex = indexPath.row;
                break;
        }
        //根据筛选条件请求接口
        self.tableMain.footer.canLoadMore = YES;
        currPage = 1;
        [self queryList];
    }else {
        //进入活动详情
        MicroMallActivityVO *vo = dataSource[indexPath.section];
        ActivityDetailViewController *vc = [[ActivityDetailViewController alloc]initWithNibName:@"ActivityDetailViewController" bundle:nil];
        vc.type = [vo.type integerValue];
        vc.activityId = vo.actId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)queryList {
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [self showInfoView:kWaring12 image:@"img_network" flatY:40.0f];
    }else {
        [self removeInfoView];
        WechatActivityR *modelR = [WechatActivityR new];
        if (QWGLOBALMANAGER.configure.userToken) {
            modelR.token = QWGLOBALMANAGER.configure.userToken;
        }
        modelR.source = leftIndex;
        modelR.type = midIndex;
        if (rightIndex == 2) {
            modelR.status = 7;
        }else if (rightIndex == 1){
            modelR.status = 3;
        }else {
            modelR.status = 0;
        }
        modelR.currPage = currPage;
        modelR.pageSize = 10;
        [WechatActivity queryWechatActivityList:modelR success:^(WechatActivityModel *responseModel) {
            [self.tableMain.footer endRefreshing];
            if ([responseModel.apiStatus integerValue] == 0) {
                if (currPage == 1) {
                    [dataSource removeAllObjects];
                }
                [dataSource addObjectsFromArray:responseModel.resultList];
                if (dataSource.count == 0) {
                    [self showInfoView:@"暂无活动" image:@"ic_img_fail" flatY:40.0f];
                }
                if (responseModel.resultList.count == 0 && currPage != 1) {
                    self.tableMain.footer.canLoadMore = NO;
                }
                [self.tableMain reloadData];
            }
        } failure:^(HttpException *e) {
            [self.tableMain.footer endRefreshing];
        }];}
}
@end
