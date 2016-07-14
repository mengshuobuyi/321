//
//  PrivateMessageListViewController.m
//  wenYao-store
//  私聊列表
//  私聊列表接口单独放在ExpertChatUrl.h中，切勿与API.h混淆
//  私聊列表全量  h5/team/chat/session/getAll
//  私聊列表增量  h5/team/chat/session/getChatList
//  私聊列表删除  h5/team/chat/session/del
//
//  Created by 李坚 on 16/3/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "PrivateMessageListViewController.h"
#import "PrivateMessageTableViewCell.h"
#import "ExpertMessageCenter.h"
#import "ExpertChatViewController.h"

static NSString *const PrivateMessageTableViewCellIdentifier = @"PrivateMessageTableViewCell";

@interface PrivateMessageListViewController ()<UITableViewDataSource,UITableViewDelegate
>{
    NSTimer *textTime;
}



@end

@implementation PrivateMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataArray = [NSMutableArray arrayWithArray:[IMChatPointVo getArrayFromDBWithWhere:@"" WithorderBy:@"respondDate DESC"]];
    
    if(!_mainTableView){
        
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, APP_W, APP_H - NAV_H - TAB_H)];
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.backgroundColor = RGBHex(qwColor11);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.tableFooterView = [[UIView alloc]init];
        [_mainTableView registerNib:[UINib nibWithNibName:PrivateMessageTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:PrivateMessageTableViewCellIdentifier];
        [self enableSimpleRefresh:_mainTableView block:^(SRRefreshView *sender) {
            
            [ExpertMessageCenter pollPrivateMessageExpertList];
        }];
        [self.view addSubview:_mainTableView];
    }
    
    self.view.backgroundColor = [UIColor blueColor];
    
    [QWGLOBALMANAGER statisticsEventId:@"私聊页面_出现" withLable:@"圈子" withParams:nil];


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark - ReceiveNotification
- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if(type == NotiRefreshPrivateExpert){

        _dataArray = [NSMutableArray arrayWithArray:[IMChatPointVo getArrayFromDBWithWhere:@"" WithorderBy:@"respondDate DESC"]];
        [_mainTableView reloadData];
        [self endHeaderRefresh];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [PrivateMessageTableViewCell getCellHeight:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PrivateMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PrivateMessageTableViewCellIdentifier];
    
    [cell setCell:_dataArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    IMChatPointVo *VO = [_dataArray objectAtIndex:indexPath.row];
    VO.readFlag = @"1";
    NSString *where = [NSString stringWithFormat:@"sessionId = '%@'",VO.sessionId];
    [IMChatPointVo updateToDB:VO where:where];
    
    ExpertChatViewController *VC = [[UIStoryboard storyboardWithName:@"ExpertChatViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"ExpertChatViewController"];
    VC.title = StrIsEmpty(VO.nickname)?@"聊天":VO.nickname;
    VC.recipientId = VO.recipientId;
    VC.sessionId = VO.sessionId;
    VC.hidesBottomBarWhenPushed = YES;
    [self.navController pushViewController:VC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        IMChatPointVo *VO = [_dataArray objectAtIndex:indexPath.row];
        NSString *where = [NSString stringWithFormat:@"sessionId = '%@'",VO.sessionId];
        [IMChatPointVo deleteWithWhere:where];
        
        ExpertDeleteModelR *modelR = [ExpertDeleteModelR new];
        modelR.token = QWGLOBALMANAGER.configure.expertToken;
        modelR.sessionId = VO.sessionId;
        
        [ExpertAPI DeletePMChat:modelR success:^(BaseAPIModel *responModel) {
            
            if([responModel.apiStatus intValue] == 0){
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                [_dataArray removeObjectAtIndex:indexPath.row];
                [_mainTableView reloadData];
        
            }else{
                [SVProgressHUD showSuccessWithStatus:@"删除失败"];
            }
            
        } failure:^(HttpException *e) {
            [SVProgressHUD showSuccessWithStatus:@"删除Failure"];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
