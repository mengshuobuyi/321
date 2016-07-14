//
//  CampAsignViewController.m
//  wenYao-store
//
//  Created by caojing on 16/5/9.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "CampAsignViewController.h"
#import "CampAsignTableViewCell.h"
#import "MarketingActivityViewController.h"
#import "WechatActivityViewController.h"
#import "BranchProductViewController.h"
#import "BranchCoupnViewController.h"

@interface CampAsignViewController()<UITableViewDataSource,UITableViewDelegate>
@property (weak,nonatomic) IBOutlet UITableView *campTableView;
@property (strong,nonatomic) NSMutableArray *listArray;
@property (strong,nonatomic)NSMutableArray *imageArray;
@end

@implementation CampAsignViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"营销活动";
    
    if (QWGLOBALMANAGER.configure.storeType == 3) {
        //开通微商药房
        self.listArray = [NSMutableArray arrayWithObjects:@"优惠券",@"优惠商品",@"门店海报", @"商品活动",nil];
        self.imageArray =[NSMutableArray arrayWithObjects:@"icon_coupons",@"icon_preferentialgoods",@"icon_posters", @"icon_activity-1",nil];
        
    }else{
        //不开通微商药房
        self.listArray = [NSMutableArray arrayWithObjects:@"优惠券",@"优惠商品",@"门店海报", nil];
        self.imageArray = [NSMutableArray arrayWithObjects:@"icon_coupons",@"icon_preferentialgoods",@"icon_posters", nil];
    }
    
    [self setUpTableView];
}

#pragma mark ---- 设置 tableView ----

- (void)setUpTableView
{
    self.campTableView.delegate=self;
    self.campTableView.dataSource=self;
    self.campTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.campTableView.backgroundColor=RGBHex(qwColor11);
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 5)];
    headView.backgroundColor=RGBHex(qwColor11);
    self.campTableView.tableHeaderView=headView;
}

#pragma mark ---- 列表代理 ----

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *circleDetailCell = @"CampAsignCell";
    CampAsignTableViewCell *cell = (CampAsignTableViewCell *)[tableView dequeueReusableCellWithIdentifier:circleDetailCell];
    if(cell == nil){
        UINib *nib = [UINib nibWithNibName:@"CampAsignTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:circleDetailCell];
        cell = (CampAsignTableViewCell *)[tableView dequeueReusableCellWithIdentifier:circleDetailCell];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.titleContent.text=self.listArray[indexPath.row];
    cell.imageContent.image=[UIImage imageNamed:self.imageArray[indexPath.row]];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if(indexPath.row == 0)
        {
            //优惠券
            BranchCoupnViewController *coupnViewController = [[BranchCoupnViewController alloc] init];
            coupnViewController.hidesBottomBarWhenPushed = YES;
            coupnViewController.navigationController=self.navigationController;
            [self.navigationController pushViewController:coupnViewController animated:YES];
        }else if(indexPath.row == 1)
        {
            // 优惠商品
            BranchProductViewController *productViewController = [[BranchProductViewController alloc] init];
//            productViewController.navigationController=self.navigationController;
            productViewController.hidesBottomBarWhenPushed = YES;
            productViewController.isFromActivity = YES;
            [self.navigationController pushViewController:productViewController animated:YES];
            
        }else if (indexPath.row == 2)
        {
            // 门店海报
            MarketingActivityViewController *marketingActivityViewController = [[MarketingActivityViewController alloc] init];
            marketingActivityViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:marketingActivityViewController animated:YES];
        }else if (indexPath.row == 3)
        {
            // 商品活动
            WechatActivityViewController *vc = [WechatActivityViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
