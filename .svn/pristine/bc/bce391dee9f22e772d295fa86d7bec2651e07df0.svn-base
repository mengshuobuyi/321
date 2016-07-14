//
//  PayMentViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/7/11.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "PayMentViewController.h"
#import "PayMentCell.h"
#import "Bmmall.h"
#import "StoreModel.h"

@interface PayMentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation PayMentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付方式";
    self.dataArray = [NSMutableArray array];
    
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self queryInfo];
}

- (void)queryInfo
{
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:DURATION_SHORT];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    [Bmmall BmmallPayModeWithParams:setting success:^(id obj) {
        
        PayMentPageModel *page = [PayMentPageModel parse:obj Elements:[PayMentListModel class] forAttribute:@"pay"];
        if ([page.apiStatus integerValue] == 0)
        {
            if (page.pay && page.pay.count > 0)
            {
                [self.dataArray addObjectsFromArray:page.pay];
                [self.tableView reloadData];
            }else
            {
                [self showInfoView:@"暂无配送方式" image:@"ic_img_fail"];
            }
        }else
        {
            [SVProgressHUD showErrorWithStatus:page.apiMessage];
        }
        
    } failure:^(HttpException *e) {
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable){
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

#pragma mark ---- UITableViewDelegate ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return .1;
    }
    return 7;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 7)];
    vv.backgroundColor = RGBHex(qwColor11);
    return vv;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayMentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayMentCell"];
    PayMentListModel *model = self.dataArray[indexPath.section];
    cell.contentLabel.text = model.payDesc;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
