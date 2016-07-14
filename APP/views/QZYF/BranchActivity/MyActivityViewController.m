//
//  MyorderViewController.m
//  wenyao-store
//
//  Created by chenpeng on 15/1/19.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "MyActivityViewController.h"
#import "MarketingActivityViewController.h"
#import "CoupnActivityViewController.h"
#import "WechatActivityViewController.h"
@interface MyActivityViewController()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *listArray;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MyActivityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"本店活动";
    
    if (QWGLOBALMANAGER.configure.storeType == 3) {
        //开通微商药房
        self.listArray = [NSMutableArray arrayWithObjects:@"微商活动",@"优惠活动",@"门店海报", nil];
        
    }else{
        //不开通微商药房
        self.listArray = [NSMutableArray arrayWithObjects:@"优惠活动",@"门店海报", nil];
    }

    [self setUpTableView];
}

#pragma mark ---- 设置 tableView ----

- (void)setUpTableView
{
    self.tableView=[[UITableView alloc]init];
    [self.tableView setFrame:CGRectMake(0, 0, APP_W, APP_H-NAV_H)];
    self.tableView.rowHeight = 50;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor=RGBHex(qwColor11);
    [self.view addSubview:self.tableView];
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
    return 46;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identiofierd=@"MyActivity";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identiofierd];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identiofierd];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 45.5, APP_W, 0.5)];
        line.backgroundColor = RGBHex(qwColor10);
        [cell addSubview:line];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.listArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.textColor = RGBHex(qwColor6);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (QWGLOBALMANAGER.configure.storeType == 3)
    {
        //开通微商
        if(indexPath.row == 0)
        {
            //微商活动
            WechatActivityViewController *vc = [WechatActivityViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 1)
        {
            // 优惠活动
            CoupnActivityViewController *coupnViewController = [[CoupnActivityViewController alloc] init];
            coupnViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:coupnViewController animated:YES];
            
        }else if (indexPath.row == 2)
        {
            // 门店海报
            MarketingActivityViewController *marketingActivityViewController = [[MarketingActivityViewController alloc] init];
            marketingActivityViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:marketingActivityViewController animated:YES];
        }
    }else
    {
        //不开通微商
        if(indexPath.row == 0)
        {
            // 优惠活动
            CoupnActivityViewController *coupnViewController = [[CoupnActivityViewController alloc] init];
            coupnViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:coupnViewController animated:YES];
            
        }else if (indexPath.row == 1)
        {
            // 门店海报
            MarketingActivityViewController *marketingActivityViewController = [[MarketingActivityViewController alloc] init];
            marketingActivityViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:marketingActivityViewController animated:YES];
        }
    }
    
    
}

@end
