//
//  IndentDetailViewController.m
//  APP
//  订单列表页面
//  订单列表接口：QueryOrdersList
//  拒绝理由接口：QueryRefuseReasonInfo
//  操作订单接口：OperateOrders
//  物流信息接口：QueryPostList
//  Created by qw_imac on 15/12/29.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "IndentDetailViewController.h"
#import "IndentCell.h"
#import "CancelAlertView.h"
#import "InputScanView.h"
#import "RefusePayReasonView.h"
#import "IndentDetailListViewController.h"
#import "IndentOders.h"
#import "AllScanReaderViewController.h"
#import "CheckPostViewController.h"
#import "InputOrderPostNumberViewController.h"
#import "AcceptSuccessAlertView.h"
#import "MyLevelInfoViewController.h"
@interface IndentDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    NSMutableArray      *PostArray;
    NSMutableArray      *RefusePayArray;
    NSMutableArray      *shopRefuseArray;       //商家取消订单理由
    float               height;                 //数字键盘高度记录
    NSTimeInterval      duration;               //键盘出现时间记录
    NSInteger           currentPage;
    NSString            *refuseReason;          //拒单理由
    NSString            *shopRefuseReason;      //商家取消订单理由
    ExpressCompanyVO    *postCompany;           //物流公司
    NSInteger           PickIndex;              //记录操作的index
    NSArray             *btnsArray;
    
    //适配6p的常量值
    CGFloat kHeaderViewHeight;
    CGFloat kBtnWidth;
    CGFloat kBtnHeight;
    CGFloat kBtnMartain;
    CGFloat kBtnRadus;
    CGFloat kBtnFontSize;
}
@property (nonatomic,strong)UITableView         *tableView;
@property (nonatomic,strong)InputScanView       *inputScanView;
@property (nonatomic,strong)NSMutableArray      *dataSource;
@property (nonatomic,strong)RefusePayReasonView *refuseView;
@property (nonatomic,strong)CancelAlertView     *fillPostView;
@property (nonatomic,assign)NSInteger           postStatus;//上传小票状态
@property (nonatomic,strong)UIView              *bgView;
@property (nonatomic,strong)UITextField         *groupNameTextField;
@end

@implementation IndentDetailViewController
static NSString *WriteReason = @"手动填写原因";
static NSString *identifier = @"IndentCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    PostArray = [NSMutableArray array];
    RefusePayArray = [NSMutableArray array];
    refuseReason = [[NSString alloc]init];
    PickIndex = -1;
    _postStatus = _tipsStatus;
    [self queryPostData];
    [self queryRefuseReason];
    [self queryShopRefuseReason];
    [self setupUI];
}

