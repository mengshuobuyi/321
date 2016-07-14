
//
//  HomePageViewController.m
//  wenYao-store
//
//  Created by garfield on 15/5/4.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "HomePageViewController.h"
#import "SVProgressHUD.h"
#import "CloseMedicineTableViewCell.h"
#import "AskingMedicineTableViewCell.h"
#import "AnswerTableViewCell.h"
#import "HomePageTableViewCell.h"

#import "Consult.h"
#import "ConsultPTP.h"
#import "MKNumberBadgeView.h"
#import "MGSwipeButton.h"
#import "QWMessage.h"
#import "SearchSliderViewController.h"
#import "HealthQASearchViewController.h"
#import "RedPointModel.h"
#import "ChatViewController.h"
#import "XPChatViewController.h"
#import "XPMessageCenter.h"
#import "QWYSViewController.h"

@interface HomePageViewController ()<MGSwipeTableCellDelegate,UITableViewDelegate,UITableViewDataSource>
{
     NSUInteger                      currentPage;
    NSMutableDictionary *arrRoomsMine,*arrRoomsOthers;
}
@property (nonatomic, strong) NSMutableArray        *myConsultingConsultList;//本店解答中问题

@property (nonatomic, strong) MKNumberBadgeView     *badgeView;

@end

@implementation HomePageViewController
@synthesize tableView=_tableView;
//@synthesize segmentedControl;

#pragma mark - init
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"本店咨询";
    
    [self refreshNewQuestion];
    
    arrRoomsMine=[[NSMutableDictionary alloc]init];
    arrRoomsOthers=[[NSMutableDictionary alloc]init];

    [self setupHeaderRefresh];
    [self.view setBackgroundColor:RGBHex(qwColor11)];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [arrRoomsOthers removeAllObjects];
    [arrRoomsMine removeAllObjects];
    
}
#pragma mark -
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    QWGLOBALMANAGER.vcConsult=self;
    _roomID=nil;

    [QWGLOBALMANAGER refreshAllHint];
    [_tableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    QWGLOBALMANAGER.vcConsult=nil;
}

#pragma mark - 上下刷新
- (void)setupHeaderRefresh
{
    __weak typeof (self) weakSelf = self;
    
    [self enableSimpleRefresh:self.tableView block:^(SRRefreshView *sender) {
        if(QWGLOBALMANAGER.currentNetWork == NotReachable)
        {
            [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:0.8f];
            return;
        }
        currentPage = 0;
        [weakSelf refreshNewQuestion];
    }];
}

- (void)setupFooterRefresh
{
    __weak typeof (self) weakSelf = self;
    [self.tableView addFooterWithCallback:^{
        [weakSelf.tableView footerEndRefreshing];
        if(QWGLOBALMANAGER.currentNetWork == NotReachable)
        {
            [SVProgressHUD showErrorWithStatus:@"网络异常，请稍后重试" duration:0.8f];
            return;
        }
        
        NSString *timeStamp = @"0";
   
        weakSelf.tableView.footerNoDataText = kWaring55;
        weakSelf.tableView.footer.canLoadMore = NO;
    
        [QWGLOBALMANAGER getClosedConsultList:timeStamp];
    }];
    self.tableView.footerPullToRefreshText = @"下拉刷新了";
    self.tableView.footerReleaseToRefreshText = @"松开刷新了";
    self.tableView.footerRefreshingText = @"正在刷新中";
}

#pragma mark - 下拉刷新
- (void)refreshNewQuestion
{
    [QWGLOBALMANAGER getAllConsult];
}

- (NSArray *)createRightButtons:(int)number stick:(BOOL)stick
{
    NSMutableArray * result = [NSMutableArray array];
    if(number == 1) {
        NSString* titles[1] = {@"清除记录"};
        UIColor * colors[1] = {[UIColor redColor]};
        for (int i = 0; i < number; ++i)
        {
            MGSwipeButton * button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
                return YES;
            }];
            [result addObject:button];
        }
    }else{
        NSArray *titles = nil;
        if(stick) {
            titles = @[@"删除", @"取消置顶"];
        }else{
            titles = @[@"删除", @"置顶"];
        }
        UIColor * colors[2] = {[UIColor redColor], [UIColor lightGrayColor]};
        for (int i = 0; i < number; ++i)
        {
            MGSwipeButton * button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
                return YES;
            }];

            [result addObject:button];
        }
    }
    return result;
}

