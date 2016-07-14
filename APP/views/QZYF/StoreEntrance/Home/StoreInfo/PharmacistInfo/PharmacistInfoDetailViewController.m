//
//  PharmacistInfoDetailViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/5/9.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "PharmacistInfoDetailViewController.h"
#import "PharmacistInfoDetailCell.h"

@interface PharmacistInfoDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *tableHeaderview;

@property (strong, nonatomic) IBOutlet UIView *tableFooterView;

@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *brandLabel;

@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation PharmacistInfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"药师详情";
    self.dataList = [NSMutableArray array];
    
    //擅长领域array
    if (self.pharmacistInfoModel.expertise && ![self.pharmacistInfoModel.expertise isEqualToString:@""]){
        NSArray *arr = [self.pharmacistInfoModel.expertise componentsSeparatedByString:SeparateStr];
        self.dataList = [NSMutableArray arrayWithArray:arr];
    }
    
    self.tableView.tableHeaderView = self.tableHeaderview;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setUpheader];
    [self setUpFooter];
    
    if (self.pharmacistInfoModel.userType == 3){
        //药师
        self.tableView.tableFooterView = self.tableFooterView;
    }else{
        //营养师
        self.tableView.tableFooterView = [[UIView alloc] init];
    }
}

#pragma mark ---- 设置header ----
- (void)setUpheader
{
    //头像
    self.headerIcon.layer.cornerRadius = 28.0;
    self.headerIcon.layer.masksToBounds = YES;
    [self.headerIcon setImageWithURL:[NSURL URLWithString:self.pharmacistInfoModel.headImageUrl] placeholderImage:[UIImage imageNamed:@"expert_ic_people"]];
    
    //姓名
    self.nameLabel.userInteractionEnabled = NO;
    self.nameLabel.text = self.pharmacistInfoModel.nickName;
}

#pragma mark ---- 设置footer ----
- (void)setUpFooter
{
    //我的品牌
    self.brandLabel.text = self.pharmacistInfoModel.groupName;
}

#pragma mark ---- UITableViewDelegate ----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PharmacistInfoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PharmacistInfoDetailCell"];
    cell.contentLabel.text = self.dataList[indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