-(void)setPostStatus:(NSInteger)postStatus {
    _postStatus = postStatus;
    NSString *eventId;
    switch (postStatus) {
        case 0:
            eventId = @"s_dd_qb";
            break;
        case 1:
            eventId = @"s_dd_ycxp";
            break;
        case 2:
            eventId = @"s_dd_wcxp";
            break;
    }
    [QWGLOBALMANAGER statisticsEventId:eventId withLable:@"订单" withParams:nil];
    [self queryData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    currentPage =1;
    [self queryData];
}

-(void)setupUI {
    [self setNoneDateBG:@"img_order" With:@"您还没有订单哦~"];
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0 , APP_W, [[UIScreen mainScreen] bounds].size.height - 64 - 36 - 50) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    if([_status integerValue] == 0){
        [self setChooseHeaderView];
    }
    [self.tableView addFooterWithTarget:self action:@selector(actionLoadMore)];
    [self enableSimpleRefresh:self.tableView block:^(SRRefreshView *sender) {
        [self refresh];
    }];
    [self.view addSubview:self.tableView];
}
//全部tab下筛选是否上传小票view
-(void)setChooseHeaderView {
    [self setConstantValue];
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, kHeaderViewHeight)];
    CGFloat btnY = (kHeaderViewHeight - kBtnHeight)/2;
    UIButton *all = [[UIButton alloc]initWithFrame:CGRectMake(kBtnMartain,btnY , kBtnWidth , kBtnHeight)];
    [all setTitle:@"全部" forState:UIControlStateNormal];
    [all setTitleColor:RGBHex(qwColor4) forState:UIControlStateNormal];
    all.titleLabel.font = fontSystem(kBtnFontSize);
    all.backgroundColor = RGBHex(qwColor1);
    all.layer.cornerRadius = kBtnRadus;
    all.layer.masksToBounds = YES;
    all.tag = 1;
    UIButton *havePost = [[UIButton alloc]initWithFrame:CGRectMake(kBtnWidth + 2*kBtnMartain, btnY, kBtnWidth, kBtnHeight)];
    [havePost setTitle:@"已传小票" forState:UIControlStateNormal];
    [havePost setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
    havePost.titleLabel.font = fontSystem(kBtnFontSize);
    havePost.backgroundColor = RGBHex(qwColor4);
    havePost.layer.cornerRadius = kBtnRadus;
    havePost.layer.borderWidth = 0.5;
    havePost.layer.borderColor = RGBHex(qwColor10).CGColor;
    havePost.layer.masksToBounds = YES;
    havePost.tag = 2;
    UIButton *notPost = [[UIButton alloc]initWithFrame:CGRectMake(2*kBtnWidth + 3*kBtnMartain, btnY, kBtnWidth, kBtnHeight)];
    [notPost setTitle:@"未传小票" forState:UIControlStateNormal];
    [notPost setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
    notPost.titleLabel.font = fontSystem(kBtnFontSize);
    notPost.backgroundColor = RGBHex(qwColor4);
    notPost.layer.cornerRadius = kBtnRadus;
    notPost.layer.borderWidth = 0.5;
    notPost.layer.borderColor = RGBHex(qwColor10).CGColor;
    notPost.layer.masksToBounds = YES;
    notPost.tag = 3;
    UIButton *myDeal = [[UIButton alloc]initWithFrame:CGRectMake(3*kBtnWidth + 4*kBtnMartain, btnY, kBtnWidth, kBtnHeight)];
    [myDeal setTitle:@"我处理的" forState:UIControlStateNormal];
    [myDeal setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
    myDeal.titleLabel.font = fontSystem(kBtnFontSize);
    myDeal.backgroundColor = RGBHex(qwColor4);
    myDeal.layer.cornerRadius = kBtnRadus;
    myDeal.layer.borderWidth = 0.5;
    myDeal.layer.borderColor = RGBHex(qwColor10).CGColor;
    myDeal.layer.masksToBounds = YES;
    myDeal.tag = 4;
    [all addTarget:self action:@selector(chooseTipsStatus:) forControlEvents:UIControlEventTouchUpInside];
    [havePost addTarget:self action:@selector(chooseTipsStatus:) forControlEvents:UIControlEventTouchUpInside];
    [notPost addTarget:self action:@selector(chooseTipsStatus:) forControlEvents:UIControlEventTouchUpInside];
    [myDeal addTarget:self action:@selector(chooseTipsStatus:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:all];
    [header addSubview:havePost];
    [header addSubview:notPost];
    [header addSubview:myDeal];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, kHeaderViewHeight - 0.5, APP_W, 0.5)];
    line.backgroundColor = RGBHex(qwColor10);
    [header addSubview:line];
    btnsArray = @[all,havePost,notPost,myDeal];
    self.tableView.tableHeaderView = header;
}
//todo 6pfix
-(void)setConstantValue {
    kHeaderViewHeight = 43;
    kBtnWidth = 70;
    kBtnHeight = 28;
    kBtnMartain = 8;
    kBtnRadus = 3.0;
    kBtnFontSize = kFontS5;
}
//选择上传小票状态
-(void)chooseTipsStatus:(UIButton *)sender {
    DebugLog(@"status is %ld",sender.tag);
    self.postStatus = sender.tag - 1;
    sender.layer.borderWidth = 0.0;
    [sender setBackgroundColor:RGBHex(qwColor1)];
    [sender setTitleColor:RGBHex(qwColor4) forState:UIControlStateNormal];
    for (UIButton *btn in btnsArray) {
        if (btn != sender) {
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = RGBHex(qwColor10).CGColor;
            [btn setBackgroundColor:RGBHex(qwColor4)];
            [btn setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
        }
    }
}

- (void)refresh {
    currentPage = 1;
    self.tableView.footer.canLoadMore = YES;
    [self queryData];
}

- (void)actionLoadMore {
    HttpClientMgr.progressEnabled = NO;
    currentPage++;
    [self queryData];
}

//接单
-(void)acceptOrder:(UIButton *)sender {
    OperateShopOrder *modelR = [OperateShopOrder new];
    if (QWGLOBALMANAGER.configure.userToken) {
        modelR.token = QWGLOBALMANAGER.configure.userToken;
    }
    NSInteger i = (sender.tag -2)/100;
    MicroMallShopOrderVO *vo = _dataSource[i];
    modelR.orderId = vo.orderId;
    modelR.operate = 1;
    [IndentOders operateShopOrder:modelR success:^(OperateShopOrderModel *model) {
        if ([model.apiStatus intValue] == 0) {
            //操作成功重刷一次数据
            BOOL show = [QWUserDefault getBoolBy:@"switchKeyPath"];
            if (!show) {
                AcceptSuccessAlertView *view = [[NSBundle mainBundle]loadNibNamed:@"AcceptSuccessAlertView" owner:nil options:nil][0];
                view.bkView.alpha = 0;
                view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                UIWindow *win = [[UIApplication sharedApplication] keyWindow];
                [win addSubview:view];
                [UIView animateWithDuration:0.25 animations:^{
                    view.bkView.alpha =0.4;
                    view.alertView.hidden = NO;
                }];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"接单成功，请继续关注" duration:0.8];
            }
            currentPage = 1;
            [self queryData];
        }else {
           // [SVProgressHUD showErrorWithStatus:model.apiMessage duration:.8];
        }
    } failure:^(HttpException *e) {
        
    }];
}
//去配送
-(void)gotoDeliver:(UIButton *)sender{
    OperateShopOrder *modelR = [OperateShopOrder new];
    if (QWGLOBALMANAGER.configure.userToken) {
        modelR.token = QWGLOBALMANAGER.configure.userToken;
    }
    NSInteger i = (sender.tag -2)/100;
    MicroMallShopOrderVO *vo = _dataSource[i];
    modelR.orderId = vo.orderId;
    modelR.operate = 4;
    [IndentOders operateShopOrder:modelR success:^(OperateShopOrderModel *model) {
        if ([model.apiStatus intValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"订单已在配送中，接下来确认收货" duration:0.8];
            //操作成功重刷一次数据
            currentPage = 1;
            [self queryData];
        }else {
            //[SVProgressHUD showErrorWithStatus:model.apiMessage duration:.8];
        }
    } failure:^(HttpException *e) {
        
    }];
}
//查看物流
-(void)checkMyPost:(UIButton *)sender {
    CheckPostViewController *vc = [CheckPostViewController new];
    NSInteger i = (sender.tag -1)/100;
    MicroMallShopOrderVO *vo = _dataSource[i];
    vc.postName = vo.expressCompany;
    vc.postNumber = vo.waybillNo;
    [self.navi pushViewController:vc animated:YES];
}
//打电话
-(void)phoneCallWithNumber:(UIButton *)sender {
    NSInteger index = (sender.tag -3)/100;
    MicroMallShopOrderVO *vo = _dataSource[index];
    PickIndex = index;
    if(StrIsEmpty(vo.receiverTel)){
        return;
    }
    UIActionSheet *telphone = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
    [telphone addButtonWithTitle:vo.receiverTel];
    [telphone showInView:self.view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self _phoneCall:PickIndex];
    }
}

