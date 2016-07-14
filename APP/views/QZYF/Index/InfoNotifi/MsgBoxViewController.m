//
//  MsgBoxViewController.m
//  wenYao-store
//
//  Created by  ChenTaiyu on 16/5/11.
//  Copyright © 2016年 carret. All rights reserved.
//
/*
 消息（图A）
	
 1.  店长可以看到全维药事，店员没有权限
 2.  将消息分类，订单通知归为一类，积分消息归为一类，其它通知都放在消息中心里；未开通微商门店没有“订单通知”类别
 3.  新增店员可查看除全维药事以外的消息权限
 4.  消息发送增加运营后台推送的功能，支持文本和链接，存储在消息中心 // ?
 5.  推送消息声音更换，换成自定义消息
 6.  当分类里有新的未读消息时使用小红点标识，需要将里面的消息全部读完才隐藏小红点
 7.  当有用户投诉此门店并处理结束工单时，需将客服回复内容推送到对应门店的店长账号的全维药事中
 消息中心（图B、C）
 
 1.  在订单通知以及消息中心两个类型页面增加“全部已读”功能，点击三个点弹出“全部已读”，再点击全部已读后小红点全部消失
 2.  消息中心后台做点击统计
 3.  若消息是文本类型的，最多取文本内前两行文字，后面用…表示，点击后进入到图C消息详情页面，展示标题、发布时间和正文
 积分消息（图D）
 
 1.  全维药事和积分消息两类不显示小红点，只要进入到此页面	就代表所有的消息都被已读
 2.  会触发积分消息类型有：
 1）订单处理，包括线上接单处理，分享转化的订单和线下引导的订单，且当这些订单状态变为“已完成”状态时，会收到消息通知（只针对开通微商的门店）：恭喜您，成功处理完成一笔订单（订单编号）
 2）积分商城中兑换商品后，以及商务人员在积分商城后台处理一条兑换订单后会收到消息通知（不区分是否开通微商）：
 3）后台系统手动进行增减积分时会收到消息通知，手动触发，在后台输入消息文案
 */
#import "MsgBoxViewController.h"
#import "MsgBoxTableViewCell.h"
#import "MsgBoxCellModel.h"
#import "QWMessage.h"
#import "Order.h"
#import "OrderMsgViewController.h"
#import "QWYSViewController.h"
#import "NotifyMsgViewController.h"
#import "CreditMsgViewController.h"
#import "MsgBox.h"

@interface MsgBoxViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray <MsgBoxCellModel *> *modelArr;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MsgBoxViewController

//AUTHORITY_ROOT 主账号
//OrganAuthPass 审核通过
#define MSTORE_OPEN  (QWGLOBALMANAGER.configure.storeType == 3)
#define NETWORK_UNAVAILABLE_MSG @"网络未连接，请稍后再试"
#define NETWORK_ERR_MSG @"网络故障，请稍后再试"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息";
    __weak typeof (self) weakSelf = self;
    [self enableSimpleRefresh:self.tableView block:^(SRRefreshView *sender) {
        if(QWGLOBALMANAGER.currentNetWork == NotReachable)
        {
            [SVProgressHUD showErrorWithStatus:NETWORK_UNAVAILABLE_MSG duration:0.8f];
            return;
        } else {
            [weakSelf refreshMsg];
        }
    }];
    self.tableView.rowHeight = 78.0;
    [self getCachedMsg];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshMsg];
}

#pragma mark - data progress

