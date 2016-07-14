//
//  BranchdetailCViewController.m
//  wenYao-store
//
//  Created by caojing on 15/8/26.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "BranchdetailCViewController.h"
#import "FirstCoupnTableViewCell.h"
#import "CommonTableViewCell.h"
#import "BranchdetailPViewController.h"
#import "WebDirectViewController.h"
#import "ThreeCoupnTableViewCell.h"
#import "SendPromotionViewController.h"
#import "commonTelView.h"

static NSString * const CouponDetailTableViewCellIdentifier = @"CouponDetailTableViewCell";
@interface BranchdetailCViewController (){
    UIView *conditionView;
    NSMutableArray *conditionArray;
}

@property (strong, nonatomic) OnlineBaseCouponDetailVo *model;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BranchdetailCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    conditionArray = [NSMutableArray array];
    // 请求详情数据
    [self queryCoupn];
    // 设置列表 header
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CouponDetailTableViewCellIdentifier];
    [self setUpHeaderView];
    self.title=@"优惠券详情";
    [self setUpRightItem];
    
    self.tableView.hidden = YES;
}

#pragma mark ---- 设置列表 header ----

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)setUpHeaderView
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 8.0f)];
    v.backgroundColor = self.tableView.backgroundColor;
    self.tableView.tableHeaderView = v;
    self.footView.hidden = YES;
    self.constraintFootHeight.constant = 0.0f;
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    self.purcharsButton.layer.masksToBounds=YES;
    self.purcharsButton.layer.cornerRadius=4.0f;
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
}

#pragma mark ---- 分享 ----

- (void)setUpRightItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareClick)];
}

- (void)shareClick
{
    
    [QWGLOBALMANAGER statisticsEventId:@"s_yhq_fx" withLable:@"优惠券分享" withParams:nil];
    
    // 设置分享按钮
    if (self.model.canEmpShare == NO) {
        [SVProgressHUD showErrorWithStatus:@"此券已经设置为不可分享"];
        return;
    }
    
    ShareContentModel *modelShare = [ShareContentModel new];
    if ([self.model.scope intValue] == 4) {
        if(!StrIsEmpty(self.model.giftImgUrl)){
            modelShare.imgURL = self.model.giftImgUrl;
        }
        modelShare.typeShare = ShareTypeCouponQuan;
    } else {
        if(!StrIsEmpty(self.model.giftImgUrl)){
            modelShare.imgURL = self.model.giftImgUrl;
        }
        modelShare.typeShare = ShareTypeChronicCouponQuan;
    }
    modelShare.shareID = [NSString stringWithFormat:@"%@%@%@",self.model.couponId,SeparateStr,QWGLOBALMANAGER.configure.groupId];
    modelShare.title = self.model.couponTitle;
    modelShare.content = self.model.desc;
    
    ShareSaveLogModel *modelR = [ShareSaveLogModel new];
    modelR.shareObj = @"1";
    modelR.shareObjId = self.model.couponId;
    modelR.city = @"";
    modelShare.modelSavelog = modelR;
    
    [self popUpShareView:modelShare];
}


#pragma mark ---- 请求优惠详情数据 ----

-(void)queryCoupn{
    
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }
    
    OnlineModelR * modelR = [OnlineModelR new];
    modelR.token = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    modelR.couponId = StrFromObj(self.coupnId);
    
    [Coupn queryGetonLineCoupnParams:modelR success:^(id responseObj) {
        
        OnlineBaseCouponDetailVo *model=[OnlineBaseCouponDetailVo parse:responseObj];
        
        //测试假数据
        //        // scope   1.通用   2.慢病   3.全部  4.礼品券  5.商品券
        //        // status  0.待开始 1.待使用 2.快过期 3.已使用 4.已过期
        //        model.scope = @"4";
        //        model.empty = 1;
        //        model.status = @"4";
        
        if([model.apiStatus intValue]==0)
        {
            self.model = model;
            [self getCondition];
            [self setfootButton];
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }
        else if([model.apiStatus intValue]==2010106){
            [self showInfoView:[NSString stringWithFormat:@"对不起，该优惠已下架"] image:@"ic_img_fail"];
        }
        else{
            [self showInfoView:@"暂无优惠券详情" image:@"ic_img_fail"];
        }
        
    } failure:^(HttpException *e) {
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [self showInfoView:kWaring12 image:@"img_network"];
        }else
        {
            if(e.errorCode!=-999){
                if(e.errorCode == -1001){
                    [self showInfoView:kWarning215N54 image:@"ic_img_fail"];
                }else{
                    [self showInfoView:kWarning215N0 image:@"ic_img_fail"];
                }
            }
        }
    }];
    
}


