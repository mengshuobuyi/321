//
//  OrderMsgViewController.m
//  wenYao-store
//
//  Created by  ChenTaiyu on 16/5/12.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "OrderMsgViewController.h"
#import "InfoNotifiCell.h"
#import "QWYSViewController.h"
#import "MsgNotifyOrderCell.h"
#import "QWMessage.h"
#import "Order.h"
#import "MGSwipeButton.h"
#import "MGSwipeTableCell.h"
#import "IndentDetailListViewController.h"
#import "InternalProductDetailViewController.h"
#import "ActivityDetailViewController.h"
#import "MsgBox.h"
#import "CustomPopListView.h"

@interface OrderMsgViewController () <UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate, CustomPopListViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (nonatomic, copy) NSString *lastTimestamp;
@property (nonatomic, strong) CustomPopListView *customPopListView;

@end

@implementation OrderMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单通知";
    [self setUpRightItem];

    self.dataList = [NSMutableArray array];
    __weak typeof (self) weakSelf = self;
    [self enableSimpleRefresh:self.tableView block:^(SRRefreshView *sender) {
        if(QWGLOBALMANAGER.currentNetWork == NotReachable)
        {
            [SVProgressHUD showErrorWithStatus:@"网络未连接，请稍后再试" duration:0.8f];
            return;
        }
        [weakSelf refreshConsultList];
    }];
    [self getCachedMessages];
    
    if (self.dataList.count) {
        [self removeInfoView];
    } else {
        [self showInfoView:@"您还没有消息" image:@"ic_img_fail"];
    }
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshConsultList];
}

