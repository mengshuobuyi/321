//
//  NotifyMsgViewController.m
//  wenYao-store
//
//  Created by  ChenTaiyu on 16/5/17.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "NotifyMsgViewController.h"
#import "NotifyMsgTableViewCell.h"
#import "MsgBox.h"
#import "SVProgressHUD.h"
#import "NotifyMsgDetailViewController.h"
#import "IndentDetailListViewController.h"
#import "InternalProductDetailViewController.h"
#import "ActivityDetailViewController.h"
#import "WebDirectModel.h"
#import "WebDirectViewController.h"
#import "CustomPopListView.h"

@interface NotifyMsgViewController ()<UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray <MsgBoxNotiMessageVo *> *dataList;
@property (nonatomic, copy) NSString *lastTimestamp;
@property (nonatomic, strong) NSMutableDictionary *offscreenCells;
@property (nonatomic, strong) CustomPopListView *customPopListView;


@end

@implementation NotifyMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpRightItem];
    
    self.title = @"消息中心";
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
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];

    if (iOSv8) {
        self.tableView.estimatedRowHeight = 90.f;
    }
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

    //    self.rightRedDot = [[UIImageView alloc] initWithFrame:CGRectMake(52, 8, 10, 10)];
    //    [self.rightRedDot setImage:[UIImage imageNamed:@"img_redDot"]];
    //    [bg addSubview:self.rightRedDot];
    
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
        [QWGLOBALMANAGER statisticsEventId:@"s_xxtz_qb" withLable:self.title withParams:nil];
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
    modelR.type = @(MsgBoxMessageTypeNotify).stringValue;
    [MsgBox setReadAll:modelR success:^(BaseAPIModel *responseModel) {
        for (MsgBoxNotiMessageVo *model in self.dataList.copy) {
            model.read = @"1";
        }
        [self.tableView reloadData];
        [MsgBoxNotiMessageVo updateSetToDB:@"read = '1'" WithWhere:nil];
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
    [self.dataList addObjectsFromArray:[MsgBoxNotiMessageVo getArrayFromDBWithWhere:nil WithorderBy:@" createTime desc"]];
}


- (void)refreshConsultList
{
    MessageListModelR *modelR = [MessageListModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.view = @"100";
    [MsgBox getNoNoticeList:modelR success:^(MessageArrayVo *responseModel) {
        [self.tableView headerEndRefreshing];
        MessageArrayVo *listModel = (MessageArrayVo *)responseModel;
        //        [self removeInfoView];
        self.lastTimestamp = responseModel.lastTimestamp;
#if DEBUG == 2
        MsgBoxNotiMessageVo *model = listModel.messages.firstObject;
        model.href = @"http://www.baidu.com";
        model.objType = @(MsgBoxCellActionTypeOutLink).stringValue;
#endif
        if (listModel.messages.count > 0) {
            [MsgBoxNotiMessageVo syncDBWithObjArray:listModel.messages primaryKey:[MsgBoxNotiMessageVo getPrimaryKey]];
            [self getCachedMessages];
            [self removeInfoView];
        } else {
            [self showInfoView:@"您还没有消息" image:@"ic_img_fail"];
        }
        [self.tableView reloadData];
        DebugLog(@"the notice list is %@",self.dataList);
        [QWGLOBALMANAGER postNotif:NotiMsgBoxRedPointNeedUpdate data:nil object:self];
    } failure:^(HttpException *e) {
        if (!self.dataList.count) {
            [self showInfoView:@"您还没有消息" image:@"ic_img_fail"];
        } else {
            [self removeInfoView];
        }
        DebugLog(@"[%@ %s] request failed", NSStringFromClass(self.class), __func__);
        [self.tableView headerEndRefreshing];
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshConsultList];
}


#pragma mark ---- 列表代理 ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    return 7.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotifyMsgTableViewCell *cell = [NotifyMsgTableViewCell cellWithTableView:tableView];
    MsgBoxNotiMessageVo *msgModel = self.dataList[indexPath.section];
    [cell setMsgBoxCell:msgModel];
    //    cell.swipeDelegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (iOSv8) {
        return UITableViewAutomaticDimension;
    } else {
        NSString *reuseIdentifier = @"NotifyMsgTableViewCell";
        ;
        NotifyMsgTableViewCell *cell = [self.offscreenCells objectForKey:reuseIdentifier];
        if (!cell) {
            cell = (NotifyMsgTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"NotifyMsgTableViewCell" owner:nil options:nil] lastObject];
            [self.offscreenCells setObject:cell forKey:reuseIdentifier];
        }
        MsgBoxNotiMessageVo *msgModel = self.dataList[indexPath.section];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [QWGLOBALMANAGER statisticsEventId:@"s_xxtz_lb" withLable:self.title withParams:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MsgBoxNotiMessageVo* msg = self.dataList[indexPath.section];
    if(msg) {
        // 更新红点逻辑
//        msg.read = @"1";
//        [MsgBoxOrderMessageVo updateObjToDB:msg WithKey:msg.messageId];
        if (msg.messageId.length > 0 && !msg.read.boolValue) {
            [MsgBox setNoticeReadWithMessageId:msg.messageId success:^(BaseAPIModel *model) {
                msg.read = @"1";
                [[MsgBoxNotiMessageVo getUsingLKDBHelper] updateToDB:msg where:@{@"messageId" : msg.messageId}];
                [QWGLOBALMANAGER postNotif:NotiMsgBoxRedPointNeedUpdate data:nil object:self];
            } failure:^(HttpException *error) {
                DebugLog(@"%@", error.Edescription);
            }];
        }
        // 跳转不同详情
        if ([msg.objType intValue] == MsgBoxCellActionTypeProductDetail) {     // 跳转至商品详情
            InternalProductDetailViewController *vc = [[UIStoryboard storyboardWithName:@"InternalProduct" bundle:nil] instantiateViewControllerWithIdentifier:@"InternalProductDetailViewController"];
            vc.proId = msg.objId;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([msg.objType intValue] == MsgBoxCellActionTypeCoupon) {      // 跳转至优惠
            ActivityDetailViewController *vc = [[ActivityDetailViewController alloc]initWithNibName:@"ActivityDetailViewController" bundle:nil];
            vc.type = 1;
            vc.activityId = msg.objId;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([msg.objType intValue] == MsgBoxCellActionTypeOnSales) {      // 跳转至抢购
            ActivityDetailViewController *vc = [[ActivityDetailViewController alloc]initWithNibName:@"ActivityDetailViewController" bundle:nil];
            vc.type = 2;
            vc.activityId = msg.objId;
            [self.navigationController pushViewController:vc animated:YES];
        } /*else if ([msg.objType intValue] == 23) {      // 跳转至套餐
            ActivityDetailViewController *vc = [[ActivityDetailViewController alloc]initWithNibName:@"ActivityDetailViewController" bundle:nil];
            vc.type = 3;
            vc.activityId = msg.objId;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([msg.objType intValue] == 24) {      // 跳转至换购
            ActivityDetailViewController *vc = [[ActivityDetailViewController alloc]initWithNibName:@"ActivityDetailViewController" bundle:nil];
            vc.type = 4;
            vc.activityId = msg.objId;
            [self.navigationController pushViewController:vc animated:YES];
        } */ else if (msg.objType.intValue == MsgBoxCellActionTypeOrder) { // 订单
            
            IndentDetailListViewController *vcIndent = [IndentDetailListViewController new];
            vcIndent.orderId = msg.objId;
            [self.navigationController pushViewController:vcIndent animated:YES];
        } else if (msg.objType.intValue == MsgBoxCellActionTypeNotOutLink) { // 无外链
            NotifyMsgDetailViewController *vc = [[NotifyMsgDetailViewController alloc]init];
            vc.msgModel = msg;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (msg.objType.intValue == MsgBoxCellActionTypeOutLink) { // 外链
            WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
            WebDirectLocalModel *modelLocal = [WebDirectLocalModel new];
            modelLocal.title = msg.title;
            modelLocal.url = msg.href;
//            modelLocal.typeLocalWeb = WebLocalTypeExpertRegisterProtocol;
            [vcWebDirect setWVWithLocalModel:modelLocal];
            vcWebDirect.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vcWebDirect animated:YES];
        } else if (msg.objType.intValue == MsgBoxCellActionTypeCreditMsg) { //积分消息
            WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
            vcWebDirect.hidesBottomBarWhenPushed = YES;
            WebDirectLocalModel* webModel = [WebDirectLocalModel new];
            webModel.title = @"积分明细";
            webModel.url = [NSString stringWithFormat:@"%@QWSH/web/integralDetail/html/integralDetail.html", H5_BASE_URL];
            [vcWebDirect setWVWithLocalModel:webModel];
            [self.navigationController pushViewController:vcWebDirect animated:YES];
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