-(void)_phoneCall:(NSUInteger)index {
    MicroMallShopOrderVO *vo = _dataSource[index];
    NSString *number = [NSString stringWithFormat:@"tel://%@",vo.receiverTel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
}
#pragma mark - tableviewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IndentCell *cell = (IndentCell *)[self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell =[[NSBundle mainBundle] loadNibNamed:@"IndentCell" owner:self options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.telBtn addTarget:self action:@selector(phoneCallWithNumber:) forControlEvents:UIControlEventTouchUpInside];
    MicroMallShopOrderVO *vo = _dataSource[indexPath.section];
    cell.checkPostBtn.tag = indexPath.section *100 +1;
    cell.consigneeBtn.tag = indexPath.section *100 +2;
    cell.telBtn.tag = indexPath.section *100 +3;
    cell.cancelBtn.tag = indexPath.section *100 +1;
    [cell setCellWith:vo];
    [cell.cancelBtn addTarget:self action:@selector(chooseShopRefusePayReason:) forControlEvents:UIControlEventTouchUpInside];
    //6 待取货 3 配送中
    if ([vo.orderStatus intValue] == 6 || [vo.orderStatus intValue] == 3) {
        [cell.consigneeBtn addTarget:self action:@selector(inputScanPassWord:) forControlEvents:UIControlEventTouchUpInside];
    }
    //1 待接单
    if ([vo.orderStatus intValue] == 1) {
        [cell.consigneeBtn addTarget:self action:@selector(acceptOrder:) forControlEvents:UIControlEventTouchUpInside];
    }
    //2 待配送
    if ([vo.orderStatus intValue] == 2) {
        if ([vo.deliver intValue] == 2) {
            [cell.consigneeBtn addTarget:self action:@selector(gotoDeliver:) forControlEvents:UIControlEventTouchUpInside];
        }else if ([vo.deliver intValue] == 3){
            [cell.consigneeBtn addTarget:self action:@selector(choosePost:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    //3 配送中 9 已完成
    if ([vo.orderStatus intValue] == 3||[vo.orderStatus intValue] == 9) {
        [cell.checkPostBtn addTarget:self action:@selector(checkMyPost:) forControlEvents:UIControlEventTouchUpInside];
    }
    //6 待取 待配增加取消订单
    if ([vo.orderStatus intValue] == 6 || [vo.orderStatus intValue] == 2) {
        [cell.checkPostBtn addTarget:self action:@selector(chooseShopRefusePayReason:) forControlEvents:UIControlEventTouchUpInside];
    }
    //1 待接单
    if ([vo.orderStatus intValue] == 1) {//拒单先选择拒单理由
        [cell.checkPostBtn addTarget:self action:@selector(chooseRefusePayReason:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MicroMallShopOrderVO *vo = _dataSource[indexPath.section];
    //已拒绝 已取消和待配送选择到店自取情况下隐藏操作栏 已完成的非同城快递也隐藏
    if ([vo.orderStatus intValue]== 5 || [vo.orderStatus intValue]== 8 || ([vo.orderStatus intValue]== 2 && [vo.deliver intValue]== 1) || ([vo.orderStatus intValue]== 9 && [vo.deliver intValue] != 3)) {
        return 200;
    }else {
        return [IndentCell setHeight];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else {
        return 7.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 7.0)];
    bgView.backgroundColor = [UIColor clearColor];
    
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 0.1)];
    bgView.backgroundColor = RGBHex(qwColor10);
    return bgView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MicroMallShopOrderVO *vo = _dataSource[indexPath.section];
    IndentDetailListViewController *vc = [IndentDetailListViewController new];
    vc.orderId = vo.orderId;
    __weak typeof(self) weakSelf = self;
    vc.refreshBlock = ^{
        currentPage = 1;
        [weakSelf queryData];
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navi pushViewController:vc animated:YES];
}
#pragma mark - 选择快递物流
-(void)choosePost:(UIButton *)sender {
    _fillPostView = [CancelAlertView cancelAlertView];
    _fillPostView.picker.dataSource = self;
    _fillPostView.picker.delegate = self;
    _fillPostView.picker.tag = 100;
    _fillPostView.bkView.alpha = 0.0;
    _fillPostView.scanBtn.tag = sender.tag;
    [_fillPostView.scanBtn addTarget:self action:@selector(scanOrderCode:) forControlEvents:UIControlEventTouchUpInside];
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    [win addSubview:_fillPostView];
    [UIView animateWithDuration:0.25 animations:^{
        _fillPostView.bkView.alpha =0.4;
        _fillPostView.picker.hidden = NO;
        _fillPostView.reasonView.hidden = NO;
        _fillPostView.confireView.hidden = NO;
    }];
}
//打开扫码，扫描订单号
-(void)scanOrderCode:(UIButton *)sender{
//    [_fillPostView removeSelf];
    _fillPostView.hidden = YES;
    InputOrderPostNumberViewController *vc = [[InputOrderPostNumberViewController alloc]initWithNibName:@"InputOrderPostNumberViewController" bundle:nil];
    vc.company = postCompany;
    MicroMallShopOrderVO *vo = _dataSource[(sender.tag - 2)/100];
    vc.orderId = vo.orderId;
    __weak typeof(self) weakSelf = self;
    //QCSlide返回时不走viewWillappear，用refresh强刷！
    vc.refresh = ^(BOOL success){
        if (success) {
            [_fillPostView removeFromSuperview];
            currentPage = 1;
            [weakSelf queryData];

        }else {
            _fillPostView.hidden = NO;
        }
    };
    [self.navi pushViewController:vc animated:YES];
}

#pragma mark - 选择拒单理由
-(void)chooseRefusePayReason:(UIButton *)sender {
    NSInteger i = (sender.tag -1)/100;
    MicroMallShopOrderVO *vo = _dataSource[i];
    _refuseView = [RefusePayReasonView refuseView];
    if (vo.payType.integerValue == 2) {
        _refuseView.title.text = [NSString stringWithFormat:@"选择原因\n(用户已付款，取消后会退款给用户)"];
    }else {
        _refuseView.title.text = [NSString stringWithFormat:@"选择原因"];
    }
    _refuseView.picker.dataSource = self;
    _refuseView.picker.delegate = self;
    _refuseView.picker.tag = 101;
    _refuseView.bkView.alpha = 0.0;
  
    _refuseView.confireBtn.tag = i + 100001;
    [_refuseView.confireBtn addTarget:self action:@selector(refuseOrder:) forControlEvents:UIControlEventTouchUpInside];
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    [win addSubview:_refuseView];
    [UIView animateWithDuration:0.25 animations:^{
        _refuseView.bkView.alpha =0.4;
        _refuseView.picker.hidden = NO;
        _refuseView.reasonView.hidden = NO;
    }];
}
//拒单
-(void)refuseOrder:(UIButton *)sender {
    NSInteger i = sender.tag - 100001;
    [_refuseView removeSelf];
    PickIndex = i;
    if([refuseReason isEqualToString:WriteReason]){
        [self showEditStackViewWithIndex:@(PickIndex + 2)];
        return;
    }
    MicroMallShopOrderVO *vo = _dataSource[i];
    OperateShopOrder *modelR = [OperateShopOrder new];
    if (QWGLOBALMANAGER.configure.userToken) {
        modelR.token = QWGLOBALMANAGER.configure.userToken;
    }
    modelR.orderId = vo.orderId;
    modelR.operate = 2;
    modelR.rejectReason = refuseReason;
    [IndentOders operateShopOrder:modelR success:^(OperateShopOrderModel *model) {
        if ([model.apiStatus intValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"订单取消成功，流程结束" duration:0.8];
            //操作成功重刷一次数据
            currentPage = 1;
            [self queryData];
        }else {
            
        }
    } failure:^(HttpException *e) {
        
    }];
}
//拒单，取消订单手动输入
- (void)showEditStackViewWithIndex:(NSNumber *)idx
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = idx.integerValue;
    
    UIView *bgView = [[UIView alloc] init];
    self.groupNameTextField = [[UITextField alloc] init];
    
    bgView.frame = CGRectMake(0, 0, 270, 84);
    self.groupNameTextField.frame = CGRectMake(15 , 20, 240, 44);
     [self.groupNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.groupNameTextField.placeholder = @"请输入原因(最多12个字)";
    self.groupNameTextField.font = fontSystem(14.0f);
    self.groupNameTextField.textColor = RGBHex(0x333333);
    self.groupNameTextField.layer.masksToBounds = YES;
    self.groupNameTextField.layer.borderWidth = 0.5;
    self.groupNameTextField.layer.borderColor = RGBHex(0xcccccc).CGColor;
    self.groupNameTextField.layer.cornerRadius = 5.0f;
    self.groupNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.groupNameTextField.delegate = self;
    self.groupNameTextField.keyboardType = UIKeyboardTypeDefault;
    self.groupNameTextField.backgroundColor = [UIColor whiteColor];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    self.groupNameTextField.leftView = paddingView;
    self.groupNameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.groupNameTextField.tag = idx.integerValue;
    [bgView addSubview:self.groupNameTextField];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        [alert setValue:bgView forKey:@"accessoryView"];
    }else{
        [alert addSubview:bgView];
    }
    [alert show];
}


#pragma mark ---- 监听文本变化 ----
- (void)textFieldDidChange:(UITextField *)textField
{
    UITextField *textView = textField;
    NSString *lang = [[textView textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            [self judgeTextFieldChange:textView];
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        [self judgeTextFieldChange:textView];
    }
}

- (void)judgeTextFieldChange:(UITextField *)textField
{
    UITextField *textView = textField;
    NSString *toBeString = textView.text;
    
    int maxNum;
    maxNum = 12;
    if (toBeString.length > maxNum) {
        textView.text = [toBeString substringToIndex:maxNum];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSInteger operationI = alertView.tag - PickIndex;
        if (StrIsEmpty(self.groupNameTextField.text)) {
            [SVProgressHUD showErrorWithStatus:@"请输入原因"];
            [self performSelector:@selector(showEditStackViewWithIndex:) withObject:@(alertView.tag) afterDelay:1];
            return;
        }
        if (operationI == 2) {
            refuseReason = self.groupNameTextField.text;
        }else if (operationI == 5 ){
            shopRefuseReason = self.groupNameTextField.text;
        }
        [self opeartWith:operationI];
    }
}
//手写理由回调方法
-(void)opeartWith:(NSInteger)index {
    MicroMallShopOrderVO *vo = _dataSource[PickIndex];
    OperateShopOrder *modelR = [OperateShopOrder new];
    if (QWGLOBALMANAGER.configure.userToken) {
        modelR.token = QWGLOBALMANAGER.configure.userToken;
    }
    modelR.orderId = vo.orderId;
    modelR.operate = index;
    if (index == 2) {
        modelR.rejectReason = refuseReason;
    }else if (index == 5 ){
        modelR.rejectReason = shopRefuseReason;
    }
    [IndentOders operateShopOrder:modelR success:^(OperateShopOrderModel *model) {
        if ([model.apiStatus intValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"订单取消成功，流程结束" duration:0.8];
            //操作成功重刷一次数据
            currentPage = 1;
            [self queryData];
        }else {
            
        }
    } failure:^(HttpException *e) {
        
    }];
}
#pragma mark - 选择取消订单理由
-(void)chooseShopRefusePayReason:(UIButton *)sender {
    NSInteger i = (sender.tag -1)/100;
    MicroMallShopOrderVO *vo = _dataSource[i];
  
    _refuseView = [RefusePayReasonView refuseView];
    if (vo.payType.integerValue == 2) {
        _refuseView.title.text = [NSString stringWithFormat:@"选择原因\n(用户已付款，取消后会退款给用户)"];
    }else {
        _refuseView.title.text = [NSString stringWithFormat:@"选择原因"];
    }
    _refuseView.picker.dataSource = self;
    _refuseView.picker.delegate = self;
    _refuseView.picker.tag = 102;
    _refuseView.bkView.alpha = 0.0;
    _refuseView.confireBtn.tag = i + 100001;

    [_refuseView.confireBtn addTarget:self action:@selector(ShoprefuseOrder:) forControlEvents:UIControlEventTouchUpInside];
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    [win addSubview:_refuseView];
    [UIView animateWithDuration:0.25 animations:^{
        _refuseView.bkView.alpha =0.4;
        _refuseView.picker.hidden = NO;
        _refuseView.reasonView.hidden = NO;
    }];
}
//取消订单操作
-(void)ShoprefuseOrder:(UIButton *)sender {
    NSInteger i = sender.tag - 100001;
    PickIndex = i;
    [_refuseView removeSelf];
    if([shopRefuseReason isEqualToString:WriteReason]){
        [self showEditStackViewWithIndex:@(PickIndex + 5)];
        return;
    }
    
    MicroMallShopOrderVO *vo = _dataSource[i];
    OperateShopOrder *modelR = [OperateShopOrder new];
    if (QWGLOBALMANAGER.configure.userToken) {
        modelR.token = QWGLOBALMANAGER.configure.userToken;
    }
    modelR.orderId = vo.orderId;
    modelR.operate = 5;
    modelR.rejectReason = shopRefuseReason;
    if (!modelR.rejectReason) {
        modelR.rejectReason = [shopRefuseArray firstObject];
    }
    [IndentOders operateShopOrder:modelR success:^(OperateShopOrderModel *model) {
        if ([model.apiStatus intValue] == 0) {
            //操作成功重刷一次数据
            [SVProgressHUD showSuccessWithStatus:@"订单取消成功，流程结束" duration:0.8];
            currentPage = 1;
            [self queryData];
        }else {
            
        }
    } failure:^(HttpException *e) {
        
    }];
}

#pragma mark --------------------
#pragma mark  确认订单
-(void)inputScanPassWord:(UIButton *)sender {
    if (self.inputScanView) {
        self.inputScanView = nil;
    }
    self.inputScanView = [InputScanView inputScanView];
    self.inputScanView.height.constant = 0.0;
    self.inputScanView.inputTF.delegate = self;
    NSInteger i = (sender.tag - 2)/100;
    self.inputScanView.inputTF.tag = i +10086;
    [self.inputScanView.inputTF addTarget:self action:@selector(txchange:) forControlEvents:UIControlEventEditingChanged];
    self.inputScanView.bkView.alpha = 0.0;
    [self.inputScanView.cancelBtn addTarget:self action:@selector(cancelInput) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    [win addSubview:self.inputScanView];
    [UIView animateWithDuration:0.0 animations:^{
        self.inputScanView.bkView.alpha =0.4;
        self.inputScanView.inputView.hidden = NO;
    }completion:^(BOOL finished) {
        [self.inputScanView.inputTF becomeFirstResponder];
    }];
}
-(void)cancelInput {
    [self.inputScanView endEditing:YES];
    [self.inputScanView removeSelf];
}

-(void)txchange:(UITextField *)tf{
    NSInteger i = tf.tag -10086;
    NSString *password = tf.text;
    if (password.length == 5) {
        [self configureOrder:i WithConfirmCode:tf.text];
    }
    NSArray *tfArray = @[self.inputScanView.TF1,self.inputScanView.TF2,self.inputScanView.TF3,self.inputScanView.TF4,self.inputScanView.TF5];
    for (int i = 0; i < 5; i++) {
        UITextField *pwdtx = [tfArray objectAtIndex:i];
        NSString *pwd;
        if (i < password.length) {
            pwd = [password substringWithRange:NSMakeRange(i, 1)];
        }else {
            pwd = nil;
        }
        pwdtx.text = pwd;
    }
}
//确认订单
-(void)configureOrder:(NSInteger)index WithConfirmCode:(NSString *)code {
    OperateShopOrder *modelR = [OperateShopOrder new];
    if (QWGLOBALMANAGER.configure.userToken) {
        modelR.token = QWGLOBALMANAGER.configure.userToken;
    }
    MicroMallShopOrderVO *vo = _dataSource[index];
    modelR.orderId = vo.orderId;
    modelR.operate = 3;
    modelR.confirmCode = code;
    [IndentOders operateShopOrder:modelR success:^(OperateShopOrderModel *model) {
        if ([model.apiStatus intValue] == 0) {
            //操作成功重刷一次数据
            [self.inputScanView.inputTF resignFirstResponder];
            [SVProgressHUD showSuccessWithStatus:@"订单已被完成，流程结束" duration:0.8];
            currentPage = 1;
            [self queryData];
        }else {
            [SVProgressHUD showErrorWithStatus:model.apiMessage duration:.8];
            self.inputScanView.inputTF.text = @"";
            [self txchange:self.inputScanView.inputTF];
        }
    } failure:^(HttpException *e) {
        
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    height = keyboardFrame.size.height;
    CGPoint center = self.inputScanView.inputView.center;
    CGFloat inputHeight = self.inputScanView.frame.size.height;
    if (self.inputScanView.inputView.frame.size.height + self.inputScanView.inputView.frame.origin.y < inputHeight) {
    
    }else {
        center.y -= height;
        [UIView animateWithDuration:duration animations:^{
            self.inputScanView.inputView.center = center;        
        }];
    }
}

-(void)keyboardWillHide:(NSNotification *)notification {
    CGPoint center = self.inputScanView.inputView.center;
    center.y += height;
    [UIView animateWithDuration:duration animations:^{
        self.inputScanView.inputView.center = center;
    }completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.inputScanView removeSelf];
    }];
}
#pragma mark -----------
#pragma mark - pickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == 100) {
        return PostArray.count;
    }else if (pickerView.tag == 101){
        return RefusePayArray.count;
    }else {
        return shopRefuseArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView.tag == 100) {
        ExpressCompanyVO *vo = PostArray[row];
        return vo.name;
    }else if (pickerView.tag == 101){
        return RefusePayArray[row];
    }else {
        return shopRefuseArray[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag == 100) {
        postCompany = PostArray[row];
    }else if (pickerView.tag == 101){
        refuseReason = RefusePayArray[row];
    }else {
        shopRefuseReason = shopRefuseArray[row];
    }
}
//因为qcslide，重新写了没有数据时候的背景
-(void)setNoneDateBG:(NSString *)imageName With:(NSString *)text {
    UIImage * imgInfoBG = [UIImage imageNamed:imageName];
    if (self.bgView==nil) {
        self.bgView = [[UIView alloc]initWithFrame:self.view.bounds];
        self.bgView.backgroundColor = RGBHex(qwColor11);
    }
    self.bgView.frame = self.view.bounds;
    UIImageView *imgvInfo;
    UILabel* lblInfo;
    imgvInfo=[[UIImageView alloc]init];
    [self.bgView addSubview:imgvInfo];
    
    lblInfo = [[UILabel alloc]init];
    lblInfo.numberOfLines=0;
    lblInfo.font = fontSystem(kFontS1);
    lblInfo.textColor = RGBHex(qwColor8);//0x89889b 0x6a7985
    lblInfo.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:lblInfo];
    
    UIButton *btnClick = [[UIButton alloc] initWithFrame:self.vInfo.bounds];
    btnClick.tag=0;
    [btnClick addTarget:self action:@selector(viewInfoClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:btnClick];
    
    
    float vw=CGRectGetWidth(self.bgView.bounds);
    
    CGRect frm;
    frm=RECT((vw-imgInfoBG.size.width)/2,90, imgInfoBG.size.width, imgInfoBG.size.height);
    imgvInfo.frame=frm;
    imgvInfo.image = imgInfoBG;
    
    float lw=vw-40*2;
    float lh=(imageName!=nil)?CGRectGetMaxY(imgvInfo.frame) + 24:40;
    CGSize sz=[self sizeText:text font:lblInfo.font limitWidth:lw];
    frm=RECT((vw-lw)/2, lh, lw,sz.height);
    lblInfo.frame=frm;
    lblInfo.text = text;
    self.bgView.hidden = YES;
    [self.view addSubview:self.bgView];
}

- (CGSize)sizeText:(NSString*)text
              font:(UIFont*)font
        limitWidth:(float)width
{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin//|NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    rect.size.width=width;
    rect.size.height=ceil(rect.size.height);
    return rect.size;
}
#pragma mark-------
#pragma mark - networking
-(void)queryData {
    self.bgView.hidden = YES;
    QueryShopOrdersR *modelR = [QueryShopOrdersR new];
    if (QWGLOBALMANAGER.configure.userToken) {
        modelR.token = QWGLOBALMANAGER.configure.userToken;
    }
    modelR.status = self.status;
    modelR.page = currentPage;
    modelR.pageSize = 10;
    if (_status.integerValue == 0) {
        modelR.uploadInvoice = _postStatus;
    }
    [IndentOders queryOrders:modelR success:^(OrderListModel *responseModel) {
        [self.tableView footerEndRefreshing];
        if (responseModel.list.count > 0) {
            if (currentPage == 1) {
                _dataSource = [NSMutableArray arrayWithArray:responseModel.list];
            }else{
                [_dataSource addObjectsFromArray:responseModel.list];
            }
        }else {
            if (currentPage == 1) {
                [_dataSource removeAllObjects];
            }else {
                self.tableView.footer.canLoadMore = NO;
                currentPage --;
            }
        }
        [self.tableView reloadData];
        if (_dataSource.count == 0) {
//            _tableView.hidden = YES;
//            [self showInfoView:@"您还没有订单哦~" image:@"img_order"];
            _tableView.scrollEnabled = NO;
            self.bgView.hidden = NO;
        }else {
            _tableView.scrollEnabled = YES;
            self.bgView.hidden = YES;
        }
    } failure:^(HttpException *e) {
        [self.tableView footerEndRefreshing];
    }];
}
//请求物流数据
-(void)queryPostData{
    QueryLCR *modelR = [QueryLCR new];
    [IndentOders queryLC:modelR success:^(LCModel *model) {
        if (model.list.count > 0) {
            PostArray = [NSMutableArray arrayWithArray:model.list];
            postCompany = [PostArray firstObject];
        }
    } failure:^(HttpException *e) {
        
    }];
}
//请求拒绝理由数据
-(void)queryRefuseReason {
    QueryCancelReasons *modelR = [QueryCancelReasons new];
    modelR.type = 2;
    [IndentOders queryRefuseReasons:modelR success:^(CancelReasonModel *model) {
        if (model.list.count > 0) {
            RefusePayArray = [NSMutableArray arrayWithArray:model.list];
            [RefusePayArray addObject:WriteReason];
            refuseReason = [RefusePayArray firstObject];
        }
    } failure:^(HttpException *e) {
        
    }];
}
//请求商家取消理由
-(void)queryShopRefuseReason {
    QueryCancelReasons *modelR = [QueryCancelReasons new];
    modelR.type = 3;
    [IndentOders queryRefuseReasons:modelR success:^(CancelReasonModel *model) {
        if (model.list.count > 0) {
            shopRefuseArray = [NSMutableArray arrayWithArray:model.list];
            [shopRefuseArray addObject:WriteReason];
            shopRefuseReason = [shopRefuseArray firstObject];
        }
    } failure:^(HttpException *e) {
        
    }];
}
@end
