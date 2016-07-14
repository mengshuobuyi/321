//
//  CreditMsgViewController.m
//  wenYao-store
//
//  Created by  ChenTaiyu on 16/5/18.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "CreditMsgViewController.h"
#import "CreditMsgTableViewCell.h"
#import "MsgBox.h"

@interface CreditMsgViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray <MsgBoxCreditMessageVo *> *dataList;
@property (nonatomic, copy) NSString *lastTimestamp;
@property (nonatomic, strong) NSMutableDictionary *offscreenCells;


@end

@implementation CreditMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"积分消息";
    self.dataList = [NSMutableArray array];
    __weak typeof (self) weakSelf = self;
    [self enableSimpleRefresh:self.tableView block:^(SRRefreshView *sender) {
        if(QWGLOBALMANAGER.currentNetWork == NotReachable)
        {
            [SVProgressHUD showErrorWithStatus:@"网络未连接，请稍后再试" duration:0.8f];
            return;
        }
        [weakSelf pullToRefresh];
    }];
    [self getCachedMessages];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
    if (iOSv8) {
        self.tableView.estimatedRowHeight = 95.f;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 根据readAll接口特性，刷新跟已读必然是同时发生的
    [self refreshConsultList:^{
        [self readAllMsg];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)readAllMsg
{
    MessageListReadAllModelR *modelR = [MessageListReadAllModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.type = @(MsgBoxMessageTypeCredit).stringValue;
    [MsgBox setReadAll:modelR success:^(BaseAPIModel *responseModel) {
        for (MsgBoxCreditMessageVo *model in self.dataList.copy) {
            model.read = @"1";
        }
        [self.tableView reloadData];
        [MsgBoxCreditMessageVo updateSetToDB:@"read = '1'" WithWhere:nil];
        [QWGLOBALMANAGER postNotif:NotiMsgBoxRedPointNeedUpdate data:nil object:self];
    } failure:^(HttpException *e) {
        // TODO:自动重试
        //        [SVProgressHUD showErrorWithStatus:kWaring12 duration:0.5];
    }];
}

- (void)showEmptyDataViewIfNeeded
{
    if (!self.dataList.count) {
        [self showInfoView:@"您还没有消息" image:@"ic_img_fail"];
    } else {
        [self removeInfoView];
    }
}

- (void)viewInfoClickAction:(id)sender
{
    [self refreshConsultList:^{
        [self readAllMsg];
    }];
}

- (void)pullToRefresh
{
    [self refreshConsultList:^{
        [self readAllMsg];
    }];
}

#pragma mark - cache methods
- (void)getCachedMessages
{
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:[MsgBoxCreditMessageVo getArrayFromDBWithWhere:nil WithorderBy:@" createTime desc"]];
}

- (void)refreshConsultList:(void(^)())completion
{
    MessageListModelR *modelR = [MessageListModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.view = @"100";
    [MsgBox getCreditNoticeList:modelR success:^(MessageArrayVo *responseModel) {
        if (!self.tableView.isDragging) [self endHeaderRefresh];
        MessageArrayVo *listModel = (MessageArrayVo *)responseModel;
        self.lastTimestamp = responseModel.lastTimestamp;
        if (listModel.messages.count > 0) {
            [MsgBoxCreditMessageVo syncDBWithObjArray:listModel.messages primaryKey:[MsgBoxCreditMessageVo getPrimaryKey]];
            [self getCachedMessages];
            [self removeInfoView];
        } else {
            [self showEmptyDataViewIfNeeded];
        }
        [self.tableView reloadData];
        DebugLog(@"the notice list is %@",self.dataList);
        [QWGLOBALMANAGER postNotif:NotiMsgBoxRedPointNeedUpdate data:nil object:self];
        if (completion) {
            completion();
        }
    } failure:^(HttpException *e) {
        if (!self.tableView.isDragging) [self endHeaderRefresh];
        [self showEmptyDataViewIfNeeded];
        if (completion) {
            completion();
        }
    }];
}


#pragma mark ---- 列表代理 ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CreditMsgTableViewCell *cell = [CreditMsgTableViewCell cellWithTableView:tableView];
    MsgBoxCreditMessageVo *msgModel = self.dataList[indexPath.row];
    [cell setMsgBoxCell:msgModel];
    //    cell.swipeDelegate = self;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (iOSv8) {
        return UITableViewAutomaticDimension;
    } else {
        NSString *reuseIdentifier = @"CreditMsgTableViewCell";
    ;
        CreditMsgTableViewCell *cell = [self.offscreenCells objectForKey:reuseIdentifier];
        if (!cell) {
            cell = (CreditMsgTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"CreditMsgTableViewCell" owner:nil options:nil] lastObject];
            [self.offscreenCells setObject:cell forKey:reuseIdentifier];
        }
        MsgBoxCreditMessageVo *msgModel = self.dataList[indexPath.row];
        [cell setMsgBoxCell:msgModel];
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        return height;
    }
}

#pragma mark ---- 接收通知 ----

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if (NotiMsgBoxNeedUpdate == type) {
// 全部已读接口不支持时间戳，无法操作。
//            [self getCachedMessages];
//            [self.tableView reloadData];
        [self refreshConsultList:^{
            [self readAllMsg];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
