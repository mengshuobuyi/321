//
//  IndentDetailViewController.m
//  APP
//  订单详情页面
//  订单详情接口：QueryShopOrderDetailInfo
//  操作订单接口：OperateOrders
//  Created by qw_imac on 15/12/29.
//  Copyright © 2015年 carret. All rights reserved.
//

#import "IndentDetailListViewController.h"
#import "IndentDetailTopTableViewCell.h"
#import "ReceiverTableViewCell.h"
#import "ProTableViewCell.h"
#import "ProPromotionTableViewCell.h"
#import "InfoTableViewCell.h"
#import "TimeAndMessageTableViewCell.h"
#import "IndentOders.h"
#import "CancelAlertView.h"
#import "InputScanView.h"
#import "RefusePayReasonView.h"
#import "AllScanReaderViewController.h"
#import "SVProgressHUD.h"
#import "CheckPostViewController.h"
#import "LoginViewController.h"
#import "InputOrderPostNumberViewController.h"
#import "SmallTipDetailViewController.h"
#import "ClientMMDetailViewController.h"
@interface IndentDetailListViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    UIButton            *ensureBtn;
    UIButton            *cancelBtn;
    UIButton            *speacialBtn;
    NSMutableArray      *postArray;
    NSMutableArray      *RefusePayArray;    //商家拒单理由列表
    NSMutableArray      *shopRefuseArray;   //商家取消订单理由列表
    NSString            *refuseReason;      //拒单理由
    NSString            *shopRefuseReason;  //商家取消订单理由
    ExpressCompanyVO    *postCompany;       //物流公司
    float               height;             //数字键盘高度记录
    NSTimeInterval      duration;           //键盘出现时间记录
    NSInteger           pickIndex;
    NSMutableArray      *proArray;           //所有商品array
    NSMutableDictionary *typeDic;
    UIView              *footView;
}
@property (nonatomic,strong)InputScanView       *inputScanView;
@property (nonatomic,strong)CancelAlertView     *fillPostView;
@property (nonatomic,strong)RefusePayReasonView *refuseView;
@property (nonatomic,strong)ShopOrderDetailVO   *orderModel;
@property (nonatomic,strong)NSString            *billNo;
@property (nonatomic,strong)UITextField         *groupNameTextField;
@end

@implementation IndentDetailListViewController
static NSString *WriteReason = @"手动填写原因";
- (void)viewDidLoad {
    [super viewDidLoad];
    [QWGLOBALMANAGER statisticsEventId:@"订单详情页出现" withLable:nil withParams:nil];
    self.title = @"订单详情";
    postArray = [NSMutableArray array];
    RefusePayArray = [NSMutableArray array];
    refuseReason = [[NSString alloc]init];
    proArray = [@[] mutableCopy];
    typeDic = [[NSMutableDictionary alloc]init];
    self.billNo = [[NSString alloc]init];
    [self queryPostData];
    [self queryRefuseReason];
    [self queryShopRefuseReason];
    [self setupUI];
    [self login];
    
    self.tableMain.hidden = YES;
}
-(void)setupUI {
    self.tableMain =[[UITableView alloc] initWithFrame:CGRectMake(0, 0 , APP_W, [[UIScreen mainScreen] bounds].size.height - 106 ) style:UITableViewStylePlain];
    self.tableMain.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableMain.delegate = self;
    self.tableMain.dataSource = self;
    self.tableMain.backgroundColor = [UIColor clearColor];
    
    float scale = APP_W / 320;
    footView = [[UIView alloc]initWithFrame:CGRectMake(0, self.tableMain.frame.size.height, APP_W, 42)];
    footView.backgroundColor = [UIColor whiteColor];
    
    cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(APP_W - 75 * scale - 15, 7.5, 75*scale, 27)];
    [cancelBtn setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
    cancelBtn.layer.borderColor = RGBHex(qwColor9).CGColor;
    [cancelBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = fontSystem(kFontS4);
    cancelBtn.layer.cornerRadius = 3.0;
    cancelBtn.layer.borderWidth = 0.5;
    cancelBtn.layer.masksToBounds = YES;
    ensureBtn = [[UIButton alloc]initWithFrame:CGRectMake(APP_W - 75* 2 * scale - 15 - 12*scale , 7.5, 75*scale, 27)];
    [ensureBtn setTitleColor:RGBHex(qwColor2) forState:UIControlStateNormal];
    [ensureBtn setTitle:@"接单" forState:UIControlStateNormal];
    ensureBtn.titleLabel.font = fontSystem(kFontS4);    
    ensureBtn.layer.cornerRadius = 3.0;
    ensureBtn.layer.borderWidth = 0.5;
    ensureBtn.layer.borderColor = RGBHex(qwColor2).CGColor;
    ensureBtn.layer.masksToBounds = YES;
    
    speacialBtn = [[UIButton alloc]initWithFrame:CGRectMake(APP_W - 75*3 * scale -2* 12*scale-15 , 7.5, 75*scale, 27)];
    [speacialBtn setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
    [speacialBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    speacialBtn.titleLabel.font = fontSystem(kFontS4);
    speacialBtn.layer.cornerRadius = 3.0;
    speacialBtn.layer.borderWidth = 0.5;
    speacialBtn.layer.borderColor = RGBHex(qwColor9).CGColor;
    speacialBtn.layer.masksToBounds = YES;

    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 0.5)];
    line.backgroundColor = RGBHex(qwColor10);
    [footView addSubview:line];
    [footView addSubview:cancelBtn];
    [footView addSubview:ensureBtn];
    [footView addSubview:speacialBtn];
    [self.view addSubview:footView];
    [self.view bringSubviewToFront:footView];
    [self.view addSubview:self.tableMain];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self queryOrderDetail];
}

