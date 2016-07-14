//
//  InfoNotifiViewController.m
//  wenYao-store
//
//  Created by Yang Yuexia on 16/1/4.
//  Copyright © 2016年 carret. All rights reserved.
//

#import "InfoNotifiViewController.h"
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

@interface InfoNotifiViewController ()<UITableViewDataSource,UITableViewDelegate,MGSwipeTableCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
//全维药事小红点
@property (weak, nonatomic) IBOutlet UIImageView *qwysRedDot;
//全维药事最后一条消息
@property (weak, nonatomic) IBOutlet UILabel *qwysLastContent;
@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation InfoNotifiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
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
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.tableHeaderView;
    [self.tableView reloadData];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToQWYS)];
    [self.tableHeaderView addGestureRecognizer:tap];
}

#pragma mark - cache methods
- (void)getCachedMessages
{
    self.dataList = [NSMutableArray arrayWithArray:[OrderNotiModel getArrayFromDBWithWhere:nil WithorderBy:@" createTime desc"]];
}

- (void)refreshConsultList
{
    //全量拉取消息盒子数据
    OrderNotiListModelR *modelR = [OrderNotiListModelR new];
    modelR.token = QWGLOBALMANAGER.configure.userToken;
    modelR.view = @"100";
    [Order getAllOrderNotiList:modelR success:^(OrderMessageArrayVo *responModel) {
        [self.tableView headerEndRefreshing];
        OrderMessageArrayVo *listModel = (OrderMessageArrayVo *)responModel;
//        [self removeInfoView];
        QWGLOBALMANAGER.lastTimestampForOrderNoti = responModel.lastTimestamp;
        if (listModel.messages.count > 0) {
            [QWGLOBALMANAGER syncOrderDBtoLast:listModel];
            [self.dataList removeAllObjects];
            [self getCachedMessages];
            
        } else {
        }
        [self.tableView reloadData];
        NSLog(@"the order list is %@",self.dataList);
    } failure:^(HttpException *e) {
        [self.tableView headerEndRefreshing];
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //全维药事小红点
    self.qwysRedDot.hidden = self.isAppearQWYSRedDot;
    
    //全维药事最后一条消息
    NSArray *array =  [OfficialMessages getArrayFromDBWithWhere:nil WithorderBy:@"timestamp asc"];
    if (array && array.count>0) {
        OfficialMessages *message = [array lastObject];
        self.qwysLastContent.text = message.body;
        if ([message.issend isEqualToString:@"2"]) {
            self.qwysRedDot.hidden = YES;
        } else {
            self.qwysRedDot.hidden = NO;
        }
        
    }else{
        self.qwysLastContent.text = @"";
        self.qwysRedDot.hidden = YES;
    }
    [self refreshConsultList];
}

- (void)jumpToQWYS
{
    //全维药事
    QWYSViewController *demoViewController = [[UIStoryboard storyboardWithName:@"QWYSViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"QWYSViewController"];
    demoViewController.hidesBottomBarWhenPushed = YES;
    demoViewController.showType = MessageShowTypeAnswer;
    self.qwysRedDot.hidden = YES; //隐藏小红点
    [self.navigationController pushViewController:demoViewController animated:YES];
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
    OrderNotiModel *model = [self.dataList objectAtIndex:indexPath.row];
    [sizingCell setCell:model];
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(sizingCell.bounds));
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize sizeFinal = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return sizeFinal.height+1.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MsgNotifyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MsgNotifyOrderCell"];
    OrderNotiModel *msgModel = self.dataList[indexPath.row];
    [cell setCell:msgModel];
    cell.swipeDelegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderNotiModel* msg = self.dataList[indexPath.row];
    if(msg) {
        // 更新红点逻辑
        msg.showRedPoint = @"0";
        msg.unreadCounts = @"0";
        [OrderNotiModel updateObjToDB:msg WithKey:msg.messageId];
        if (msg.messageId.length > 0) {
            //TODO: need check comment by perry
            [Order setOrderNotiReadWithMessageId:msg.messageId];
        }
        [QWGLOBALMANAGER postNotif:NotifiIndexRedDotOrNumber data:nil object:self];
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
            vcIndent.orderId = msg.orderId;
            [self.navigationController pushViewController:vcIndent animated:YES];
        }
    }
}

#pragma mark -
#pragma mark MGSwipeTableCellDelegate
-(NSArray *) createRightButtons: (int) number
{
    NSMutableArray * result = [NSMutableArray array];
    NSString* titles[2] = {@"删除"};
    UIColor * colors[2] = {[UIColor redColor]};
    for (int i = 0; i < number; ++i)
    {
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
            return YES;
        }];
        if(i == 1) {
            [button setTitleColor:RGBHex(qwColor5) forState:UIControlStateNormal];
        }
        [result addObject:button];
    }
    return result;
}

-(NSArray*) swipeTableCell:(MGSwipeTableCell*)cell
  swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*)swipeSettings
         expansionSettings:(MGSwipeExpansionSettings*)expansionSettings;
{
    
    if (direction == MGSwipeDirectionRightToLeft)
    {
        
        return [self createRightButtons:1];
        
    }
    return nil;
}

-(BOOL) swipeTableCell:(MGSwipeTableCell*)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    NSIndexPath *  indexPath = [self.tableView indexPathForCell:cell];
    //删除事件
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        
        [SVProgressHUD showErrorWithStatus:@"网络未连接，请重试" duration:0.8f];
        
        return NO;
    }
    
    OrderNotiModel* boxModel = self.dataList[indexPath.row];
    
    RemoveByCustomerOrderR *model = [RemoveByCustomerOrderR new];
    model.messageId = boxModel.messageId;
    [Order removeByCustomer:model success:^(id responModel) {
        [self.dataList removeObject:boxModel];
        [OrderNotiModel deleteObjFromDBWithKey:boxModel.messageId];
        [self.tableView reloadData];
        if (self.dataList.count == 0) {
//            [self showInfoView:@"暂无订单通知~" image:@"ic_img_fail"];
        }
    } failure:^(HttpException *e) {
        
    }];
    return YES;
}


#pragma mark ---- 接收通知 ----

- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    if (NotifiIndexRedDotOrNumber == type)
    {
        // 首页咨询小红点
        NSDictionary *dd=data;
        
        if (dd[@"hadMessage"]) {
            //判断是非有药师消息
            if ([dd[@"hadMessage"] integerValue]) {
                self.qwysRedDot.hidden = NO;   // 显示
            }
            else self.qwysRedDot.hidden = YES;  // 隐藏全维消息红点
        }
        self.tableView.tableHeaderView = self.tableHeaderView;
        [self getCachedMessages];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