// 无缓存无网络的初始状态
- (void)initModel
{
    if (self.modelArr) {
        [self.modelArr removeAllObjects];
    } else {
        self.modelArr = [NSMutableArray array];
    }
    __weak typeof(self) weakSelf = self;
    MsgBoxCellModel *model1 = [MsgBoxCellModel new];
    model1.icon = [UIImage imageNamed:@"new_ic_quanwei"];
    model1.title = @"全维药事";
    model1.type = MsgBoxMessageTypeQWYS;
    model1.redPointHidden = YES;
    
    [self updateLatestQWYSMsgCachedToModel:model1];
    
    model1.actionBlock = ^{
        QWYSViewController *destVC = [[UIStoryboard storyboardWithName:@"QWYSViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"QWYSViewController"];
        destVC.hidesBottomBarWhenPushed = YES;
        destVC.showType = MessageShowTypeAnswer;
//        [weakSelf setReadAllWithType:MsgBoxMessageTypeQWYS];
        [weakSelf.navigationController pushViewController:destVC animated:YES];
    };
    // 全维药事权限
    if (!OrganAuthPass) {
        [self.modelArr addObject:model1];
    } else {
        if(AUTHORITY_ROOT) [self.modelArr addObject:model1];
    }
}

- (void)updateLatestQWYSMsgCachedToModel:(MsgBoxCellModel *)model
{
    NSArray *array = [OfficialMessages getArrayFromDBWithWhere:nil orderBy:@"timestamp desc" offset:0 count:1];
    OfficialMessages *message = [array lastObject];
    if (message) {
        model.detail = message.body;
        model.hintText = [self timeMarkStringWithTimeStamp:message.timestamp];
        model.redPointHidden = ![QWGLOBALMANAGER getRedPointModel].hadMessage;
    }
}

- (void)getCachedMsg
{
    NSArray *cacheArr = [BranchNoticeVo getArrayFromDBWithWhere:nil];
    [self initModel];
    for (BranchNoticeVo *vo in cacheArr) {
        [self.modelArr addObject:[self msgBoxCellModelWithBranchModel:vo]];
    }
    [self.tableView reloadData];
}

- (void)refreshMsg
{
    BranchNoticeIndexModelR *modelR = [BranchNoticeIndexModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    [MsgBox getBranchIndexList:modelR success:^(BranchNoticeIndexVo *responseModel) {
        [self endHeaderRefreshIfNeeded];
        // reset
        [self initModel];
        for (BranchNoticeVo *vo in responseModel.notices) {
            [self.modelArr addObject:[self msgBoxCellModelWithBranchModel:vo]];
        }
        if (!self.modelArr.count) {
            [self showInfoView:@"您还没有消息" image:@"ic_img_fail"];
        } else {
            [self removeInfoView];
            [self.tableView reloadData];
            [self cacheMsg:responseModel.notices];
        }
    } failure:^(HttpException *e) {
        [SVProgressHUD showErrorWithStatus:NETWORK_ERR_MSG duration:0.8f];
         if (!self.modelArr.count) {
             [self showInfoView:@"您还没有消息" image:@"ic_img_fail"];
         } else {
             [self removeInfoView];
         }
        [self endHeaderRefreshIfNeeded];
    }];
    
    // TODO: 加时间间隔限制
    [QWGLOBALMANAGER pullOfficialMessage];
}

// 远端列表缓存
- (void)cacheMsg:(NSArray *)modelArr
{
//    NSMutableArray *result = [BranchNoticeVo searchWithWhere:[NSString stringWithFormat:@"%@ not in (%@)", [BranchNoticeVo getPrimaryKey],[[keyArr copy] componentsJoinedByString:@","]] orderBy:nil offset:0 count:0];
    [BranchNoticeVo syncDBWithObjArray:modelArr primaryKey:[BranchNoticeVo getPrimaryKey]];
    NSArray *allType = @[@(MsgBoxMessageTypeNotify), @(MsgBoxMessageTypeOrder), @(MsgBoxMessageTypeCredit)];
    
    if (!modelArr.count) {
        [MsgBoxNotiMessageVo deleteAllObjFromDB];
        [MsgBoxOrderMessageVo deleteAllObjFromDB];
        [MsgBoxCreditMessageVo deleteAllObjFromDB];
    } else {
        for (BranchNoticeVo *vo in modelArr) {
            MsgBoxMessageType type = vo.type.integerValue;
            if (![allType containsObject:@(type)]) {
                if (MsgBoxMessageTypeNotify == type) {
                    [MsgBoxNotiMessageVo deleteAllObjFromDB];
                } else if (MsgBoxMessageTypeOrder == type) {
                    [MsgBoxOrderMessageVo deleteAllObjFromDB];
                }else if (MsgBoxMessageTypeCredit == type) {
                    [MsgBoxCreditMessageVo deleteAllObjFromDB];
                }
            }
        }
    }
    [QWGLOBALMANAGER postNotif:NotiMsgBoxRedPointNeedUpdate data:nil object:self];
}


- (void)setReadAllWithType:(MsgBoxMessageType)type
{
    MessageListReadAllModelR *modelR = [MessageListReadAllModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.type = @(type).stringValue;
    [MsgBox setReadAll:modelR success:^(BaseAPIModel *responseModel) {
        [self refreshMsg];
    } failure:^(HttpException *e) {
    }];
}

- (void)viewInfoClickAction:(id)sender
{
    [self refreshMsg];
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.modelArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MsgBoxTableViewCell *cell;
    if (indexPath.section < self.modelArr.count) {
        cell = [MsgBoxTableViewCell cellWithTableView:tableView];
        [cell setCell:self.modelArr[indexPath.section]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 7.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    void (^actionBlock)() = self.modelArr[indexPath.section].actionBlock;
    if (actionBlock) actionBlock();
    
    /*
    MsgBoxCellModel *model = self.modelArr[indexPath.section];
    if (model.type == MsgBoxMessageTypeQWYS || model.type == MsgBoxMessageTypeCredit) {
        [self setReadAllWithType:model.type];
    }
     */
}

#pragma mark - assist

- (NSString *)timeMarkStringWithTimeStamp:(NSString *)timeStamp
{
    NSString *timeStampStd = [timeStamp substringToIndex:10];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStampStd.doubleValue];
    return [QWGLOBALMANAGER timeStrSinceNowWithPastDate:date formatWithD:@"HH:mm" andM:@"MM-dd" andY:@"yyyy-MM"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
//    if (type == NotifiOrganAuthPass) {
//        
//    } else if (type == NotifiOrganAuthFailure) {
//    
//    }

    if (!OrganAuthPass || (OrganAuthPass && AUTHORITY_ROOT)) {
        if (type == NotifiIndexRedDotOrNumber)
        {
            if (data[@"hadMessage"]) {
               BOOL hasQWYSMsg = [data[@"hadMessage"] boolValue];
                if (hasQWYSMsg) {
                    [self updateLatestQWYSMsgCachedToModel:self.modelArr.firstObject];
                    [self.tableView reloadData];
                }
            }
        }
    }

    if (OrganAuthPass) {
        if (type == NotiMsgBoxNeedUpdate) {
            [self refreshMsg];
        }
    }
}

- (BOOL)isInInteraction
{
    return self.tableView.isTracking || self.tableView.isDragging || self.tableView.isDecelerating || self.isEditing;
}

- (void)endHeaderRefreshIfNeeded
{
    if (!self.tableView.isDragging) {
        [self endHeaderRefresh];
    }
}

- (MsgBoxCellModel *)msgBoxCellModelWithBranchModel:(BranchNoticeVo *)branchModel
{
    if (!branchModel) {
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MsgBoxMessageType type = branchModel.type.integerValue;
    if (type < MsgBoxMessageTypeNotify || type > MsgBoxMessageTypeCredit) {
        return nil;
    }
    MsgBoxCellModel *model = [MsgBoxCellModel new];
    model.title = branchModel.title;
    model.detail = branchModel.content;
    model.hintText = branchModel.formatShowTime;
    model.type = type;
    model.redPointHidden = !branchModel.unread.boolValue;
    
    switch (type) {
        case MsgBoxMessageTypeNotify:
        {
            model.icon = [UIImage imageNamed:@"new_ic_msg"];
            model.actionBlock = ^{
                [QWGLOBALMANAGER statisticsEventId:@"s_xx_tz" withLable:self.title withParams:nil];
                NotifyMsgViewController *destVC = [NotifyMsgViewController new];
                destVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:destVC animated:YES];
            };
        }
            break;
        case MsgBoxMessageTypeOrder:
        {
            model.icon = [UIImage imageNamed:@"new_ic_order"];
            model.actionBlock = ^{
                [QWGLOBALMANAGER statisticsEventId:@"s_xx_dd" withLable:self.title withParams:nil];
                OrderMsgViewController *destVC = [[UIStoryboard storyboardWithName:@"OrderMsgVC" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderMsgViewController"];
                destVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:destVC animated:YES];
            };
        }
            break;
        case MsgBoxMessageTypeCredit:
        {
            model.icon = [UIImage imageNamed:@"new_ic_integral"];
            model.actionBlock = ^{
                CreditMsgViewController *destVC = [CreditMsgViewController new];
                destVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:destVC animated:YES];
            };
        }
            break;
    }
    return model;
}

@end
