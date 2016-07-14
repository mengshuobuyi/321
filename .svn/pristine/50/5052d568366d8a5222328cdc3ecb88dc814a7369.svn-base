//
//  StatisticHelpViewController.m
//  wenYao-store
//
//  Created by qwfy0006 on 15/5/5.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "StatisticHelpViewController.h"
#import "StatisticHelpCell.h"

@interface StatisticHelpViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation StatisticHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"帮助";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    
    self.dataArray = @[@{@"title":@"互动总数",@"content":@"本店抢到并已做回复的咨询问题总数。"},@{@"title":@"平均响应时间",@"content":@"本店从抢到问题到第一次回复所用时间之和除以互动总数。"},@{@"title":@"普通咨询",@"content":@"问药用户发送的咨询问题，同城药店药师皆可抢答。"},@{@"title":@"抢答数",@"content":@"本店抢答到的普通咨询问题的数量。"},@{@"title":@"应答数",@"content":@"本店抢到并做回复的问题数量"},@{@"title":@"抢而未答数",@"content":@"本店抢到问题后在规定时间内未回复或主动放弃回答该问题的总数。"},@{@"title":@"门店咨询",@"content":@"问药用户选择某一商户后向此商户发送点对点咨询问题，在一定时间内，此问题只对该门店可见。"},@{@"title":@"咨询数",@"content":@"本店收到的门店咨询问题的数量。"}];
}

#pragma mark ---- 列表代理 ----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *content = self.dataArray[indexPath.row][@"content"];
    
    CGSize contentSize =[GLOBALMANAGER sizeText:content font:fontSystem(kFontS4) constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
    
    float singleLabelHeight = 15.5;
    int line = contentSize.height/singleLabelHeight;
    
    return contentSize.height+(line-1)*3 + 37;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatisticHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StatisticHelpCell"];
    cell.title.text = self.dataArray[indexPath.row][@"title"];
    cell.content.text = self.dataArray[indexPath.row][@"content"];
    [cell setUpStyle];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