-(void)getCondition{
    
    //获取优惠细则的个数
    CouponConditionModelR *modelRCondition = [CouponConditionModelR new];
    modelRCondition.type = @"1";
    modelRCondition.id = self.model.couponId;
    
    
    [Coupn getCouponCondition:modelRCondition success:^(id couponConditions) {
        CouponConditionVoListModel *modelCondition = (CouponConditionVoListModel *)couponConditions;
        [conditionArray addObject:modelCondition.title];
        [conditionArray addObjectsFromArray:modelCondition.conditions];
        
        [self.tableView reloadData];
    } failure:^(HttpException *e) {
        
    }];
}


-(void)setfootButton{
    if (AUTHORITY_ROOT) {  // 主账号可以送优惠，子账号不可以   慢病券和商品券有适用商品  其他券没有适用商品
        if(self.model.empty==YES){
            self.footView.hidden = YES;
            self.constraintFootHeight.constant = 0.0f;
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
            
            
            //            self.tableView.tableFooterView.hidden=YES;
        }else{
            self.footView.hidden = NO;
            self.constraintFootHeight.constant = 50.0f;
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
            
            //            self.tableView.tableFooterView.hidden=NO;
        }
    }
    else{
        self.footView.hidden = YES;
        self.constraintFootHeight.constant = 0.0f;
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        
        //        self.tableView.tableFooterView.hidden=YES;
    }
}



- (IBAction)buttonAction:(id)sender {
    [commonTelView showAlertViewAtView:[UIApplication sharedApplication].keyWindow withType:@"1" andId:self.model.couponId callBack:^(id obj) {
        
    }];
    
}

#pragma mark ---- 列表代理 ----

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        // scope   1.通用   2.慢病   3.全部  4.礼品券  5.商品券
        // status  0.待开始 1.待使用 2.快过期 3.已使用 4.已过期
        
        if([self.model.scope intValue]==4)
        {
            // 礼品券
            return [ThreeCoupnTableViewCell getCellHeight:nil];
        }else{
            // 其他券
            return [FirstCoupnTableViewCell getCellHeight:nil];
        }
    }else
    {
        if([self.model.suitableProductCount intValue]>0){
            if(indexPath.row==1){
                return [self getConditionHeight];
            }else{
                
                return [CommonTableViewCell getCellHeight:nil];
            }
            
        }else{
            
            return [self getConditionHeight];
        }
        
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)atableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)atableView numberOfRowsInSection:(NSInteger)section
{
    if([self.model.suitableProductCount intValue]>0){//慢病券  商品券
        return 3;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        OnlineBaseCouponDetailVo *model = self.model;
        
        // 其他券的cell
        static NSString *FirstCoupnCell = @"FirstCoupnCell";
        FirstCoupnTableViewCell *cell = (FirstCoupnTableViewCell *)[atableView dequeueReusableCellWithIdentifier:FirstCoupnCell];
        if(cell == nil){
            UINib *nib = [UINib nibWithNibName:@"FirstCoupnTableViewCell" bundle:nil];
            [atableView registerNib:nib forCellReuseIdentifier:FirstCoupnCell];
            cell = (FirstCoupnTableViewCell *)[atableView dequeueReusableCellWithIdentifier:FirstCoupnCell];
        }
        
        // 礼品券的cell
        static NSString *ThreeCoupnCell = @"ThreeCoupnCell";
        ThreeCoupnTableViewCell *threeCell = (ThreeCoupnTableViewCell *)[atableView dequeueReusableCellWithIdentifier:ThreeCoupnCell];
        if(threeCell == nil){
            UINib *nib = [UINib nibWithNibName:@"ThreeCoupnTableViewCell" bundle:nil];
            [atableView registerNib:nib forCellReuseIdentifier:ThreeCoupnCell];
            threeCell = (ThreeCoupnTableViewCell *)[atableView dequeueReusableCellWithIdentifier:ThreeCoupnCell];
        }
        
        
        // scope   1.通用   2.慢病   3.全部  4.礼品券  5.商品券
        // status  0.待开始 1.待使用 2.快过期 3.已使用 4.已过期
        
        // 是否过期
        if(!StrIsEmpty(model.giftImgUrl)){ // 礼品券
            [threeCell setCoupnOtherDetailCell:model];
            return threeCell;
        }else{ // 其他券
            [cell setCoupnOtherDetailCell:model];
            return cell;
        }
    }else
    {
        static NSString *commonTableCell = @"commonTableCell";
        CommonTableViewCell *cell = (CommonTableViewCell *)[atableView dequeueReusableCellWithIdentifier:commonTableCell];
        if(cell == nil){
            UINib *nib = [UINib nibWithNibName:@"CommonTableViewCell" bundle:nil];
            [atableView registerNib:nib forCellReuseIdentifier:commonTableCell];
            cell = (CommonTableViewCell *)[atableView dequeueReusableCellWithIdentifier:commonTableCell];
        }
        
        if ([self.model.suitableProductCount intValue]>0) { // 慢病券 商品券
            if (indexPath.row == 1) {
                return [self getCouponDetailCell:atableView WithTitle:@"优惠细则"];
            }else{
                cell.titleLable.text=@"适用商品";
                return cell;
            }
        }else{ //  其他券
            return [self getCouponDetailCell:atableView WithTitle:@"优惠细则"];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8f];
        return;
    }
    
    if([self.model.suitableProductCount intValue]>0){ //  慢病券 商品券
        if(indexPath.row==2){
            // 适用商品
            [self jumpToProduct];
        }
    }else{
        if(indexPath.row==1){
            // 适用商品
            [self jumpToProduct];
        }
    }
    
    
}

