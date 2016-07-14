//
//  PrivateMessageListViewController.m
//  wenYao-store
//
//  Created by 李坚 on 16/3/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "PrivateMessageListViewController.h"
#import "PrivateMessageTableViewCell.h"
#import "ChatViewController.h"

static NSString *const PrivateMessageTableViewCellIdentifier = @"PrivateMessageTableViewCell";

@interface PrivateMessageListViewController ()<UITableViewDataSource,UITableViewDelegate
>
@property (nonatomic, strong) UITableView *mainTableView;

@end

@implementation PrivateMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(!_mainTableView){
        
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H - NAV_H - TAB_H)];
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.backgroundColor = RGBHex(qwGcolor11);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.tableFooterView = [[UIView alloc]init];
        [_mainTableView registerNib:[UINib nibWithNibName:PrivateMessageTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:PrivateMessageTableViewCellIdentifier];
        [self.view addSubview:_mainTableView];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [PrivateMessageTableViewCell getCellHeight:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PrivateMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PrivateMessageTableViewCellIdentifier];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ChatViewController *VC = nil;
    VC= [[UIStoryboard storyboardWithName:@"ChatViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ChatViewController"];;
    
    VC.hidesBottomBarWhenPushed = YES;
    VC.branchId = @"0ce1b9fe82e54339960a4030f9cdcf94";
    VC.sessionID = @"";
    VC.chatType = IMTypePTPStore;
    
    [self.navController pushViewController:VC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
