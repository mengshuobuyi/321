//
//  LookMasterViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/7.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "LookMasterViewController.h"
#import "LookMasterCell.h"
#import "Circle.h"
#import "CircleModel.h"
#import "ExpertPageViewController.h"
#import "UserPageViewController.h"

@interface LookMasterViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//底部黄色view高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomView_layout_height;

@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) CircleMasterPageModel *pageModel;

//申请按钮
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
- (IBAction)applyAction:(id)sender;

@end

@implementation LookMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"查看圈主";
    self.dataList = [NSMutableArray array];
    self.pageModel = [CircleMasterPageModel new];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.applyButton.layer.cornerRadius = 4.0;
    self.applyButton.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self queryData];
}

#pragma mark ---- 请求数据 ----
- (void)queryData
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    setting[@"teamId"] = StrFromObj(self.teamId);
    [Circle teamGetMbrInfoListByTeamIdWithParams:setting success:^(id obj) {
        
        CircleMasterPageModel *page = [CircleMasterPageModel parse:obj Elements:[CircleMaserlistModel class] forAttribute:@"mbrInfoList"];
        
        if ([page.apiStatus integerValue] == 0)
        {
            self.pageModel = page;
            [self.dataList removeAllObjects];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupBottomData];
            });
            
            [self.dataList addObjectsFromArray:page.mbrInfoList];
            [self.tableView reloadData];
        }else
        {
            [SVProgressHUD showErrorWithStatus:page.apiMessage];
        }
    } failure:^(HttpException *e) {
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

#pragma mark ---- 设置申请按钮 ----
- (void)setupBottomData
{
    if (self.pageModel.masterFlag)
    {
        //我是圈主
        self.bottomView_layout_height.constant = 0;
        self.applyButton.hidden = YES;
    }else
    {
        self.bottomView_layout_height.constant = 49;
        self.applyButton.hidden = NO;
        if (self.pageModel.mbrInfoList.count >= 5)
        {
            //圈主已满
            [self.applyButton setTitle:@"圈主已满" forState:UIControlStateNormal];
            self.applyButton.backgroundColor = RGBHex(qwColor9);
            self.applyButton.enabled = NO;
        }else
        {
            if (self.pageModel.applyFlag)
            {
                //未申请
                [self.applyButton setTitle:@"申请做圈主" forState:UIControlStateNormal];
                self.applyButton.backgroundColor = RGBHex(qwColor2);
                self.applyButton.enabled = YES;
            }else
            {
                //已申请
                [self.applyButton setTitle:@"已申请做圈主" forState:UIControlStateNormal];
                self.applyButton.backgroundColor = RGBHex(qwColor9);
                self.applyButton.enabled = NO;
            }
        }
    }
}

#pragma mark ---- UITableViewDelegate ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 97;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LookMasterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LookMasterCell"];
    [cell setCell:self.dataList[indexPath.row]];
    cell.attentionButton.tag = indexPath.row + 10;
    [cell.attentionButton addTarget:self action:@selector(attentionMasterAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CircleMaserlistModel *model = self.dataList[indexPath.row];
    
    //当前登陆用户 不可点击
    if ([model.id isEqualToString:QWGLOBALMANAGER.configure.expertPassportId]) {
        return;
    }
    
    if (model.userType == 3 || model.userType == 4)
    {
        //专家
        ExpertPageViewController *vc = [[UIStoryboard storyboardWithName:@"ExpertPage" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertPageViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.posterId = model.id;
        vc.expertType = model.userType;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        //普通用户
        UserPageViewController *vc = [[UIStoryboard storyboardWithName:@"UserPage" bundle:nil] instantiateViewControllerWithIdentifier:@"UserPageViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.mbrId = model.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ---- 关注 ----
- (void)attentionMasterAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    if (QWGLOBALMANAGER.configure.silencedFlag) {
        [SVProgressHUD showErrorWithStatus:@"您已被禁言"];
        return;
    }
    
    UIButton *btn = (UIButton *)sender;
    int row = btn.tag-10;
    
    CircleMaserlistModel *model = self.dataList[row];
    NSString *type;
    if (model.isAttnFlag) {
        //取消关注
        type = @"1";
    }else{
        //关注
        type = @"0";
    }
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"objId"] = StrFromObj(model.id);
    setting[@"reqBizType"] = StrFromObj(type);
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    
    [Circle teamAttentionMbrWithParams:setting success:^(id obj){
        
        if ([obj[@"apiStatus"] integerValue] == 0)
        {
            [SVProgressHUD showSuccessWithStatus:obj[@"apiMessage"]];
            model.isAttnFlag = !model.isAttnFlag;
            [self.dataList replaceObjectAtIndex:row withObject:model];
            [self.tableView reloadData];
        }else
        {
            [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"]];
        }
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark ---- 申请做圈主 ----
- (IBAction)applyAction:(id)sender
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"teamId"] = StrFromObj(self.teamId);
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.expertToken);
    [Circle teamApplyMasterInfoWithParams:setting success:^(id obj) {
        
        if ([obj[@"apiStatus"] integerValue] == 0)
        {
            [SVProgressHUD showSuccessWithStatus:@"申请已提交，请等待审核"];
            [self.applyButton setTitle:@"已申请做圈主" forState:UIControlStateNormal];
            self.applyButton.backgroundColor = RGBHex(qwColor9);
            self.applyButton.enabled = NO;
        }else
        {
            [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"]];
        }
    } failure:^(HttpException *e) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