// 适用商品
- (void)jumpToProduct
{
    BranchdetailPViewController *vc=[[BranchdetailPViewController alloc] initWithNibName:@"BranchdetailPViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed=YES;
    vc.coupnId=self.model.couponId;
    [self.navigationController pushViewController:vc animated:YES];
}

//优惠细则
- (void)jumpToCondition
{
    //  优惠细则
    WebDirectViewController *vcWebDirect = [[UIStoryboard storyboardWithName:@"WebDirect" bundle:nil] instantiateViewControllerWithIdentifier:@"WebDirectViewController"];
    WebCouponConditionModel *modelCondition = [[WebCouponConditionModel alloc] init];
    modelCondition.couponId = self.model.couponId;
    modelCondition.type = @"1";
    WebDirectLocalModel *modelLocal = [[WebDirectLocalModel alloc] init];
    modelLocal.modelCondition = modelCondition;
    modelLocal.typeLocalWeb = WebLocalTypeCouponCondition;
    [vcWebDirect setWVWithLocalModel:modelLocal];
    vcWebDirect.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcWebDirect animated:YES];
}

#pragma mark - 优惠细则cell
- (UITableViewCell *)getCouponDetailCell:(UITableView *)tableView WithTitle:(NSString *)title
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CouponDetailTableViewCellIdentifier];
    cell.translatesAutoresizingMaskIntoConstraints = NO;
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    cell.userInteractionEnabled = NO;
    
    UIView *viewGray = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 10)];
    viewGray.backgroundColor = RGBHex(qwColor11);
    [cell.contentView addSubview:viewGray];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 17, 200, 21)];
    label.font = fontSystem(kFontS4);
    label.textColor = RGBHex(qwColor6);
    label.text = title;
    [cell.contentView addSubview:label];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 45 - 0.5, APP_W, 0.5)];
    line.backgroundColor = RGBHex(qwColor10);
    [cell.contentView addSubview:line];
    
    [conditionView removeFromSuperview];
    [cell.contentView addSubview:[self setupConditionView]];
    //    [cell.contentView layoutSubviews];
    return cell;
}

- (UIView *)setupConditionView{
    
    if(conditionArray.count == 0)
        return [[UIView alloc]init];
    if(conditionView) {
        return conditionView;
    }
    //
    
    conditionView = [[UIView alloc]initWithFrame:CGRectMake(0, 45.0f, APP_W, [self getConditionHeight])];
    conditionView.translatesAutoresizingMaskIntoConstraints = NO;
    int strCount = 0;
    CGFloat viewY = 10.0f;
    
    for(NSString *str in conditionArray){
        
        UIImageView *point = [[UIImageView alloc]initWithFrame:CGRectMake(15, viewY + 5.0f, 6, 6)];
        point.image = [UIImage imageNamed:@"img_point"];
        [conditionView addSubview:point];
        
        CGSize size = [QWGLOBALMANAGER sizeText:str font:fontSystem(kFontS5) limitWidth:APP_W - 34.0f];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(27.0f, viewY,  APP_W - 34.0f, size.height)];
        label.numberOfLines = 0;
        label.font = fontSystem(kFontS5);
        label.textColor = RGBHex(qwColor6);
        label.text = str;
        [conditionView addSubview:label];
        viewY = viewY + label.frame.size.height;
        
        viewY += 8.0f;
        strCount ++;
    }
    
    return conditionView;
}

- (CGFloat)getConditionHeight{
    
    CGFloat conditionHeight = 10.0f;
    for(NSString *str in conditionArray){
        CGSize size = [QWGLOBALMANAGER sizeText:str font:fontSystem(kFontS5) limitWidth:APP_W - 34.0f];
        conditionHeight += size.height;
        conditionHeight += 8.0f;
    }
    return conditionHeight + 57.0f;
}





//送优惠
- (void)jumpToSendPromotion
{
    SendPromotionViewController *sendPromotionViewController = [[SendPromotionViewController alloc] initWithNibName:@"SendPromotionViewController" bundle:nil];
    sendPromotionViewController.promotionType = @"1";
    sendPromotionViewController.promotionId = self.model.couponId;
    [self.navigationController pushViewController:sendPromotionViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
