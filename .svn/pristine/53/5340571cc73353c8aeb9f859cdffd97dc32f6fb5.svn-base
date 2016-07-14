//
//  AllTipsViewController.m
//  wenYao-store
//
//  Created by caojing on 15/8/22.
//  Copyright (c) 2015年 carret. All rights reserved.
//

#import "AllTipsViewController.h"
#import "FirstCoupnTableViewCell.h"
#import "SecondProductTableViewCell.h"
#import "ThreeCoupnTableViewCell.h"
#import "ExchangeProductCell.h"
#import "Tips.h"
#import "ComboxView.h"
#import "ComboxViewCell.h"
#import "RightAccessButton.h"
#import "Order.h"
#import "OrganAuthTotalViewController.h"
#import "OrganAuthCommitOkViewController.h"

typedef enum  Enum_Tip_Items {
    Enum_Tip_All   = 0,              //全部订单
    Enum_Tip_Product = 1,            //优惠商品的订单
    Enum_Tip_Coupn = 2,              //优惠券的订单
    Enum_Tip_Exchange = 3,           //兑换商品的订单
}Tip_Items;

@interface AllTipsViewController ()<ComboxViewDelegate,UITableViewDelegate,UITableViewDataSource,changeDelegate>
{
    int totalRecords;
    int noRecords;
    int hasRecords;
    
    NSUInteger                  onlyIndex;
    
    ComboxView                  *onlyComboxView;
    ComboxView                  *rightComboxView;
    
    RightAccessButton           *onlyButton;
    RightAccessButton           *rightButton;

    NSUInteger                  rightIndex;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *noTipList;    // 没有上传小票的数据
@property (strong, nonatomic) NSMutableArray *hasTipList;   // 已上传小票的数据
@property (strong, nonatomic) NSMutableArray *exchangeList; // 兑换商品列表

@property (strong, nonatomic) NSArray *rightMenuItems;      // 优惠券 全部来源
@property (strong, nonatomic) NSArray *onlyMenuItems;       // 优惠商品 全部来源

@property (assign, nonatomic) NSInteger tapButtonType;      // 点击按钮的类型

@property (strong, nonatomic) OrganAuthTotalViewController *vcOrganAuthTotal;

@property (strong, nonatomic) OrganAuthCommitOkViewController *vcOrganAuthCommitOk;

- (IBAction)exchangeProduct:(id)sender;

@end

@implementation AllTipsViewController

- (id)init{
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"订单";
    
    if (!OrganAuthPass) {
        return;
    }
    
    self.typeCell = @"0";
    
    self.noTipList = [NSMutableArray array];
    self.hasTipList = [NSMutableArray array];
    self.exchangeList = [NSMutableArray array];
    self.rightMenuItems = @[@"全部来源",@"来源商家",@"来源全维"];
    self.onlyMenuItems = @[@"全部来源",@"来源商家",@"来源全维"];
    
    // 设置 tableView
    [self setUpTableView];
    
    // 设置 按钮样式
    [self configureButtonStyle];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!OrganAuthPass)
    {
        if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 4 || [QWGLOBALMANAGER.configure.approveStatus integerValue] == 2)
        {
            self.vcOrganAuthTotal = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganAuthTotalViewController"];
            [self.view addSubview:self.vcOrganAuthTotal.view];
            return;
            
            
        }else if ([QWGLOBALMANAGER.configure.approveStatus integerValue] == 1)
        {
            self.vcOrganAuthCommitOk = [[UIStoryboard storyboardWithName:@"OrganAuth" bundle:nil] instantiateViewControllerWithIdentifier:@"OrganAuthCommitOkViewController"];
            [self.view addSubview:self.vcOrganAuthCommitOk.view];
            return;
        }
    }
    
    [self changeToCurrent:self.typeCell];
}

#pragma mark ---- 根据typeCell传参决定UI构造 ----

-(void)changeToCurrent:(NSString *)typeCell
{
    if([typeCell isEqualToString:@"0"]){
        [self allCoupn:nil];
    }else if([typeCell isEqualToString:@"1"]){
        [self product:nil];
    }else if([typeCell isEqualToString:@"2"]){
        [self coupn:nil];
    }
}

