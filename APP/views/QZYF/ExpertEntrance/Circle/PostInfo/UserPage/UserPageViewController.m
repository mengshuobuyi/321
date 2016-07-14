//
//  UserPageViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/15.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "UserPageViewController.h"
#import "UserPageCell.h"
#import "UserPagePostViewController.h"
#import "UserPageReplyViewController.h"
#import "UserPageAttenCircleViewController.h"
#import "MyFollowExpertViewController.h"
#import "Circle.h"
#import "CircleModel.h"

@interface UserPageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;

@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;   //头像
@property (weak, nonatomic) IBOutlet UILabel *name;             //姓名
@property (weak, nonatomic) IBOutlet UIView *lvlBgView;         //用户等级
@property (weak, nonatomic) IBOutlet UILabel *lvlLabel;         //用户等级
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView; //性别
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *name_layout_width;

@property (strong, nonatomic) NSMutableArray *titleList;
@property (strong, nonatomic) ExpertMemInfoModel *infoModel;    //用户信息model

@end

@implementation UserPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleList = [NSMutableArray arrayWithObjects:@[@"Ta的发帖",@"Ta的回帖"],@[@"Ta关注的圈子",@"Ta关注的专家"], nil];
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.infoModel = [ExpertMemInfoModel new];
    [self queryUserInfo];
}

#pragma mark ---- 获取用户个人信息 ----
- (void)queryUserInfo
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"mbrId"] = StrFromObj(self.mbrId);
    setting[@"tokenFlag"] = @"N";
    [Circle TeamMyInfoWithParams:setting success:^(id obj) {
        
        ExpertMemInfoModel *model = [ExpertMemInfoModel parse:obj];
        if ([model.apiStatus integerValue] == 0)
        {
            if (model.silencedFlag)
            {
                [self showInfoView:@"该用户被禁言" image:@"ic_img_cry"];
            }else
            {
                self.infoModel = model;
                [self setUpTableHeaderView];
                [self.tableView reloadData];
            }
        }else
        {
            [SVProgressHUD showErrorWithStatus:model.apiMessage];
        }
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 设置headerView  ----
- (void)setUpTableHeaderView
{
    //头像
    self.headerIcon.layer.cornerRadius = 27.5;
    self.headerIcon.layer.masksToBounds = YES;
    [self.headerIcon setImageWithURL:[NSURL URLWithString:self.infoModel.headImageUrl] placeholderImage:[UIImage imageNamed:@"expert_ic_people"]];
    
    //姓名
    self.name.text = self.infoModel.nickName;
    CGSize size=[self.name.text sizeWithFont:fontSystem(kFontS1) constrainedToSize:CGSizeMake(APP_W-50, CGFLOAT_MAX)];
    self.name_layout_width.constant = size.width+4;
    
    //用户等级
    self.lvlLabel.text = [NSString stringWithFormat:@"V%d",self.infoModel.mbrLvl];
    
    //性别
    if (self.infoModel.sex == 0)
    {
        self.sexImageView.hidden = NO;
        [self.sexImageView setImage:[UIImage imageNamed:@"home_ic_man"]];
    }else if (self.infoModel.sex == 1)
    {
        self.sexImageView.hidden = NO;
        [self.sexImageView setImage:[UIImage imageNamed:@"home_ic_woman"]];
    }else
    {
        self.sexImageView.hidden = YES;
    }
}

#pragma mark ---- UITableViewDelegate ----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 7)];
    vv.backgroundColor = RGBHex(qwColor11);
    return vv;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.titleList[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserPageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserPageCell"];
    cell.title.text = self.titleList[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        //Ta的发帖
        
        UserPagePostViewController *vc = [[UIStoryboard storyboardWithName:@"UserPage" bundle:nil] instantiateViewControllerWithIdentifier:@"UserPagePostViewController"];
        vc.expertId = self.infoModel.id;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 0 && indexPath.row == 1)
    {
        //Ta的回帖
        
        UserPageReplyViewController *vc = [[UIStoryboard storyboardWithName:@"UserPage" bundle:nil] instantiateViewControllerWithIdentifier:@"UserPageReplyViewController"];
        vc.expertId = self.infoModel.id;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 0)
    {
        //Ta关注的圈子
        
        UserPageAttenCircleViewController *vc = [[UIStoryboard storyboardWithName:@"UserPage" bundle:nil] instantiateViewControllerWithIdentifier:@"UserPageAttenCircleViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.userId = self.infoModel.id;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 1)
    {
        //Ta关注的专家
        
        MyFollowExpertViewController *vc = [[UIStoryboard storyboardWithName:@"MyFollowExpert" bundle:nil] instantiateViewControllerWithIdentifier:@"MyFollowExpertViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.jumpType = 2;
        vc.userId = self.infoModel.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