#pragma mark -
#pragma mark MGSwipeTableCellDelegate
-(NSArray*) swipeTableCell:(MGSwipeTableCell*)cell
  swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*)swipeSettings
         expansionSettings:(MGSwipeExpansionSettings*)expansionSettings;
{
    if(direction == MGSwipeDirectionRightToLeft) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        if(indexPath.row == 0 ) {
            PharSessionVo *ptpModel = self.myConsultingConsultList[indexPath.row];
            if([ptpModel.sessionTop isEqualToString:@"Y"])
                return [self createRightButtons:2 stick:YES];
        }
        
        return [self createRightButtons:2 stick:NO];
        
    }
    else
        return nil;
}

-(BOOL) swipeTableCell:(MGSwipeTableCell*)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    PharSessionVo *ptpModel = self.myConsultingConsultList[indexPath.row];
    if(index == 0) {
        //删除该记录
        
        PTPRemoveByPharModelR *modelR = [PTPRemoveByPharModelR new];
        modelR.sessionId = ptpModel.sessionId;
        modelR.token = QWGLOBALMANAGER.configure.userToken;
        [ConsultPTP ptpRemoveByPharWithParams:modelR success:^(BaseAPIModel *model) {
            if ([model.apiStatus integerValue] == 0) {
                [self.myConsultingConsultList removeObjectAtIndex:indexPath.row];
                [self deleteLocalDB:ptpModel];
                [self.tableView reloadData];
                
                [QWGLOBALMANAGER getAllMyConsultingConsultList];
            }else{
                [SVProgressHUD showErrorWithStatus:model.apiMessage duration:0.8];
            }
        } failure:^(HttpException *e) {
            [SVProgressHUD showErrorWithStatus:kWaring33 duration	:0.8f];
        }];
    }
    else if(index == 1){
        //置顶
        
        PTPTopByPharModelR *topModelR = [PTPTopByPharModelR new];

        topModelR.sessionId = ptpModel.sessionId;
        
        BOOL toTop=NO;
        if([ptpModel.sessionTop isEqualToString:@"Y"]) {
            topModelR.sessionId = ptpModel.sessionId;
            topModelR.option=@"2";
        }else{
            topModelR.sessionId = ptpModel.sessionId;
            topModelR.option=@"1";
            toTop=YES;
        }

        [ConsultPTP ptpTopByPharWithParams:topModelR success:^(BaseAPIModel *model) {
            if ([model.apiStatus integerValue] == 0) {
                if (toTop) {
                    [self PTPResetTop:ptpModel];
                    [self PTPCheckTop];
                }
                else {
                    [self PTPResetTop:nil];
                    NSArray *tmp=[self sortArray:self.myConsultingConsultList key:@"sessionLatestTime"];
                    if(tmp.count == 0) {
                        [self.myConsultingConsultList removeAllObjects];
                    }else{
                        self.myConsultingConsultList = [NSMutableArray arrayWithArray:tmp];
                    }
                }
                
                [self.tableView reloadData];
            }else{
                [SVProgressHUD showErrorWithStatus:model.apiMessage duration:0.8];
            }
        } failure:^(HttpException *e) {
            [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8f];
        }];
    }
    return YES;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)atableView numberOfRowsInSection:(NSInteger)section
{
    return self.myConsultingConsultList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *MessageShowTypeCloseCellIdentfier = @"AnswerTableViewCell";
    cell = [atableView dequeueReusableCellWithIdentifier:MessageShowTypeCloseCellIdentfier];
    if(cell == nil) {
        UINib *nib = [UINib nibWithNibName:@"AnswerTableViewCell" bundle:nil];
        [atableView registerNib:nib forCellReuseIdentifier:MessageShowTypeCloseCellIdentfier];
        cell = [atableView dequeueReusableCellWithIdentifier:MessageShowTypeCloseCellIdentfier];
        
    }
    AnswerTableViewCell *aCell = (AnswerTableViewCell *)cell;
    aCell.swipeDelegate = self;
    
    PharSessionVo *ptpModel = self.myConsultingConsultList[indexPath.row];
    
    QWMessage *qwmsg=[PTPMessageCenter checkMessageStateByID:ptpModel.sessionId];
    [aCell setCell:ptpModel msg:qwmsg];
    return cell;
}

