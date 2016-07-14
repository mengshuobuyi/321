//
//  OffSellViewController.m
//  wenYao-store
//  下架理由选择页
//  下架操作接口：WechatUpdateActivity
//  Created by qw_imac on 16/3/9.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "OffSellViewController.h"
#import "OffSellReasonTableViewCell.h"
#import "WechatActivity.h"
@interface OffSellViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray  *btnArray;
    NSArray         *reasonArray;
    NSInteger       index;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation OffSellViewController
static NSString *const cellIndentifier = @"OffSellReasonTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下架";
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn.titleLabel setFont:fontSystem(kFontS1)];
    [btn addTarget:self action:@selector(commitOperation) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *naviBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = naviBtn;
    [self.tableView registerNib:[UINib nibWithNibName:@"OffSellReasonTableViewCell" bundle:nil] forCellReuseIdentifier:cellIndentifier];
    btnArray = [@[] mutableCopy];
    reasonArray = @[@"活动结束下架",@"填写错误",@"活动测试",@"优惠商品订单量少",@"库存不足",@"其他"];
    index = 100;
}

-(void)commitOperation {
    if (index < 0 || index >= reasonArray.count) {
        [SVProgressHUD showErrorWithStatus:@"请选择下架理由" duration:1.0];
    }else {
        UpdateActivityR *modelR = [UpdateActivityR new];
        if (QWGLOBALMANAGER.configure.userToken) {
            modelR.token = QWGLOBALMANAGER.configure.userToken;
        }
        modelR.type = _type;
        modelR.actId = _actId;
        modelR.reason = reasonArray[index];
        [WechatActivity updateActivity:modelR success:^(UpdateActivityModel *responseModel) {
            if ([responseModel.apiStatus integerValue] == 0) {
                if (self.refresh) {
                    self.refresh();
                }
                [self popVCAction:nil];
            }
        } failure:^(HttpException *e) {
            
        }];
    }
}

-(void)choose:(UIButton *)sender {
    sender.selected = YES;
    index = sender.tag;
    for (UIButton *btn in btnArray) {
        if (btn != sender) {
            btn.selected = NO;
        }
    }
}
#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return reasonArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OffSellReasonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    [cell.reasonBtn addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    cell.reasonBtn.tag = indexPath.row;
    cell.reasonLabel.text = reasonArray[indexPath.row];
    [btnArray addObject:cell.reasonBtn];
    return cell;
}
@end