- (void)setUpRightItem
{
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = -15;
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    bg.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(18, -1, 60, 44);
    [btn setImage:[UIImage imageNamed:@"icon-unfold"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon-unfold"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(toggleReadAllBtn) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:btn];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:bg];
    self.navigationItem.rightBarButtonItems = @[fixed,item];
}



#pragma mark - 交互
- (void)customPopListView:(CustomPopListView *)ReturnIndexView didSelectedIndex:(NSIndexPath *)indexPath
{
    [self.customPopListView hide];
    
    if (indexPath.row == 0)
    {
        //全部标记为已读
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [SVProgressHUD showErrorWithStatus:kWaring33];
            return;
        }
        [self readAllMsg];
        [QWGLOBALMANAGER statisticsEventId:@"s_ddxx_qb" withLable:self.title withParams:nil];
    }
}


- (void)toggleReadAllBtn
{
    self.customPopListView = [CustomPopListView sharedManagerWithtitleList:@[@"全部标记为已读"]];
    self.customPopListView.delegate = self;
    [self.customPopListView show];
}

- (void)readAllMsg
{
    MessageListReadAllModelR *modelR = [MessageListReadAllModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.type = @(MsgBoxMessageTypeOrder).stringValue;
    [MsgBox setReadAll:modelR success:^(BaseAPIModel *responseModel) {
        for (MsgBoxOrderMessageVo *model in self.dataList.copy) {
            model.read = @"1";
        }
        [self.tableView reloadData];
        [MsgBoxOrderMessageVo updateSetToDB:@"read = '1'" WithWhere:nil];
        [QWGLOBALMANAGER postNotif:NotiMsgBoxRedPointNeedUpdate data:nil object:self];
    } failure:^(HttpException *e) {
        // TODO:自动重试
        //        [SVProgressHUD showErrorWithStatus:kWaring12 duration:0.5];
    }];
}

- (void)viewInfoClickAction:(id)sender
{
    [self refreshConsultList];
}

#pragma mark - cache methods
- (void)getCachedMessages
{
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:[MsgBoxOrderMessageVo getArrayFromDBWithWhere:nil WithorderBy:@" createTime desc"]];
}


- (void)refreshConsultList
{
    MessageListModelR *modelR = [MessageListModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.view = @"100";
    [MsgBox getOrderNoticeList:modelR success:^(MessageArrayVo *responseModel) {
        [self.tableView headerEndRefreshing];
        MessageArrayVo *listModel = (MessageArrayVo *)responseModel;
        //        [self removeInfoView];
        self.lastTimestamp = responseModel.lastTimestamp;
        if (listModel.messages.count > 0) {
            [MsgBoxOrderMessageVo syncDBWithObjArray:listModel.messages primaryKey:[MsgBoxOrderMessageVo getPrimaryKey]];
            [self getCachedMessages];
            [self removeInfoView];
        } else {
            [self showInfoView:@"您还没有消息" image:@"ic_img_fail"];
        }
        [self.tableView reloadData];
        DebugLog(@"the order list is %@",self.dataList);
        [QWGLOBALMANAGER postNotif:NotiMsgBoxRedPointNeedUpdate data:nil object:self];
    } failure:^(HttpException *e) {
        if (!self.dataList.count) {
            [self showInfoView:@"您还没有消息" image:@"ic_img_fail"];
        } else {
            [self removeInfoView];
        }
        [self.tableView headerEndRefreshing];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static MsgNotifyOrderCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [tableView dequeueReusableCellWithIdentifier:@"MsgNotifyOrderCell"];
    });
    MsgBoxOrderMessageVo *model = [self.dataList objectAtIndex:indexPath.row];
    [sizingCell setMsgBoxCell:model];
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(sizingCell.bounds));
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize sizeFinal = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return sizeFinal.height+1.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MsgNotifyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MsgNotifyOrderCell"];
    MsgBoxOrderMessageVo *msgModel = self.dataList[indexPath.row];
    [cell setMsgBoxCell:msgModel];
//    cell.swipeDelegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [QWGLOBALMANAGER statisticsEventId:@"s_ddxx_lb" withLable:self.title withParams:nil];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MsgBoxOrderMessageVo* msg = self.dataList[indexPath.row];
    if(msg) {
        // 走老的订单接口
        if (msg.messageId.length > 0 && !msg.read.boolValue) {
            [Order setOrderNotiReadWithMessageId:msg.messageId success:^(BaseAPIModel *model) {
                msg.read = @"1";
                //        [MsgBoxOrderMessageVo updateObjToDB:msg WithKey:msg.messageId];
                [[MsgBoxOrderMessageVo getUsingLKDBHelper] updateToDB:msg where:@{@"messageId" : msg.messageId}];
                [QWGLOBALMANAGER postNotif:NotiMsgBoxRedPointNeedUpdate data:nil object:self];

            } failure:^(HttpException *e) {
                DebugLog(@"%@", e.Edescription);
            }];
        }
        // 跳转不同详情
        if ([msg.objType intValue] == 20) {     // 跳转至商品详情
            InternalProductDetailViewController *vc = [[UIStoryboard storyboardWithName:@"InternalProduct" bundle:nil] instantiateViewControllerWithIdentifier:@"InternalProductDetailViewController"];
            vc.proId = msg.objId;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([msg.objType intValue] == 21) {      // 跳转至优惠
            ActivityDetailViewController *vc = [[ActivityDetailViewController alloc]initWithNibName:@"ActivityDetailViewController" bundle:nil];
            vc.type = 1;
            vc.activityId = msg.objId;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([msg.objType intValue] == 22) {      // 跳转至抢购
            ActivityDetailViewController *vc = [[ActivityDetailViewController alloc]initWithNibName:@"ActivityDetailViewController" bundle:nil];
            vc.type = 2;
            vc.activityId = msg.objId;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([msg.objType intValue] == 23) {      // 跳转至套餐
            ActivityDetailViewController *vc = [[ActivityDetailViewController alloc]initWithNibName:@"ActivityDetailViewController" bundle:nil];
            vc.type = 3;
            vc.activityId = msg.objId;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([msg.objType intValue] == 24) {      // 跳转至换购
            ActivityDetailViewController *vc = [[ActivityDetailViewController alloc]initWithNibName:@"ActivityDetailViewController" bundle:nil];
            vc.type = 4;
            vc.activityId = msg.objId;
            [self.navigationController pushViewController:vc animated:YES];
        } else { // obj type = 18
            IndentDetailListViewController *vcIndent = [IndentDetailListViewController new];
            vcIndent.orderId = msg.objId;
            [self.navigationController pushViewController:vcIndent animated:YES];
        }
    }
}

#pragma mark ---- 接收通知 ----

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if (NotiMsgBoxNeedUpdate == type) {
//        if (!self.tableView.isDragging && !self.tableView.isDecelerating && !self.tableView.isTracking && !self.tableView.isEditing) {
            [self getCachedMessages];
            [self.tableView reloadData];
//        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

