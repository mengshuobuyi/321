//
//  MemberSellDetailViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 15/12/1.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "MemberSellDetailViewController.h"
#import "PieChartView.h"
#import "MemberSellCell.h"
#import "Rpt.h"
#import "RptModel.h"

@interface MemberSellDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *values;

@end

@implementation MemberSellDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商家会员营销统计";
    self.values = [NSMutableArray array];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //请求数据
    [self queryData];

}

- (void)queryData
{
    [self removeInfoView];
    
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"mktgId"] = StrFromObj(self.mktgId);
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    
    [Rpt rptMktgByIdWithParams:setting success:^(id obj) {
        
        if ([obj[@"apiStatus"] integerValue] == 0) {
            NSArray *arr1 = [RptDetailTextModel parseArray:obj[@"labels"]];
            NSArray *arr2 = [RptDetailTextModel parseArray:obj[@"charts"]];
            [self.values addObjectsFromArray:arr1];
            [self.values addObjectsFromArray:arr2];
            [self.tableView reloadData];
            
        }else{
            [SVProgressHUD showErrorWithStatus:obj[@"apiMessage"]];
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


- (void)viewInfoClickAction:(id)sender
{
    [self queryData];
}

#pragma mark ---- 列表代理 ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.values.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberSellCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberSellCell"];
    RptDetailTextModel *model = self.values[indexPath.row];
    cell.title.text = model.label;
    cell.number.text = model.value;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