#pragma mark ---- 设置 tableView ----

- (void)setUpTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,44, APP_W, APP_H-NAV_H-44) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGBHex(qwColor11);
    [self.view addSubview:self.tableView];
}

#pragma mark ---- 设置 按钮样式 ----

- (void)configureButtonStyle
{
    self.alltouchButton.layer.masksToBounds = YES;
    self.alltouchButton.layer.cornerRadius = 3.0f;
    
    self.coupnProductButton.layer.masksToBounds = YES;
    self.coupnProductButton.layer.cornerRadius = 3.0f;
    
    self.coupnTouchButton.layer.masksToBounds = YES;
    self.coupnTouchButton.layer.cornerRadius = 3.0f;
    
    self.exchangeProductButton.layer.masksToBounds = YES;
    self.exchangeProductButton.layer.cornerRadius = 3.0;
}

#pragma mark ---- 点击 全部按钮 ----

- (IBAction)allCoupn:(id)sender
{
    [self.tableView setFrame:CGRectMake(0, 44, APP_W, APP_H-NAV_H-44)];
    
    [self.alltouchButton setBackgroundColor:RGBHex(qwColor1)];
    [self.alltouchButton setTitleColor:RGBHex(qwColor4) forState:UIControlStateNormal];
    
    [self.coupnTouchButton setBackgroundColor:RGBHex(qwColor11)];
    [self.coupnTouchButton setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
    
    [self.coupnProductButton setBackgroundColor:RGBHex(qwColor11)];
    [self.coupnProductButton setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
    
    [self.exchangeProductButton setBackgroundColor:RGBHex(qwColor11)];
    [self.exchangeProductButton setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
    
    self.tapButtonType = Enum_Tip_All;
    [self setupHeaderView:Enum_Tip_All];
    [self branchMyorder:Enum_Tip_All source:nil coupnType:nil];
}

#pragma mark ---- 点击 优惠商品 ----

- (IBAction)product:(id)sender
{
    [self.tableView setFrame:CGRectMake(0, 88, APP_W, APP_H-NAV_H-88)];
    
    [self.coupnProductButton setBackgroundColor:RGBHex(qwColor1)];
    [self.coupnProductButton setTitleColor:RGBHex(qwColor4) forState:UIControlStateNormal];
    
    [self.coupnTouchButton setBackgroundColor:RGBHex(qwColor11)];
    [self.coupnTouchButton setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
    
    [self.alltouchButton setBackgroundColor:RGBHex(qwColor11)];
    [self.alltouchButton setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
    
    [self.exchangeProductButton setBackgroundColor:RGBHex(qwColor11)];
    [self.exchangeProductButton setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
    
    self.tapButtonType = Enum_Tip_Product;
    [self setupHeaderView:Enum_Tip_Product];
    [self branchMyorder:Enum_Tip_Product source:nil coupnType:nil];
}

#pragma mark ---- 点击 优惠券 ----

- (IBAction)coupn:(id)sender
{
    [self.tableView setFrame:CGRectMake(0, 88, APP_W, APP_H-NAV_H-88)];
    
    [self.coupnTouchButton setBackgroundColor:RGBHex(qwColor1)];
    [self.coupnTouchButton setTitleColor:RGBHex(qwColor4) forState:UIControlStateNormal];
    
    [self.alltouchButton setBackgroundColor:RGBHex(qwColor11)];
    [self.alltouchButton setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
    
    [self.coupnProductButton setBackgroundColor:RGBHex(qwColor11)];
    [self.coupnProductButton setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
    
    [self.exchangeProductButton setBackgroundColor:RGBHex(qwColor11)];
    [self.exchangeProductButton setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
    
     self.tapButtonType = Enum_Tip_Coupn;
    [self setupHeaderView:Enum_Tip_Coupn];
    [self branchMyorder:Enum_Tip_Coupn source:nil coupnType:nil];
}

#pragma mark ---- 点击 兑换商品 ----

- (IBAction)exchangeProduct:(id)sender
{
    [self.tableView setFrame:CGRectMake(0, 44, APP_W, APP_H-NAV_H-44)];
    
    [self.exchangeProductButton setBackgroundColor:RGBHex(qwColor1)];
    [self.exchangeProductButton setTitleColor:RGBHex(qwColor4) forState:UIControlStateNormal];
    
    [self.coupnTouchButton setBackgroundColor:RGBHex(qwColor11)];
    [self.coupnTouchButton setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
    
    [self.coupnProductButton setBackgroundColor:RGBHex(qwColor11)];
    [self.coupnProductButton setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
    
    [self.alltouchButton setBackgroundColor:RGBHex(qwColor11)];
    [self.alltouchButton setTitleColor:RGBHex(qwColor6) forState:UIControlStateNormal];
    
    self.tapButtonType = Enum_Tip_Exchange;
    [self setupHeaderView:Enum_Tip_Exchange];
    [self queryExchangeList];
}

#pragma mark ---- 设置 头部展开列表 ----

- (void)setupHeaderView:(NSInteger)type
{
    if(type == Enum_Tip_Coupn)
    {
        //优惠券订单
        
        UIView *onlyheaderView =[self.view viewWithTag:1009];
        UIView *allheaderView =[self.view viewWithTag:1008];
        onlyheaderView.hidden=YES;
        allheaderView.hidden=NO;
        
        [onlyComboxView dismissView];
        
        UIImageView *headerView = nil;
        
        if(![self.view viewWithTag:1008])
        {
            headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, APP_W, 44)];
            headerView.tag = 1008;
            headerView.userInteractionEnabled = YES;
            headerView.backgroundColor = RGBHex(qwColor4);
            
            // 分割线
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, APP_W, 0.5)];
            line.backgroundColor = RGBHex(qwColor10);
            [headerView addSubview:line];

            rightButton = [[RightAccessButton alloc] initWithFrame:CGRectMake(0, 0, APP_W, 40)];
            [headerView addSubview:rightButton];
            
            UIImageView *accessView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
            [accessView2 setImage:[UIImage imageNamed:@"icon_downArrow"]];
            
            rightButton.accessIndicate = accessView2;
            [rightButton setCustomColor:RGBHex(qwColor7)];
            [rightButton setButtonTitle:@"全部来源"];
            [rightButton addTarget:self action:@selector(showRightTipTable:) forControlEvents:UIControlEventTouchDown];
            
            rightComboxView = [[ComboxView alloc] initWithFrame:CGRectMake(0, 88, APP_W, [self.rightMenuItems count]*46)];
            rightComboxView.delegate = self;
            rightComboxView.comboxDeleagte = self;
            
            rightIndex = 0;
            
        }else
        {
            headerView = (UIImageView *)[self.view viewWithTag:1008];
        }
        
        [self.view addSubview:headerView];
    
    }else if(type == Enum_Tip_Product)
    {
        //优惠商品订单
        
        UIView *onlyheaderView =[self.view viewWithTag:1009];
        UIView *allheaderView =[self.view viewWithTag:1008];
        onlyheaderView.hidden=NO;
        allheaderView.hidden=YES;
        
        [rightComboxView dismissView];
        
        UIImageView *headerView = nil;
        
        if(![self.view viewWithTag:1009])
        {
            headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, APP_W, 44)];
            headerView.tag = 1009;
            headerView.userInteractionEnabled = YES;
            headerView.backgroundColor = RGBHex(qwColor4);
            
            // 分割线
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, APP_W, 0.5)];
            line.backgroundColor = RGBHex(qwColor10);
            [headerView addSubview:line];
            
            onlyButton = [[RightAccessButton alloc] initWithFrame:CGRectMake(0, 0, APP_W, 40)];
            [headerView addSubview:onlyButton];
            
            UIImageView *accessView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
            [accessView1 setImage:[UIImage imageNamed:@"icon_downArrow"]];
            
            onlyButton.accessIndicate = accessView1;
            [onlyButton setCustomColor:RGBHex(qwColor7)];
            [onlyButton setButtonTitle:@"全部来源"];
            [onlyButton addTarget:self action:@selector(showOnlyTipTable:) forControlEvents:UIControlEventTouchDown];
            
            onlyComboxView = [[ComboxView alloc] initWithFrame:CGRectMake(0, 88, APP_W, [self.onlyMenuItems count]*46)];
            onlyComboxView.delegate = self;
            onlyComboxView.comboxDeleagte = self;
  
            onlyIndex = 0;

        }else
        {
            headerView = (UIImageView *)[self.view viewWithTag:1009];
        }
        
        [self.view addSubview:headerView];
    
    }else
    {
        //全部订单
        UIView *onlyheaderView =[self.view viewWithTag:1009];
        UIView *allheaderView =[self.view viewWithTag:1008];
        
        onlyheaderView.hidden=YES;
        allheaderView.hidden=YES;

        [rightComboxView dismissView];
        [onlyComboxView dismissView];
    }
}

#pragma mark ---- 优惠券 全部来源 列表展开 ----

- (void)showRightTipTable:(id)sender
{
    if(rightButton.isToggle) {
        [rightComboxView dismissView];
        [rightButton changeArrowDirectionUp:NO];
    }else{
        [rightButton setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
        [rightComboxView showInView:self.view];
        [rightButton changeArrowDirectionUp:YES];
        rightButton.isToggle = YES;
    }
}

#pragma mark ---- 优惠商品 全部来源 列表展开 ----

- (void)showOnlyTipTable:(id)sender
{
    if(onlyButton.isToggle){
        [onlyComboxView dismissView];
        [onlyButton setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
        [onlyButton changeArrowDirectionUp:NO];
        onlyButton.isToggle = NO;
    }else{
        [onlyButton setTitleColor:RGBHex(qwColor1) forState:UIControlStateNormal];
        [onlyComboxView showInView:self.view];
        [onlyButton changeArrowDirectionUp:YES];
        onlyButton.isToggle = YES;
    }
}

#pragma mark ---- comboxView Delegate ----

- (void)comboxViewWillDisappear:(ComboxView *)comboxView
{
    if([comboxView isEqual:onlyComboxView])
    {
        // 优惠商品 全部来源
        [onlyButton changeArrowDirectionUp:NO];
        [onlyButton setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
        onlyButton.isToggle = NO;
    }else
    {
        if([comboxView isEqual:rightComboxView]){
            
            // 优惠券 全部来源
            [rightButton changeArrowDirectionUp:NO];
            [rightButton setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
            rightButton.isToggle = NO;
        }
    }
}

#pragma mark ---- 列表代理 ----

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([tableView isEqual:self.tableView])
    {
        if (self.tapButtonType == Enum_Tip_Exchange) {
            return 1;
        }else{
            return 2;
        }
    }else{
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView isEqual:self.tableView])
    {
        if (self.tapButtonType == Enum_Tip_Exchange) {
            return self.exchangeList.count;
        }else{
            if(section == 0){
                // 没有上传小票
                return self.noTipList.count;
            }else{
                //  已上传小票
                return self.hasTipList.count;
            }
        }
        
    }else if([tableView isEqual:onlyComboxView.tableView])
    {
        //  优惠商品 全部来源
        return [self.onlyMenuItems count];
    }
    else{
        // 优惠券 全部来源
        return [self.rightMenuItems count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.tableView])
    {
        if (self.tapButtonType == Enum_Tip_Exchange) {
            return [ExchangeProductCell getCellHeight:nil];
        }else{
            NSDictionary *branchclass = nil;
            if(indexPath.section == 0){
                branchclass = self.noTipList[indexPath.row];
            }else{
                branchclass = self.hasTipList[indexPath.row];
            }
            
            if([branchclass[@"type"] isEqualToString:@"Q"])
            {
                // 券
                if(!StrIsEmpty(branchclass[@"giftImgUrl"]))
                {
                    // 礼品券
                    return [ThreeCoupnTableViewCell getCellHeight:nil];
                }else
                {
                    // 其他券
                    return [FirstCoupnTableViewCell getCellHeight:nil];
                }
            }else
            {
                // 商品
                return [SecondProductTableViewCell getCellHeight:nil];
            }
        }
    
    }else
    {
        return [ComboxViewCell getCellHeight:nil];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([tableView isEqual:self.tableView])
    {
        // 主列表
        static NSString *identifier=@"FirstCoupnCell";
        FirstCoupnTableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        
        static NSString *Secondidentifier=@"SecondProductCell";
        SecondProductTableViewCell *SecondCell=[tableView dequeueReusableCellWithIdentifier:Secondidentifier];
        
        static NSString *Threeidentifier=@"ThreeCoupnCell";
        ThreeCoupnTableViewCell *ThreeCell=[tableView dequeueReusableCellWithIdentifier:Threeidentifier];
        
        static NSString *Exchangeidentifier=@"ExchangeProductCell";
        ExchangeProductCell *exchangeCell=[tableView dequeueReusableCellWithIdentifier:Exchangeidentifier];
        
        if (Cell==nil) {
            Cell=[[NSBundle mainBundle]loadNibNamed:@"FirstCoupnTableViewCell" owner:self options:nil][0];
        }
        if (SecondCell==nil) {
            SecondCell=[[NSBundle mainBundle]loadNibNamed:@"SecondProductTableViewCell" owner:self options:nil][0];
        }
        
        if (ThreeCell==nil) {
            ThreeCell=[[NSBundle mainBundle]loadNibNamed:@"ThreeCoupnTableViewCell" owner:self options:nil][0];
        }
        
        if (exchangeCell==nil) {
            exchangeCell=[[NSBundle mainBundle]loadNibNamed:@"ExchangeProductCell" owner:self options:nil][0];
        }
        
        Cell.contentView.backgroundColor=RGBHex(qwColor11);
        SecondCell.contentView.backgroundColor=RGBHex(qwColor11);
        ThreeCell.contentView.backgroundColor=RGBHex(qwColor11);
        
        if (self.tapButtonType == Enum_Tip_Exchange)
        {            
            if (self.exchangeList && self.exchangeList.count > 0) {
                ExchangeProModel *model = self.exchangeList[indexPath.row];
                [exchangeCell setData:model];
            }
            
            return exchangeCell;
        }else
        {
            if (indexPath.section==0)
            {
                // 未上传小票的数据
                NSDictionary *branchclass=self.noTipList[indexPath.row];
                if([branchclass[@"type"] isEqualToString:@"Q"]){
                    // 优惠券
                    if(!StrIsEmpty(branchclass[@"giftImgUrl"])){//礼品券
                        [ThreeCell setCell:branchclass];
                        return ThreeCell;
                    }else{ // 其他券
                        [Cell setCell:branchclass];
                        return Cell;
                    }
                }else{
                    // 优惠商品
                    [SecondCell setCell:branchclass];
                    return SecondCell;
                }
            }else
            {
                // 已上传小票的数据
                NSDictionary *branchclass=self.hasTipList[indexPath.row];
                if([branchclass[@"type"] isEqualToString:@"Q"]){
                    // 优惠券
                    if(!StrIsEmpty(branchclass[@"giftImgUrl"])){//礼品券
                        [ThreeCell setCell:branchclass];
                        return ThreeCell;
                    }else{ // 其他券
                        [Cell setCell:branchclass];
                        return Cell;
                    }
                }else{
                    // 优惠商品
                    [SecondCell setCell:branchclass];
                    return SecondCell;
                }
            }
        }
        
    }
    else
    {
        // 头部展开列表
        static NSString *MenuIdentifier = @"MenuIdentifier";
        ComboxViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MenuIdentifier];
        if (cell == nil){
            cell = [[ComboxViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MenuIdentifier];
            cell.textLabel.font = fontSystem(kFontS4);
            cell.textLabel.textColor = RGBHex(qwColor7);
            CGRect rect = cell.textLabel.frame;
            rect.origin.x = 15.0f;
            cell.textLabel.frame = rect;
        }
        NSString *content = nil;
        BOOL showImage = NO;
        
        if([tableView isEqual:rightComboxView.tableView])
        {
            // 优惠券 全部来源
            content = self.rightMenuItems[indexPath.row];
            if(indexPath.row == rightIndex) {
                showImage = YES;
            }
        }else
        {
            // 优惠商品 全部来源
            content = self.onlyMenuItems[indexPath.row];
            if(indexPath.row == onlyIndex) {
                showImage = YES;
            }
        }
        
        [cell setCellWithContent:content showImage:showImage];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([tableView isEqual:self.tableView])
    {
        if (self.tapButtonType == Enum_Tip_Exchange) {
            return 0.1;
        }else
        {
            if(section == 0){
                if(self.noTipList.count == 0){
                    return 0;
                }else{
                    return 40;
                }
            }else{
                if(self.hasTipList.count == 0){
                    return 0;
                }else{
                    return 40;
                }
            }
        }
    
    }else
    {
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if([tableView isEqual:self.tableView])
    {
        if (self.tapButtonType == Enum_Tip_Exchange)
        {
            UIView *view=[[UIView alloc]init];
            return view;
        }else
        {
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_W, 40)];
            [view setBackgroundColor:RGBHex(qwColor11)];
            UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(0, 12, APP_W, 15)];
            
            NSString *str= nil;
            if (section==0) {
                str=[NSString stringWithFormat:@"本店共消费优惠%d笔,未上传小票%d笔",totalRecords,noRecords];
            }else{
                str=[NSString stringWithFormat:@"已上传小票%d笔",hasRecords];
            }
            
            CGSize size=[str boundingRectWithSize:CGSizeMake(APP_W-30, 1000) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil].size;
            UIView *viewone=[[UIView alloc]initWithFrame:CGRectMake(15, 20, (APP_W-60-size.width)/2, 0.5)];
            UIView *viewtwo=[[UIView alloc]initWithFrame:CGRectMake(APP_W-15-(APP_W-60-size.width)/2, 20, (APP_W-60-size.width)/2, 0.5)];
            viewone.backgroundColor=RGBHex(qwColor10);
            viewtwo.backgroundColor=RGBHex(qwColor10);
            
            [view addSubview:viewone];
            [view addSubview:viewtwo];
            lable.text=str;
            
            lable.textColor=RGBHex(qwColor8);
            lable.font=fontSystem(kFontS5);
            lable.textAlignment=NSTextAlignmentCenter;
            [view addSubview:lable];
            return view;
        }
        
    }else{
        UIView *view=[[UIView alloc]init];
        return view;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
        [SVProgressHUD showErrorWithStatus:kWaring33 duration:0.8f];
        return;
    }
    
    if([tableView isEqual:self.tableView])
    {
        if (self.tapButtonType == Enum_Tip_Exchange) {
            
        }else{
            // 主列表
            NSDictionary *model;
            if (indexPath.section == 0){ // 未上传小票
                model = self.noTipList[indexPath.row];
            }else{ // 已上传小票
                model = self.hasTipList[indexPath.row];
            }
            
            TipDetailViewController *vc = [[UIStoryboard storyboardWithName:@"TipStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"TipDetailViewControllerId"];
            vc.hidesBottomBarWhenPushed = YES;
            vc.orderId = model[@"orderId"];
            if([model[@"type"] isEqualToString:@"Q"]){
                vc.type = @2;
            }else{
                vc.type = @1;
            }
            vc.typeCell = self.typeCell;//delegate传值
            vc.changedele = self;
            vc.scope = model[@"scope"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if ([tableView isEqual:rightComboxView.tableView])
    {
        // 优惠券 全部来源
        rightIndex = indexPath.row;
        [rightButton setButtonTitle:self.rightMenuItems[indexPath.row]];
        [rightComboxView dismissView];
        [self branchMyorder:Enum_Tip_Coupn source:[NSNumber numberWithInteger:(indexPath.row)] coupnType:nil];
        [rightComboxView.tableView reloadData];
        
    }else
    {
        //优惠商品 全部来源
        onlyIndex = indexPath.row;
        [onlyButton setButtonTitle:self.onlyMenuItems[indexPath.row]];
        [onlyComboxView dismissView];
        [onlyButton setTitleColor:RGBHex(qwColor7) forState:UIControlStateNormal];
        [self branchMyorder:Enum_Tip_Product source:[NSNumber numberWithInteger:(indexPath.row)] coupnType:nil];
        [onlyComboxView.tableView reloadData];
    }
}

#pragma mark ---- 请求订单列表 ----

-(void)branchMyorder:(NSInteger)typeclick source:(NSNumber*)source coupnType:(NSNumber*)coupnType
{
    [self removeInfoView];
    
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }
    
    self.typeCell = [NSString stringWithFormat:@"%ld",(long)typeclick];
    
    //typeclick 0全部 1 优惠商品 2优惠券
    
    TipsListModelR *branchR = [TipsListModelR new];
    branchR.token = QWGLOBALMANAGER.configure.userToken;
    branchR.type = typeclick;
    branchR.couponType = coupnType;
    
    if(typeclick == Enum_Tip_Product){  //优惠商品
        
        switch (onlyIndex) {
            case 0:
            {
                branchR.source = @0;
                break;
            }
            case 1:
            {
                branchR.source = @2;
                break;
            }
            case 2:
            {
                branchR.source = @1;
                break;
            }
            default:
                break;
        }
    }else if(typeclick == Enum_Tip_Coupn){  // 优惠券
                
        switch (rightIndex) {
            case 0:
            {
                branchR.source = @0;
                break;
            }
            case 1:
            {
                branchR.source = @2;
                break;
            }
            case 2:
            {
                branchR.source = @1;
                break;
            }
            default:
                break;
        }
    }else{  // 全部
         branchR.source = @0;
         branchR.couponType = @0;
    }
    
    [Tips GetAllTipsWithParams:branchR success:^(id responseObj) {
        
        if ([responseObj[@"totalOrderCount"] intValue] == 0) {
            if(typeclick == Enum_Tip_All){
                [self showInfoView:@"暂无优惠的消费记录" image:@"img_preferential" flatY:44];
                return ;
            }else if (typeclick == Enum_Tip_Exchange) {
                [self showInfoView:@"暂无兑换商品～" image:@"img_preferential" flatY:44];
                return ;
            }else {
                [self showInfoView:@"暂无优惠的消费记录" image:@"img_preferential" flatY:88];
                return ;
            }
            
        }else{
            
            [self.exchangeList removeAllObjects];
            [self.noTipList removeAllObjects];
            [self.hasTipList removeAllObjects];

            [self.noTipList addObjectsFromArray:responseObj[@"noreceiptOrderList"]];
            [self.hasTipList addObjectsFromArray:responseObj[@"receiptOrderList"]];
            totalRecords = [responseObj[@"totalOrderCount"] intValue];
            noRecords = [responseObj[@"noreceiptOrderCount"] intValue];
            hasRecords = [responseObj[@"receiptOrderCount"] intValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        
    } failure:^(HttpException *e) {
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [self showInfoView:kWaring12 image:@"img_network"];
        }else
        {
            if(e.errorCode != -999){
                if(e.errorCode == -1001){
                    [self showInfoView:kWarning215N54 image:@"ic_img_fail"];
                }else{
                    [self showInfoView:kWarning215N0 image:@"ic_img_fail"];
                }
            }
        }
    }];
    
}

- (void)queryExchangeList
{
    [self removeInfoView];
    
    if(QWGLOBALMANAGER.currentNetWork == kNotReachable){
        [self showInfoView:kWaring12 image:@"img_network"];
        return;
    }
    
    NSMutableDictionary *setting = [NSMutableDictionary dictionary];
    setting[@"token"] = StrFromObj(QWGLOBALMANAGER.configure.userToken);
    
    [Order mallOrderByBranchWithParams:setting success:^(id obj) {
        
        ExchangeListModel *list = [ExchangeListModel parse:obj Elements:[ExchangeProModel class] forAttribute:@"orders"];
        
        if ([list.apiStatus integerValue] == 0) {
            if (list.orders.count > 0) {
                
                [self.noTipList removeAllObjects];
                [self.hasTipList removeAllObjects];
                [self.exchangeList removeAllObjects];
                [self.exchangeList addObjectsFromArray:list.orders];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }else{
            [self showInfoView:@"暂无兑换商品～" image:@"img_preferential" flatY:44];
        }
       
    } failure:^(HttpException *e) {
        if (QWGLOBALMANAGER.currentNetWork == kNotReachable) {
            [self showInfoView:kWaring12 image:@"img_network"];
        }else
        {
            if(e.errorCode != -999){
                if(e.errorCode == -1001){
                    [self showInfoView:kWarning215N54 image:@"ic_img_fail"];
                }else{
                    [self showInfoView:kWarning215N0 image:@"ic_img_fail"];
                }
            }
        }
    }];

}

@end
