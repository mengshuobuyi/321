//
//  AllTipsViewController.m
//  wenYao-store
//
//  Created by caojing on 15/8/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "TipProdctViewController.h"
#import "Tips.h"
#import "TipProductTableViewCell.h"

@interface TipProdctViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic)UITableView *tableView;

@end

@implementation TipProdctViewController

- (id)init{
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"所购商品";
    [self setUpTableView];
    self.totalPrice.text=[NSString stringWithFormat:@"总金额：￥%@",self.totalPricePro];
}

- (void)setUpTableView
{
    self.tableView=[[UITableView alloc]init];
    [self.tableView setFrame:CGRectMake(0, 0, APP_W, APP_H-NAV_H-44)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.tableView];
}

#pragma mark ---- 列表代理 ----

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.productList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TipProductTableViewCell getCellHeight:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"TipProductCell";
    TipProductTableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (Cell==nil) {
        Cell=[[NSBundle mainBundle]loadNibNamed:@"TipProductTableViewCell" owner:self options:nil][0];
        Cell.selectedBackgroundView.backgroundColor=RGBHex(qwColor10);
    }
    
    OrderDetailDrugVo *model=(OrderDetailDrugVo*)self.productList[indexPath.row];
    [Cell setCell:model];
    return Cell;
}

@end
