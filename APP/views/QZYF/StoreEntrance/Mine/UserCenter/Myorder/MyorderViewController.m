//
//  MyorderViewController.m
//  wenyao-store
//
//  Created by chenpeng on 15/1/19.
//  Copyright (c) 2015年 xiezhenghong. All rights reserved.
//

#import "MyorderViewController.h"
#import "MyorderTableViewCell.h"
#import "ManageMyorderViewController.h"

@interface MyorderViewController()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *listArray;
}
@property (strong,nonatomic)UITableView *tableView;
@end
@implementation MyorderViewController
- (id)init{
    if (self = [super init]) {
        self.tableView=[[UITableView alloc]init];
        [self.tableView setFrame:CGRectMake(0, 0, APP_W, APP_H-NAV_H)];
        self.tableView.rowHeight = 50;
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor=RGBHex(qwColor11);
        [self.view addSubview:self.tableView];
        listArray=[NSMutableArray arrayWithObject:@"优惠活动订单管理"];

    }
    return self;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identiofierd=@"Myorder";
    MyorderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identiofierd];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyorderTableViewCell" owner:self options:nil][0];
        
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    [cell setCell:[listArray objectAtIndex:indexPath.row]];
    
    return cell;
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MyorderTableViewCell getCellHeight:nil];;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    ManageMyorderViewController *manageOrder=[[ManageMyorderViewController alloc]init];

    [self.navigationController pushViewController:manageOrder animated:YES];
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.title=@"历史订单";
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = barButtonItem;
}
@end