-(void)popVCAction:(id)sender {
    [super popVCAction:sender];
    if (self.refreshBlock) {
        self.refreshBlock();
    }
}
#pragma mark - tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return proArray.count;
    }else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            IndentDetailTopTableViewCell *cell;
            cell = (IndentDetailTopTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"IndentDetailTopTableViewCell" owner:self options:nil][0];
            cell.refundImg.hidden = YES;
            if ([_orderModel.payType integerValue] == 2) {
                cell.payStatusLabel.hidden = NO;
            }else {
                cell.payStatusLabel.hidden = YES;
            }
            //退款图标
            if ([_orderModel.refundStatus intValue] == 1) {
                cell.refundImg.hidden = NO;
                cell.refundImg.image = [UIImage imageNamed:@"lable_refund"];
            }else if ([_orderModel.refundStatus intValue] == 2) {
                cell.refundImg.hidden = NO;
                cell.refundImg.image = [UIImage imageNamed:@"lable_refund_end"];
            }
            switch ([_orderModel.orderStatus intValue]) {
                case 1:
                    cell.stateLabel.text = @"待接单";
                    break;
                case 2:
                    cell.stateLabel.text = @"待配送";
                    break;
                case 3:
                    cell.stateLabel.text = @"配送中";
                    break;
                case 5:
                    cell.stateLabel.text = @"已拒绝";
                    break;
                case 6:
                    cell.stateLabel.text = @"待取货";
                    break;
                case 8:
                    cell.stateLabel.text = @"已取消";
                    break;
                case 9:
                    cell.stateLabel.text = @"已完成";
                    break;
            }
            cell.messageLabel.text = _orderModel.orderDesc;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
        case 1:
        {
            ReceiverTableViewCell *cell;
            cell = (ReceiverTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"ReceiverTableViewCell" owner:self options:nil][0];
            cell.leaveMessage.text = [NSString stringWithFormat:@"买家留言:%@",_orderModel.orderDescUser];
            if (_orderModel.receiverTel && ![_orderModel.receiverTel isEqualToString:@""]) {
                cell.nameLabel.text = [NSString stringWithFormat:@"%@:",_orderModel.receiver];
                cell.telLabel.hidden = NO;
                cell.underLine.hidden = NO;
                cell.telLabel.text = _orderModel.receiverTel;
                cell.phoneBtn.hidden = NO;
            }else {
                cell.nameLabel.text = [NSString stringWithFormat:@"%@",_orderModel.receiver];
                cell.telLabel.hidden = YES;
                cell.underLine.hidden = YES;
                cell.phoneBtn.hidden = YES;
            }
            [cell.memberBtn addTarget:self action:@selector(gotoMemberDetail) forControlEvents:UIControlEventTouchUpInside];
            [cell.phoneBtn addTarget:self action:@selector(phoneCall) forControlEvents:UIControlEventTouchUpInside];
            if ([_orderModel.deliverType integerValue] == 1) {
                cell.addressLabel.hidden = YES;
                cell.locationBtn.hidden = YES;
            }else {
                cell.addressLabel.hidden = NO;
                cell.locationBtn.hidden = NO;
                cell.addressLabel.text = [NSString stringWithFormat:@"收货地址: %@",_orderModel.receiveAddr];
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
                    [cell.locationBtn addTarget:self action:@selector(openLocationTool) forControlEvents:UIControlEventTouchUpInside];
                }else {
                    cell.locationBtn.hidden = YES;
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
        case 2:
        {
            TimeAndMessageTableViewCell *cell;
            cell = (TimeAndMessageTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"TimeAndMessageTableViewCell" owner:self options:nil][0];
            cell.timeLabel.text = [NSString stringWithFormat:@"%@",_orderModel.createStr];

            cell.orderId.text = _orderModel.orderCode;
//            cell.payWay.text = _orderModel.payType.integerValue == 1?@"当面支付":@"在线支付";
            
            if (_orderModel.payType.integerValue == 1) {
                cell.payWay.text = @"当面支付";
            }else {
                if (_orderModel.onLinePayType.integerValue == 1) {
                    cell.payWay.text = @"在线支付(支付宝)";
                }else if (_orderModel.onLinePayType.integerValue == 2) {
                    cell.payWay.text = @"在线支付(微信)";
                }else {
                    cell.payWay.text = @"在线支付";
                }
            }
            
            if([_orderModel.orderStatus integerValue] == 1){
                //待接单隐藏处理人这一栏
                cell.dealLabel.hidden = YES;
                cell.dealPerson.hidden = YES;
            }else {
                cell.dealLabel.hidden = NO;
                cell.dealPerson.hidden = NO;
                cell.dealPerson.text = _orderModel.dealer;
            }
            NSString *post = @"";
            switch (_orderModel.deliverType.integerValue) {
                case 1:
                    post = @"到店取货";
                    break;
                case 2:
                    post = @"送货上门";
                    break;
                case 3:
                    post = @"同城快递";
                    break;
                default:
                    break;
            }
            cell.postStyle.text = post;
            if(!StrIsEmpty(_orderModel.actTitle)) {
                cell.promotionCoupon.text = _orderModel.actTitle;
            }else {
                cell.promotionCoupon.text = @"未使用优惠券";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
        }
        case 3:
        {
            ProTableViewCell *cell;
            cell = (ProTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"ProTableViewCell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            ShopMicroMallOrderDetailVO *vo = proArray[indexPath.row];
            setCellModel *model = [setCellModel creatSetCellModel:vo];
            //comboCount套餐商品总数
            NSInteger comboCount = 0;
            for (NSInteger index = 0; index < _orderModel.orderComboVOs.count; index ++) {
                OrderComboVo *vo = _orderModel.orderComboVOs[index];
                comboCount += vo.microMallOrderDetailVOs.count;
            }
            if (indexPath.row < comboCount) {
                //套餐
                model.type = CellTypeCombo;
                NSInteger comboIndex = 0;
                for (NSInteger index = 0; index < _orderModel.orderComboVOs.count; index ++) {
                    OrderComboVo *vo = _orderModel.orderComboVOs[index];
                    comboIndex += vo.microMallOrderDetailVOs.count;
                    if (indexPath.row == comboIndex - 1) {
                        //每个套餐的最后一个商品
                        model.type = CellTypeComboLast;
                        model.comboPrice = vo.comboPrice;
                        model.comboCount = vo.comboAmount;
                    }
                }
            }else if (indexPath.row < comboCount + _orderModel.microMallOrderDetailVOs.count) {
                //普通商品
                model.type = CellTypeNormal;
            }else {
                //换购商品
                model.type = CellTypeRedemption;
            }
            //储存每个index。row对应的type
            NSString *key = [NSString stringWithFormat:@"%i",indexPath.row];
            NSNumber *value = [NSNumber numberWithInteger:model.type];
            typeDic[key] = value;
            [cell setCell:model];
            return cell;
            break;
        }
        case 4:
        {
            ProPromotionTableViewCell *cell;
            cell = (ProPromotionTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"ProPromotionTableViewCell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = kCFNumberFormatterRoundFloor;
            [formatter setMaximumFractionDigits:2];
            float proAmount = [_orderModel.proAmount floatValue];
            float discountAmount = [_orderModel.discountAmount floatValue];
            float deliverAmount = [_orderModel.deliverAmount floatValue];
            float finalAmount = [_orderModel.finalAmount floatValue];
            cell.allPrice.text = [NSString stringWithFormat:@"￥%@",[formatter stringFromNumber:[NSNumber numberWithFloat:proAmount]]];
            cell.discountPrice.text = [NSString stringWithFormat:@"%@",_orderModel.orderPmt?_orderModel.orderPmt:@""];
            cell.postPrice.text = [NSString stringWithFormat:@"￥%@",[formatter stringFromNumber:[NSNumber numberWithFloat:deliverAmount]]];
            
            cell.finalPrice.text = [NSString stringWithFormat:@"￥%@",[formatter stringFromNumber:[NSNumber numberWithFloat:finalAmount]]];
            return cell;
            break;
        }
   
        default:
            return nil;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = 0.0;

    switch (indexPath.section) {
        case 0:
            cellHeight = 60;//没有按钮时返回60
            break;
        case 1:
            if ([_orderModel.deliverType integerValue]==1) {
                cellHeight = 70;
            }else {
                cellHeight = 100;
            }
            break;
        case 2:
            if ([_orderModel.orderStatus integerValue]==1) {
                cellHeight = 115;
            }else {
                cellHeight = 135;
            }
            break;
        case 3:
        {
            NSString *key = [NSString stringWithFormat:@"%i",indexPath.row];
            NSNumber *type = typeDic[key];
            ShopMicroMallOrderDetailVO *vo = proArray[indexPath.row];
            switch (type.integerValue) {
                case CellTypeCombo:
                    cellHeight = 85;
                    break;
                case CellTypeComboLast:
                    cellHeight = 121;
                    break;
                case CellTypeNormal:
                {
                    //普通商品高度
                    if ([vo.freeBieQty intValue] > 0) {
                        cellHeight = 121;
                    }else {
                        cellHeight = 97;
                    }
                }
                    break;
                case CellTypeRedemption:
                    cellHeight = 121;
                    break;
            }
            if (!StrIsEmpty(vo.proTag)) {
                cellHeight += 20;
            }
        }
            break;
            
        case 4:
            cellHeight = 138;
            break;
    }
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return 0;
    }else {
        return 7.0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 7.0)];
    bgView.backgroundColor = [UIColor clearColor];
    
    return bgView;
}

#pragma mark -----------
#pragma mark - pickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == 100) {
        return postArray.count;
    }else if(pickerView.tag == 101) {
        return RefusePayArray.count;
    }else {
        return shopRefuseArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView.tag == 100) {
        ExpressCompanyVO *vo = postArray[row];
        return vo.name;
    }else if(pickerView.tag == 101){
        return RefusePayArray[row];
    }else {
        return shopRefuseArray[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag == 100) {
        postCompany = postArray[row];
        pickIndex = row;
    }else if (pickerView.tag == 101){
        refuseReason = RefusePayArray[row];
    }else if (pickerView.tag == 102) {
        shopRefuseReason = shopRefuseArray[row];
    }
}
#pragma mark - 业务方法
//会员详情
-(void)gotoMemberDetail {
    [QWGLOBALMANAGER statisticsEventId:@"s_ddxq_hyxq" withLable:@"订单详情" withParams:nil];
    ClientMMDetailViewController *info = [[UIStoryboard storyboardWithName:@"ClientInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"ClientMMDetailViewController"];
    info.customerId = _orderModel.userId;
    [self.navigationController pushViewController:info animated:YES];
}

//打电话
-(void)phoneCall {
    UIActionSheet *telphone = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
    [telphone addButtonWithTitle:_orderModel.receiverTel];
    [telphone showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self _phoneCall];
    }
}

-(void)_phoneCall {
    NSString *number = [NSString stringWithFormat:@"tel://%@",_orderModel.receiverTel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];

}

//调用导航
-(void)openLocationTool {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"问药商家版",@"quanweistoreios",[_orderModel.receiveLat floatValue],[_orderModel.receiveLnt floatValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        return;
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",[_orderModel.receiveLat floatValue],[_orderModel.receiveLnt floatValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        return;
    }
}

//确认订单
-(void)configureOrder {
    if (self.inputScanView) {
        self.inputScanView = nil;
    }
    self.inputScanView = [InputScanView inputScanView];
    self.inputScanView.height.constant = 0.0;
    self.inputScanView.inputTF.delegate = self;
    
    
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

-(void)txchange:(UITextField *)tf{
    NSString *password = tf.text;
    if (password.length == 5) {
        [self configureOrderWithConfirmCode:tf.text];
        
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

-(void)configureOrderWithConfirmCode:(NSString *)code {
    OperateShopOrder *modelR = [OperateShopOrder new];
    if (QWGLOBALMANAGER.configure.userToken) {
        modelR.token = QWGLOBALMANAGER.configure.userToken;
    }
    modelR.orderId = _orderModel.orderId;
    modelR.operate = 3;
    modelR.confirmCode = code;
    [IndentOders operateShopOrder:modelR success:^(OperateShopOrderModel *model) {
        if ([model.apiStatus intValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"订单已被完成，流程结束" duration:0.8];
            [self.inputScanView.inputTF resignFirstResponder];
            [self performSelector:@selector(popVCAction:) withObject:nil afterDelay:1];
        }else {
            [SVProgressHUD showErrorWithStatus:model.apiMessage duration:0.5];
            self.inputScanView.inputTF.text = @"";
            [self txchange:self.inputScanView.inputTF];
        }
    } failure:^(HttpException *e) {
        
    }];
}

-(void)cancelInput {
    [self.inputScanView endEditing:YES];
    [self.inputScanView removeSelf];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
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

-(void)keyboardWillHide:(NSNotification *)notification{
    CGPoint center = self.inputScanView.inputView.center;
    center.y += height;
    [UIView animateWithDuration:duration animations:^{
        self.inputScanView.inputView.center = center;
    }completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.inputScanView removeSelf];
    }];
}
//拒绝订单
-(void)refuseOrder {
    _refuseView = [RefusePayReasonView refuseView];
    if (_orderModel.payType.integerValue == 2) {
        _refuseView.title.text = [NSString stringWithFormat:@"选择原因\n(用户已付款，取消后会退款给用户)"];
    }else {
        _refuseView.title.text = [NSString stringWithFormat:@"选择原因"];
    }
    _refuseView.picker.dataSource = self;
    _refuseView.picker.delegate = self;
    _refuseView.picker.tag = 101;
    _refuseView.bkView.alpha = 0.0;
    
    [_refuseView.confireBtn addTarget:self action:@selector(refuseAndCommit) forControlEvents:UIControlEventTouchUpInside];
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    [win addSubview:_refuseView];
    [UIView animateWithDuration:0.25 animations:^{
        _refuseView.bkView.alpha =0.4;
        _refuseView.picker.hidden = NO;
        _refuseView.reasonView.hidden = NO;
        
    }];
}

-(void)refuseAndCommit {
    [_refuseView removeSelf];
    if ([refuseReason isEqualToString:WriteReason]) {
        [self showEditStackViewWithIndex:@(2)];
        return;
    }
    OperateShopOrder *modelR = [OperateShopOrder new];
    if (QWGLOBALMANAGER.configure.userToken) {
        modelR.token = QWGLOBALMANAGER.configure.userToken;
    }
    modelR.orderId = _orderModel.orderId;
    modelR.operate = 2;
    modelR.rejectReason = refuseReason;
    [IndentOders operateShopOrder:modelR success:^(OperateShopOrderModel *model) {
        if ([model.apiStatus intValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"订单取消成功，流程结束" duration:0.8];
            if (!_isComeFromScan) {
               [self performSelector:@selector(popVCAction:) withObject:nil afterDelay:1];
            }else {
                //扫码进来的订单详情拒单之后停留在该页面，须刷新
                [self queryOrderDetail];
            }
        }else {
            
        }
    } failure:^(HttpException *e) {
        
    }];
}
//商家取消订单
-(void)shopRefuseOrder {
    _refuseView = [RefusePayReasonView refuseView];
    if (_orderModel.payType.integerValue == 2) {
        _refuseView.title.text = [NSString stringWithFormat:@"选择原因\n(用户已付款，取消后会退款给用户)"];
    }else {
        _refuseView.title.text = [NSString stringWithFormat:@"选择原因"];
    }
    _refuseView.picker.dataSource = self;
    _refuseView.picker.delegate = self;
    _refuseView.picker.tag = 102;
    _refuseView.bkView.alpha = 0.0;
    
    [_refuseView.confireBtn addTarget:self action:@selector(shopRefuseOrderAndCommit) forControlEvents:UIControlEventTouchUpInside];
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    [win addSubview:_refuseView];
    [UIView animateWithDuration:0.25 animations:^{
        _refuseView.bkView.alpha =0.4;
        _refuseView.picker.hidden = NO;
        _refuseView.reasonView.hidden = NO;
        
    }];
}
//商家取消订单
-(void)shopRefuseOrderAndCommit {
    [_refuseView removeSelf];
    if ([shopRefuseReason isEqualToString:WriteReason]) {
        [self showEditStackViewWithIndex:@(5)];
        return;
    }
    OperateShopOrder *modelR = [OperateShopOrder new];
    if (QWGLOBALMANAGER.configure.userToken) {
        modelR.token = QWGLOBALMANAGER.configure.userToken;
    }
    modelR.orderId = _orderModel.orderId;
    modelR.operate = 5;
    modelR.rejectReason = shopRefuseReason;
    if (!modelR.rejectReason) {
        modelR.rejectReason = [shopRefuseArray firstObject];
    }
    [IndentOders operateShopOrder:modelR success:^(OperateShopOrderModel *model) {
        if ([model.apiStatus intValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"订单取消成功，流程结束" duration:0.8];
            [self performSelector:@selector(popVCAction:) withObject:nil afterDelay:1];
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
        if (StrIsEmpty(self.groupNameTextField.text)) {
            [SVProgressHUD showErrorWithStatus:@"请输入原因"];
            [self performSelector:@selector(showEditStackViewWithIndex:) withObject:@(alertView.tag) afterDelay:1];
            return;
        }
        if (alertView.tag == 2) {
            refuseReason = self.groupNameTextField.text;
        }else if (alertView.tag == 5 ){
            shopRefuseReason = self.groupNameTextField.text;
        }
        [self opeartWith:alertView.tag];
    }
}

//手写理由回调方法
-(void)opeartWith:(NSInteger)index {
    OperateShopOrder *modelR = [OperateShopOrder new];
    if (QWGLOBALMANAGER.configure.userToken) {
        modelR.token = QWGLOBALMANAGER.configure.userToken;
    }
    modelR.orderId = _orderModel.orderId;
    modelR.operate = index;
    if (index == 2) {
        modelR.rejectReason = refuseReason;
    }else if (index == 5 ){
        modelR.rejectReason = shopRefuseReason;
    }
    [IndentOders operateShopOrder:modelR success:^(OperateShopOrderModel *model) {
        if ([model.apiStatus intValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"订单取消成功，流程结束" duration:0.8];
            [self queryOrderDetail];
        }else {
            
        }
    } failure:^(HttpException *e) {
        
    }];
}

//接单
-(void)accecptOrder {
    OperateShopOrder *modelR = [OperateShopOrder new];
    if (QWGLOBALMANAGER.configure.userToken) {
        modelR.token = QWGLOBALMANAGER.configure.userToken;
    }
    modelR.orderId = _orderModel.orderId;
    modelR.operate = 1;
    [IndentOders operateShopOrder:modelR success:^(OperateShopOrderModel *model) {
        if ([model.apiStatus intValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"接单成功，请继续关注" duration:0.8];
            if (!_isComeFromScan) {
                [self performSelector:@selector(popVCAction:) withObject:nil afterDelay:1];
            }else {
                //扫码进来的订单接单后重新刷新
                [self queryOrderDetail];
            }
        }else {
            
        }
    } failure:^(HttpException *e) {
        
    }];
}
//填写物流
-(void)inputOrderPost {
    _fillPostView = [CancelAlertView cancelAlertView];
    _fillPostView.picker.dataSource = self;
    _fillPostView.picker.delegate = self;
    _fillPostView.picker.tag = 100;
    _fillPostView.bkView.alpha = 0.0;
    [_fillPostView.scanBtn addTarget:self action:@selector(scanOrderCode) forControlEvents:UIControlEventTouchUpInside];
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    [win addSubview:_fillPostView];
    [UIView animateWithDuration:0.25 animations:^{
        _fillPostView.bkView.alpha =0.4;
        _fillPostView.picker.hidden = NO;
        _fillPostView.reasonView.hidden = NO;
        _fillPostView.confireView.hidden = NO;
        //        [_fillPostView.picker selectRow:pickIndex inComponent:0 animated:NO];
    }];
}
//扫描或填写运单号
-(void)scanOrderCode{
//    [_fillPostView removeSelf];
    _fillPostView.hidden = YES;
    InputOrderPostNumberViewController *vc = [[InputOrderPostNumberViewController alloc]initWithNibName:@"InputOrderPostNumberViewController" bundle:nil];
    vc.company = postCompany;
    vc.orderId = _orderId;
    __weak typeof(self) weakSelf = self;
    vc.refresh = ^(BOOL success) {
        if (success) {
        [_fillPostView removeFromSuperview];
        [weakSelf queryOrderDetail];
    }else {
        _fillPostView.hidden = NO;
    }
};
    
    [self.navigationController pushViewController:vc animated:YES];
}
//查看物流
-(void)checkOrderPost {
    CheckPostViewController *vc = [CheckPostViewController new];
    vc.postName = _orderModel.expressCompany;
    vc.postNumber = _orderModel.waybillNo;
    [self.navigationController pushViewController:vc animated:YES];
}
//去配送
-(void)gotoDeliver {
    OperateShopOrder *modelR = [OperateShopOrder new];
    if (QWGLOBALMANAGER.configure.userToken) {
        modelR.token = QWGLOBALMANAGER.configure.userToken;
    }
    modelR.orderId = _orderModel.orderId;
    modelR.operate = 4;
    [IndentOders operateShopOrder:modelR success:^(OperateShopOrderModel *model) {
        if ([model.apiStatus intValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"订单已在配送中，接下来确认收货" duration:0.8];
            [self performSelector:@selector(popVCAction:) withObject:nil afterDelay:1];
        }else {
            
        }
        
    } failure:^(HttpException *e) {
        
    }];
}
//设置底部btn样式
-(void)setBtnStyle {
    footView.hidden = NO;
    self.tableMain.frame = CGRectMake(0, 0 , APP_W, [[UIScreen mainScreen] bounds].size.height - 106);
    [speacialBtn addTarget:self action:@selector(shopRefuseOrder) forControlEvents:UIControlEventTouchUpInside];
    speacialBtn.hidden = YES;
    switch ([_orderModel.orderStatus intValue]) {
        case 1://待接单
            [cancelBtn setTitle:@"拒绝" forState:UIControlStateNormal];
            [cancelBtn addTarget:self action:@selector(refuseOrder) forControlEvents:UIControlEventTouchUpInside];
            [ensureBtn setTitle:@"接单" forState:UIControlStateNormal];
            [ensureBtn addTarget:self action:@selector(accecptOrder) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 2://待配送
            [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [cancelBtn addTarget:self action:@selector(shopRefuseOrder) forControlEvents:UIControlEventTouchUpInside];
            if ([_orderModel.deliverType intValue] == 2) {
                [ensureBtn setTitle:@"去配送" forState:UIControlStateNormal];
                [ensureBtn setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
                ensureBtn.layer.borderColor = RGBHex(qwColor9).CGColor;
                [ensureBtn addTarget:self action:@selector(gotoDeliver) forControlEvents:UIControlEventTouchUpInside];
            }else if ([_orderModel.deliverType intValue] == 3){
                [ensureBtn setTitle:@"填写物流" forState:UIControlStateNormal];
                [ensureBtn setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
                ensureBtn.layer.borderColor = RGBHex(qwColor9).CGColor;
                
                [ensureBtn addTarget:self action:@selector(inputOrderPost) forControlEvents:UIControlEventTouchUpInside];
            }else {
                ensureBtn.hidden = YES;
            }
            break;
        case 3://配送中
            [ensureBtn setTitle:@"确认订单" forState:UIControlStateNormal];
            [ensureBtn setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
            ensureBtn.layer.borderColor = RGBHex(qwColor9).CGColor;
            [ensureBtn addTarget:self action:@selector(configureOrder) forControlEvents:UIControlEventTouchUpInside];
            if ([_orderModel.deliverType intValue] == 3) {//快递状态，有查看物流
                speacialBtn.hidden = NO;
                [cancelBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                [cancelBtn addTarget:self action:@selector(checkOrderPost) forControlEvents:UIControlEventTouchUpInside];
            }else {//没有查看物流
                [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                [cancelBtn addTarget:self action:@selector(shopRefuseOrder) forControlEvents:UIControlEventTouchUpInside];
                speacialBtn.hidden = YES;
            }
            break;
        case 5://已拒绝
            cancelBtn.hidden = YES;
            ensureBtn.hidden = YES;
            footView.hidden = YES;
            self.tableMain.frame = CGRectMake(0, 0 , APP_W, [[UIScreen mainScreen] bounds].size.height - 64);
            break;
        case 6://待取货
            [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [cancelBtn addTarget:self action:@selector(shopRefuseOrder) forControlEvents:UIControlEventTouchUpInside];
            [ensureBtn setTitle:@"确认订单" forState:UIControlStateNormal];
            [ensureBtn setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
            ensureBtn.layer.borderColor = RGBHex(qwColor9).CGColor;
            [ensureBtn addTarget:self action:@selector(configureOrder) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 8://已取消
            cancelBtn.hidden = YES;
            ensureBtn.hidden = YES;
            footView.hidden = YES;
            self.tableMain.frame = CGRectMake(0, 0 , APP_W, [[UIScreen mainScreen] bounds].size.height - 64);
            break;
        case 9://已完成
            if ([_orderModel.deliverType intValue] == 3) {
                [ensureBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                [ensureBtn setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
                ensureBtn.layer.borderColor = RGBHex(qwColor7).CGColor;
                [ensureBtn addTarget:self action:@selector(checkOrderPost) forControlEvents:UIControlEventTouchUpInside];
            }else {
                ensureBtn.hidden = YES;
                footView.hidden = YES;
                self.tableMain.frame = CGRectMake(0, 0 , APP_W, [[UIScreen mainScreen] bounds].size.height - 64);
            }
            cancelBtn.hidden = YES;
            break;
        default:
            ensureBtn.hidden = YES;
            cancelBtn.hidden = YES;
            footView.hidden = YES;
            self.tableMain.frame = CGRectMake(0, 0 , APP_W, [[UIScreen mainScreen] bounds].size.height - 64);
            break;
    }
}

-(void)login {
    if (!QWGLOBALMANAGER.loginStatus) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//上传小票
-(void)postOrderPmt {
    SmallTipDetailViewController *vc = [[UIStoryboard storyboardWithName:@"SmallTipStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"SmallTipDetailViewControllerId"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.orderId = _orderModel.orderId;
    vc.orderModel=_orderModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - networking
-(void)queryOrderDetail {
    QueryShopOrdersDetailR *modelR = [QueryShopOrdersDetailR new];
    if(self.modelShop){
        modelR.orderId = _modelShop.orderId;
    }else{
        modelR.orderId = _orderId;
    }
    modelR.token = QWGLOBALMANAGER.configure.userToken?QWGLOBALMANAGER.configure.userToken:@"";
    [IndentOders queryShopOrderDetail:modelR success:^(ShopOrderDetailVO *model) {
        if([model.apiStatus intValue] == 0) {
            _orderModel = model;
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
            btn.titleLabel.font = fontSystem(kFontS4);
            [btn setTitleColor:RGBHex(qwColor4) forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(postOrderPmt) forControlEvents:UIControlEventTouchUpInside];
            if(!model.uploadBill) {
                [btn setTitle:@"上传小票" forState:UIControlStateNormal];
            }else {
                [btn setTitle:@"已传小票" forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(postOrderPmt) forControlEvents:UIControlEventTouchUpInside];
            }
            UIBarButtonItem *naviBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
            self.navigationItem.rightBarButtonItem = naviBtn;
            proArray = [@[] mutableCopy];
            for (OrderComboVo *vo in model.orderComboVOs) {
                [proArray addObjectsFromArray:vo.microMallOrderDetailVOs];
            }
            [proArray addObjectsFromArray:_orderModel.microMallOrderDetailVOs];
            [proArray addObjectsFromArray:_orderModel.redemptionPro];
            [self setBtnStyle];
            self.tableMain.hidden = NO;
            [self.tableMain reloadData];
        }
    } failure:^(HttpException *e) {
        
    }];
}
//请求物流数据
-(void)queryPostData{
    QueryLCR *modelR = [QueryLCR new];
    [IndentOders queryLC:modelR success:^(LCModel *model) {
        if (model.list.count > 0) {
            postArray = [NSMutableArray arrayWithArray:model.list];
            postCompany = [postArray firstObject];
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