- (void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(atableView)
        [atableView deselectRowAtIndexPath:indexPath animated:YES];
    PharSessionVo *ptpModel = nil;
    ptpModel = self.myConsultingConsultList[indexPath.row];
    _roomID=StrFromObj(ptpModel.sessionId);
    
    ChatViewController *vcPTP = nil;
    vcPTP= [[UIStoryboard storyboardWithName:@"ChatViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ChatViewController"];;
    
    vcPTP.hidesBottomBarWhenPushed = YES;
    vcPTP.branchId=ptpModel.customerPassport;
    vcPTP.sessionID=ptpModel.sessionId;
    vcPTP.chatType=IMTypePTPStore;
    vcPTP.customerSessionVo = ptpModel;
    //        vcPTP.pharSessionVo=ptpModel;
    [self.navigationController pushViewController:vcPTP animated:YES];
    
    //设置未读数
    ptpModel.unreadCounts = @"0";
    [PharSessionVo updateObjToDB:ptpModel WithKey:[NSString stringWithFormat:@"%@",ptpModel.sessionId]];
    
    //报告未读数
    [QWGLOBALMANAGER updateUnreadCount];
}

#pragma mark 删除PTP
-(void)deleteLocalDB:(PharSessionVo *)mode
{
    [PTPMessageCenter deleteMessagesByID:mode.sessionId];
}

#pragma mark -
#pragma mark 接收通知
- (void)getNotifType:(Enum_Notification_Type)type data:(id)data target:(id)obj
{
    NSArray *array = (NSArray *)data;
   if (type == NotifAppDidEnterBackground){
        //进后台
        [arrRoomsMine removeAllObjects];
        [arrRoomsOthers removeAllObjects];
    }
    if (type == NotiRefreshMyConsultingConsult){
        NSArray *tmp=[self sortArray:array key:@"sessionLatestTime"];
        if(tmp.count == 0) {
            [self.myConsultingConsultList removeAllObjects];
        }else{
            self.myConsultingConsultList = [NSMutableArray arrayWithArray:tmp];
        }
        [self PTPCheckTop];
        //需要刷新当前的本店问题列表
        [self.tableView reloadData];
    }
    else if (type == NotiRefreshAllConsult) {
        [self refreshNewQuestion];
    }else if (type == NotimessageBoxUpdate) {
        [self.tableView reloadData];
    }
}
#pragma mark - PTP置顶
- (void)PTPCheckTop{
    int i  =0 ;
    PharSessionVo *ptpModel=nil;
    for (PharSessionVo *mm  in self.myConsultingConsultList) {
        if (mm.sessionTop && [mm.sessionTop isEqualToString:@"Y"]) {
 
            ptpModel=mm;
            break;
        }
        i++;
    }
    
    if (ptpModel && i != 0) {
        [self.myConsultingConsultList removeObject:ptpModel];
        [self.myConsultingConsultList insertObject:ptpModel atIndex:0];
    }
}

- (void)PTPResetTop:(PharSessionVo*)mode{
    for (PharSessionVo *mm  in self.myConsultingConsultList) {
        if (mm.sessionTop && [mm.sessionTop isEqualToString:@"Y"]) {
            mm.sessionTop=@"N";
    
            NSString *key=StrFromObj(mm.sessionId);
            [PharSessionVo updateObjToDB:mm WithKey:key];
            break;
        }
    }
    
    if (mode) {
        mode.sessionTop=@"Y";
        NSString *key=StrFromObj(mode.sessionId);
        [PharSessionVo updateObjToDB:mode WithKey:key];
    }
    
}
#pragma mark - 排序
-(NSArray *)sortArray:(NSArray*)arr key:(NSString*)key
{
    NSSortDescriptor*sorter=[[NSSortDescriptor alloc]initWithKey:key ascending:YES];
    NSMutableArray *sortDescriptors=[[NSMutableArray alloc]initWithObjects:&sorter count:1];
    NSArray *sortArray=[arr sortedArrayUsingDescriptors:sortDescriptors];
    NSArray *arr2=[[sortArray reverseObjectEnumerator] allObjects];
    return arr2;
}

@end
