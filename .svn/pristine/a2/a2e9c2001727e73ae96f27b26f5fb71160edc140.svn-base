//
//  MarketSelectTicketViewController.m
//  wenYao-store
//
//  会员营销选择券页面
//  h5/mmall/mktg/queryCoupons
//  Created by PerryChen on 5/11/16.
//  Copyright © 2016 carret. All rights reserved.
//

#import "MarketSelectTicketViewController.h"
#import "FirstCoupnTableViewCell.h"
#import "ThreeCoupnTableViewCell.h"

#import "MemberMarket.h"
#define ThreeCoupnCell @"ThreeCoupnCell"
#define FirstCoupnCell @"FirstCoupnCell"

@interface MarketSelectTicketViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbViewContent;
@property (nonatomic, strong) NSMutableArray *arrTicket;
@property (nonatomic, assign) NSInteger intSelectTicket;
@end

@implementation MarketSelectTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择优惠券";
    UINib *nibOne = [UINib nibWithNibName:@"FirstCoupnTableViewCell" bundle:nil];
    [self.tbViewContent registerNib:nibOne forCellReuseIdentifier:FirstCoupnCell];
    UINib *nibTwo = [UINib nibWithNibName:@"ThreeCoupnTableViewCell" bundle:nil];
    [self.tbViewContent registerNib:nibTwo forCellReuseIdentifier:ThreeCoupnCell];
    self.arrTicket = [NSMutableArray array];
    self.intSelectTicket = 0;
    [self getAllTickets];    
}

- (void)setCurSelectVo
{
    for (int i = 0; i < self.arrTicket.count; i++) {
        OnlineBaseCouponDetailVo *model = self.arrTicket[i];
        if ([model.couponId isEqualToString:self.modelVo.couponId]) {
            self.intSelectTicket = i+1;
        }
    }
    if (self.intSelectTicket > 0) {
        [self.tbViewContent reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getAllTickets
{
    MarketQueryTicketModelR *modelR = [MarketQueryTicketModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    [MemberMarket queryCouponTicketList:modelR success:^(MktgCouponListVo *responseModel) {
        [self.arrTicket removeAllObjects];
        [self.arrTicket addObjectsFromArray:responseModel.coupons];
        [self.tbViewContent reloadData];
        if (self.arrTicket.count == 0) {
            [self showInfoView:@"暂无优惠券" image:@"ic_img_fail"];
        } else {
//            if (self.modelVo != nil) {
//                [self setCurSelectVo];
//            }
        }
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark - UITableview methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrTicket.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OnlineBaseCouponDetailVo *model = self.arrTicket[indexPath.row];
    if (!StrIsEmpty(model.giftImgUrl)) {
        ThreeCoupnTableViewCell *threeCell = (ThreeCoupnTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ThreeCoupnCell];
        [threeCell setCoupnOtherDetailCell:model];
        threeCell.viewContent.layer.borderWidth = 0.0f;
        if (self.intSelectTicket == indexPath.row + 1) {
            threeCell.viewContent.layer.borderColor = RGBHex(qwColor2).CGColor;
            threeCell.viewContent.layer.borderWidth = 2.0f;
        }
        return threeCell;
    } else {
        FirstCoupnTableViewCell *firstCell = (FirstCoupnTableViewCell *)[tableView dequeueReusableCellWithIdentifier:FirstCoupnCell];
        [firstCell setCoupnOtherDetailCell:model];
        firstCell.viewContent.layer.borderWidth = 0.0f;
        if (self.intSelectTicket == indexPath.row + 1) {
            firstCell.viewContent.layer.borderColor = RGBHex(qwColor2).CGColor;
            firstCell.viewContent.layer.borderWidth = 2.0f;
        }
        return firstCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 117.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OnlineBaseCouponDetailVo *model = self.arrTicket[indexPath.row];
    self.intSelectTicket = indexPath.row + 1;
    [self.tbViewContent reloadData];
    self.block(model);
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
