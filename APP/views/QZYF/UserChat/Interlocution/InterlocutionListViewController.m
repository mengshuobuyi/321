//
//  InterlocutionListViewController.m
//  wenYao-store
//
//  Created by 李坚 on 16/3/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "InterlocutionListViewController.h"
#import "InterlocutionTableViewCell.h"

static NSString *const InterlocutionCellIdentifier = @"InterlocutionTableViewCell";

@interface InterlocutionListViewController ()<UITableViewDataSource,UITableViewDelegate,InterlocutionTableViewCellDelegate>

@property (nonatomic, strong) UITableView *mainTableView;

@end

@implementation InterlocutionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(!_mainTableView){
        
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H - NAV_H - TAB_H - 35)];
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.backgroundColor = RGBHex(qwGcolor11);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.tableFooterView = [[UIView alloc]init];
        [_mainTableView registerNib:[UINib nibWithNibName:InterlocutionCellIdentifier bundle:nil] forCellReuseIdentifier:InterlocutionCellIdentifier];
        [self.view addSubview:_mainTableView];
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [InterlocutionTableViewCell getCellHeight:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InterlocutionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InterlocutionCellIdentifier];
    cell.path = indexPath;
    cell.btnDelegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    [self.navController pushViewController:VC animated:YES];
}

#pragma mark - InterlocutionTableViewCellDelegate
- (void)ignoreMessageAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)answerMessageAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
